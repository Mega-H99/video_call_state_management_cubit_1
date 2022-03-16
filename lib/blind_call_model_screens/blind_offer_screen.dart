import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../socket.io_cubit/blind_side_cubit.dart';

class BlindOfferScreen extends StatelessWidget {
  const BlindOfferScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onLongPress: () {
            print('Blind Calling Other Volunteers');
            BlindCubitSide.get(context).speak('Starting Call');
            BlindCubitSide.get(context).ringingScreen();
            BlindCubitSide.get(context).createOffer();



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
                      child: Stack(
                        children: [
                          RTCVideoView(
                            BlindCubitSide.get(context).remoteRenderer,
                          ),
                          Center(child: const CircularProgressIndicator(color: Colors.white,)),
                        ],
                      )),
                ),
              ])),
        ),

      ],
    );
  }
}
