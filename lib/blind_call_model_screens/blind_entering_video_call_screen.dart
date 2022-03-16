import 'package:flutter/material.dart';
import 'package:rtc_grad_blind_app_qwerty/socket.io_cubit/blind_side_cubit.dart';

class BlindNotReadyScreen extends StatelessWidget {
  const BlindNotReadyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onDoubleTap: (){
        BlindCubitSide.get(context).speak('Entering Video Call');
        BlindCubitSide.get(context).screenIndex=1;
        BlindCubitSide.get(context).initializeMe();
      },
      onTap: (){
        BlindCubitSide.get(context).
        speak("Ready to start video call double tap to enter");
      },
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                    'images/entering_call.png',
                ))),
        child:  const Center(
          child: Text(
                "Your Are Entering Video Call",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
              ),

          ),
        ),

    );
  }
}
