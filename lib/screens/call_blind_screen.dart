import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:rtc_grad_blind_app_qwerty/socket.io_cubit/blind_side_cubit.dart';
import 'package:rtc_grad_blind_app_qwerty/socket.io_cubit/blind_states.dart';

class CallScreenBlind extends StatelessWidget {
  const CallScreenBlind({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {

   return  BlocProvider(
     create: (BuildContext context) => BlindCubitSide(),
     child: BlocConsumer<BlindCubitSide,BlindStates>(
       listener: (context, state) {},
       builder: (context, state) {
         return Scaffold(
           appBar: AppBar(
             title: const Text('Video Conference'),
           ),
           body: BlindCubitSide.get(context)
               .blindCallWidgets[BlindCubitSide.get(context).screenIndex],
         );
       },
     ),
   );
  }
}