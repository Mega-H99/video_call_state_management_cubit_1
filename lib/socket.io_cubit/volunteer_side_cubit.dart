



import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:rtc_grad_blind_app_qwerty/socket.io_cubit/blind_states.dart';
import 'package:rtc_grad_blind_app_qwerty/socket.io_cubit/volunteer_states.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../volunteer_call_model_screens/volunteer_entering_video_call_screen.dart';
import '../volunteer_call_model_screens/volunteer_in_call_screen.dart';
import '../volunteer_call_model_screens/volunteer_leaving_Video_call_screen.dart';
import '../volunteer_call_model_screens/volunteer_waiting_screen.dart';
import '../volunteer_call_model_screens/volunteer_ringing_screen.dart';


class VolunteerCubitSide extends Cubit<VolunteerStates>{
  VolunteerCubitSide() : super(VolunteerInitialState());

  static VolunteerCubitSide get(context) => BlocProvider.of(context);

  List<Widget> volunteerCallWidgets = [
    VolunteerNotReadyScreen(),         //0
    VolunteerWaitingScreen(),            //1
    VolunteerCallingScreen(),          //2
    VolunteerInCallScreen(),           //3
    VolunteerLeavingVideoCallScreen(), //4


  ];
  int screenIndex = 0;

  String? _blindId;
  String? _volunteerId;
  bool isBusy = false;
  String? _volunteerSdp;
  Map<String, dynamic>? _firstCandidate;
  late String blindSdp;

  bool _offer = false;
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  RTCVideoRenderer localRenderer = RTCVideoRenderer();
  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();

  late Socket socket;

  AudioPlayer audioPlayer = AudioPlayer();
  PlayerState playerState = PlayerState.PAUSED;
  AudioCache? audioCache;
  String path = 'app_running.mp3';


  bool isMuted = false;
  bool isDeafened = false;
  bool isVideoOff = false;
  bool noAnswer= true;

  IconData muted = Icons.mic;
  IconData deafened = Icons.headset;
  IconData videoOff = Icons.videocam;

  playMusic() async {
    await audioCache?.loop(path);

    emit(VolunteerPlayMusicState());
  }

  pauseMusic() async {
    await audioPlayer.pause();
    emit(VolunteerPauseMusicState());
  }

