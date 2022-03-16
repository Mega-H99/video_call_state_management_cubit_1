
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:rtc_grad_blind_app_qwerty/socket.io_cubit/volunteer_side_cubit.dart';

import '../socket.io_cubit/blind_side_cubit.dart';
import '../socket.io_cubit/blind_states.dart';
import '../socket.io_cubit/volunteer_states.dart';

class VolunteerInCallScreen extends StatelessWidget {
  const VolunteerInCallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
        height: 500,
        child: Row(children: [
          Flexible(
            child:  Container(
                key: const Key("local"),
                margin: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                decoration: const BoxDecoration(color: Colors.black),
                child:  RTCVideoView(
                  VolunteerCubitSide.get(context).localRenderer,
                  mirror: true,
                )),
          ),
          Flexible(
            child: Container(
                key: const Key("remote"),
                margin: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                decoration: const BoxDecoration(color: Colors.black),
                child: RTCVideoView(VolunteerCubitSide.get(context).remoteRenderer)),
          )
        ])),
        const SizedBox(
          height: 20.0,
        ),
        BlocConsumer<VolunteerCubitSide,VolunteerStates>(
        listener: (context, state) {},
        builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          CircleAvatar(
              backgroundColor: Colors.black,
            child: IconButton(
              onPressed: () {
                VolunteerCubitSide.get(context).mute();
              },
              icon: Icon(
                VolunteerCubitSide.get(context).muted,
                color: VolunteerCubitSide.get(context).isMuted ? Colors.red : Colors.white,
                ),
                  ),
          ),
      CircleAvatar(
        backgroundColor: Colors.black,
        child: IconButton(
          color: Colors.black,
          onPressed: () {
            VolunteerCubitSide.get(context).deafen();
          },
          icon: Icon(
            VolunteerCubitSide.get(context).deafened,
            color: VolunteerCubitSide.get(context).isDeafened ? Colors.red : Colors.white,
          ),
        ),
      ),
      CircleAvatar(
        backgroundColor: Colors.black,
        child: IconButton(
          color: Colors.black,
          onPressed: () {
            VolunteerCubitSide.get(context).switchCamera();
          },
          icon: const Icon(
            Icons.flip_camera_ios,
            color: Colors.white,
          ),
        ),
      ),
      CircleAvatar(
        backgroundColor: Colors.black,
        child: IconButton(
          color: Colors.black,
          onPressed: () {
            VolunteerCubitSide.get(context).videoChange();
          },
          icon: Icon(
            VolunteerCubitSide.get(context).videoOff,
            color: VolunteerCubitSide.get(context).isVideoOff ? Colors.red : Colors.white,
          ),
        ),
      ),
      CircleAvatar(
        backgroundColor: Colors.black,
        child: IconButton(
          color: Colors.black,
          onPressed: () {

            VolunteerCubitSide.get(context).screenIndex=4;
            VolunteerCubitSide.get(context).smallDispose();

          },
          icon: const Icon(
            Icons.call_end,
            color: Colors.red,
          ),
        ),
      ),
    ],
      );}),
      ],
    );


  }
}
