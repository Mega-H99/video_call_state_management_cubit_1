
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../socket.io_cubit/blind_side_cubit.dart';
import '../socket.io_cubit/blind_states.dart';

class BlindInCallScreen extends StatelessWidget {
  const BlindInCallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            BlindCubitSide.get(context).mute();
            print('Mute is Pressed');
            if (BlindCubitSide.get(context).isMute) {
              BlindCubitSide.get(context).speak('Mic off');
            } else {
              BlindCubitSide.get(context).speak('Mic on');
            }
          },
          onDoubleTap: () {
            BlindCubitSide.get(context).deafen();
            print('Deafen is pressed');
            if (BlindCubitSide.get(context).isDeafen) {
              BlindCubitSide.get(context).speak('Speakers on');
            } else {
              BlindCubitSide.get(context).speak('Speakers off');
            }
          },
          onLongPress: () {
            print('Close Call');
            BlindCubitSide.get(context).speak('Closing  call');
            BlindCubitSide.get(context).screenIndex=4;
            BlindCubitSide.get(context).smallDispose();

          },
          // onVerticalDragEnd: (Details){
          //   print('Switch Camera');
          //   _speak('Switching camera');
          //   _switchCamera();
          // },
          onHorizontalDragEnd: (details) {
            print('Video Off');
            BlindCubitSide.get(context).videoChange();
            if (BlindCubitSide.get(context).isVideoOff) {
              BlindCubitSide.get(context).speak('Video off');
            } else {
              BlindCubitSide.get(context).speak('Video on');
            }
          },

          child: SizedBox(
              height: 500,
              child: Row(children: [
                Flexible(
                  child: Container(
                      key:  const Key("local"),
                      margin:  const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                      decoration:  const BoxDecoration(color: Colors.black),
                      child:  RTCVideoView(
                        BlindCubitSide.get(context).localRenderer,
                        mirror: true,
                      )),
                ),
                Flexible(
                  child:  Container(
                      key:  const Key("remote"),
                      margin:  const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                      decoration: const BoxDecoration(color: Colors.black),
                      child:  RTCVideoView(
                        BlindCubitSide.get(context).remoteRenderer,
                      )),
                ),
              ])),
        ),
         SizedBox(
          height: 30.0,
        ),
         BlocConsumer<BlindCubitSide,BlindStates>(
          listener: (context, state) {},
          builder: (context, state) {
           return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              CircleAvatar(
                key:  Key('Mute Operator'),
                backgroundColor: Colors.black,
                child: Icon(
                BlindCubitSide.get(context).muted,
                color: BlindCubitSide.get(context).colorMuted,
              ),
            ),
            CircleAvatar(
              key:   Key('Deafen Operator'),
              backgroundColor: Colors.black,
              child: Icon(
                 BlindCubitSide.get(context).deafened,
                 color: BlindCubitSide.get(context).colorDeafen,
              ),
             ),
            CircleAvatar(
              key:  Key('Camera Operator'),
              backgroundColor: Colors.black,
              child: Icon(
                BlindCubitSide.get(context).whichCamera,
                color: Colors.white,
              ),
            ),
            CircleAvatar(
              key:  Key('VideoOff Operator'),
              backgroundColor: Colors.black,
              child: Icon(
                BlindCubitSide.get(context).videoOff,
                color: BlindCubitSide.get(context).colorVideoOff,
              ),
            ),
             const CircleAvatar(
              key: Key('Close Call Operator'),
              backgroundColor: Colors.black,
              child: Icon(
                Icons.call_end,
                color: Colors.red,
              ),
            ),
          ],
        );}),
      ],
    );

  }
}