  initRenderer() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
  }

  destroyMe() {
    localRenderer.dispose();
    remoteRenderer.dispose();
    socket.disconnect();
    audioPlayer.release();
    audioPlayer.dispose();
    audioCache?.clearAll();
    emit(VolunteerDisposeState());
  }


  initializeMe() {
    initRenderer();
    _initSocketConnection();
    _createPeerConnection().then((pc) {
      _peerConnection = pc;
    });
    audioCache = AudioCache(fixedPlayer: audioPlayer);
    audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
      playerState = s;
      emit(VolunteerPlayerStateChangedState());
    });
    // _getUserMedia();
    emit(VolunteerFullInitializedState());
  }

  void _initSocketConnection() {
    socket = io(
      'http://localhost:5000',
      // 'http://3264-41-233-95-226.ngrok.io ',
      OptionBuilder().setTransports(['websocket']) // for Flutter or Dart VM
          .build(),
    ).open();
    socket.onConnect((_) {
      print("connected");
      _volunteerId = socket.id;
      print("connected to room with id:$_volunteerId");

      // print("isBlind: ${widget.isBlind}");
      socket.emit("volunteer: connect to room");
      socket
          .on("server: send blind connection to all volunteers to create offer",
              (blindData) {
            blindData = blindData as Map<String, dynamic>;
            blindSdp = blindData['sdp']! as String;
            _blindId = blindData['id']! as String;
            print('recieving sdp');
             if (!isBusy) {
               playerState == PlayerState.PLAYING;
               playMusic();
               screenIndex=2;
               emit(VolunteerReceivingCall());
               Future.delayed(const Duration(seconds: 60), () {
                 if(noAnswer){
                   pauseMusic();
                   screenIndex=1;
                   emit(VolunteerCallingTimeoutState());
                 }
                 noAnswer = true;
               });

               }
                   });
    });
    socket.on("server: other volunteer accepted call", (_) {
      if (!isBusy) {
        screenIndex=1;
        pauseMusic();
      }
    });
    socket.on("server: blind Call ended", (_) {
      screenIndex=1;
      pauseMusic();
    });
  }

  _createPeerConnection() async {
    Map<String, dynamic> configuration = {
      "iceServers": [
        {"url": "stun:stun.l.google.com:19302"},
      ]
    };

    final Map<String, dynamic> offerSdpConstraints = {
      "mandatory": {
        "OfferToReceiveAudio": true,
        "OfferToReceiveVideo": true,
      },
      "optional": [],
    };

    _localStream = await _getUserMedia();

    RTCPeerConnection pc =
    await createPeerConnection(configuration, offerSdpConstraints);

    pc.addStream(_localStream!);

    pc.onIceCandidate = (RTCIceCandidate e) {
      if (e.candidate != null && _firstCandidate == null) {
        Map<String, dynamic> candidateConstraints = {
          'candidate': e.candidate.toString(),
          'sdpMid': e.sdpMid.toString(),
          'sdpMlineIndex': e.sdpMlineIndex,
        };

        _firstCandidate = candidateConstraints;

        print(candidateConstraints);
        print("_blindId= $_blindId");

        if (_blindId != null) {
          Map<String, dynamic> candidateInvitation = {
            "candidate": candidateConstraints,
            "sdp": _volunteerSdp,
            "blindId": _blindId!,
          };

          socket.emit(
            'volunteer: send sdp, candidate and blind id',
            candidateInvitation,
          );
          print('sending sdp...');
          // socket.disconnect();
        }
      }
    };

    pc.onIceConnectionState = (e) {
      print(e);
    };

    pc.onAddStream = (stream) {
      print('addStream: ' + stream.id);
      remoteRenderer.srcObject = stream;
    };

    return pc;

  }

  _getUserMedia() async {
    final Map<String, dynamic> constraints = {
      'audio': true,
      'video': {
        'facingMode': 'user',
      },
    };

    MediaStream stream = await navigator.mediaDevices.getUserMedia(constraints);

    localRenderer.srcObject = stream;
    // _localRenderer.mirror = true;

    return stream;
  }

  void createAnswer() async {
    _handleReceivingBlindCandidate();

    RTCSessionDescription description =
    await _peerConnection!.createAnswer({'offerToReceiveVideo': 1});
    if (description.sdp != null) _volunteerSdp = description.sdp;

    _peerConnection!.setLocalDescription(description);

    emit(VolunteerCreateAnswerState());

  }

  Future<void> setRemoteDescription(String sdp) async {
    // RTCSessionDescription description =
    //     new RTCSessionDescription(session['sdp'], session['type']);
    RTCSessionDescription description =
    RTCSessionDescription(sdp, _offer ? 'answer' : 'offer');

    await _peerConnection!.setRemoteDescription(description);
    print('remote description is set');

    emit(VolunteerSettingRemoteDescriptionState());
  }

  void _handleReceivingBlindCandidate() {
    socket.on('server: send blind candidate', (blindCandidate) async {
      blindCandidate = blindCandidate as Map<String, dynamic>;

      print(blindCandidate['candidate']);
      RTCIceCandidate candidate = RTCIceCandidate(
        blindCandidate['candidate'],
        blindCandidate['sdpMid'],
        blindCandidate['sdpMlineIndex'],
      );
      await _peerConnection!.addCandidate(candidate);
    });
    emit(VolunteerReceivingBlindRemoteInfo());
  }



  void mute() {
    if (!isDeafened) {
      isMuted = !isMuted;
      _localStream!.getAudioTracks()[0].enabled =
      !_localStream!.getAudioTracks()[0].enabled;
    }
    muted = isMuted ? Icons.mic_off : Icons.mic;

    emit(VolunteerChangeMuteState());
  }

  void deafen() {
    if ((_localStream!.getAudioTracks()[0].enabled &&
        _peerConnection!
            .getRemoteStreams()[0]!
            .getAudioTracks()[0]
            .enabled) ||
        (!_localStream!.getAudioTracks()[0].enabled &&
            !_peerConnection!
                .getRemoteStreams()[0]!
                .getAudioTracks()[0]
                .enabled)) {
      _localStream!.getAudioTracks()[0].enabled =
      !_localStream!.getAudioTracks()[0].enabled;

      _peerConnection!.getRemoteStreams()[0]!.getAudioTracks()[0].enabled =
      !_peerConnection!.getRemoteStreams()[0]!.getAudioTracks()[0].enabled;

      if (_localStream!.getAudioTracks()[0].enabled) {
        isMuted = false;
      } else if (!_localStream!.getAudioTracks()[0].enabled) {
        isMuted = true;
      }
      if (_peerConnection!.getRemoteStreams()[0]!.getAudioTracks()[0].enabled) {
        isDeafened = false;
      } else if (!_peerConnection!
          .getRemoteStreams()[0]!
          .getAudioTracks()[0]
          .enabled) {
        isDeafened = true;
      }
    } else if (!_localStream!.getAudioTracks()[0].enabled &&
        _peerConnection!.getRemoteStreams()[0]!.getAudioTracks()[0].enabled) {
      _peerConnection!.getRemoteStreams()[0]!.getAudioTracks()[0].enabled =
      !_peerConnection!.getRemoteStreams()[0]!.getAudioTracks()[0].enabled;

      isDeafened = true;
    }
    deafened = isDeafened ? Icons.headset_off : Icons.headset;
    muted = isMuted ? Icons.mic_off : Icons.mic;
    emit(VolunteerChangeDeafenState());
  }

  void switchCamera() async {

    await _localStream!.getVideoTracks()[0].switchCamera();
    emit(VolunteerChangeCameraState());

  }

  void videoChange() {
    videoOff = isVideoOff ? Icons.videocam_off : Icons.videocam;
    if (isVideoOff) {
      _localStream!.getVideoTracks()[0].enabled =
      !_localStream!.getVideoTracks()[0].enabled;
    }

    emit(VolunteerChangeVideoState());
  }

  void smallDispose() {
    // socket.emit("volunteer: Call ended", _blindId);
        // isBusy = false;
        // changer = false;
        // _remoteRenderer.srcObject = null;
    // socket.emit("volunteer: Call ended", blindID);
     emit(VolunteerCloseCallState());

    }


}
