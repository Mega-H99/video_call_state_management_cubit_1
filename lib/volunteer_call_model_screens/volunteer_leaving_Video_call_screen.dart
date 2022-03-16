import 'package:flutter/material.dart';

import '../socket.io_cubit/blind_side_cubit.dart';
import '../socket.io_cubit/volunteer_side_cubit.dart';

class VolunteerLeavingVideoCallScreen extends StatelessWidget {
  const VolunteerLeavingVideoCallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit. fill,
              image: AssetImage(
                'images/closing_call.png',
              ))),
      child:   Center(
        child: Column(
          children: [
            const Text(
              "Your Are Leaving Video Call",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () {
                VolunteerCubitSide.get(context).destroyMe();
                Navigator.pop(context);
              },
              color: Colors.red,
              icon: const Icon(
                Icons.missed_video_call_outlined,
                color: Colors.white,
              ),
            ),
          ],
        ),

      ),
    );
  }
}
