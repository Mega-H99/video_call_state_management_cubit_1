import 'package:flutter/material.dart';

class BlindCallingScreen extends StatelessWidget {
  const BlindCallingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.blue,
      child: Center(
        child: Column(
          children: const [
            Text(
              'waiting for Volunteer to answer',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40.0,
                color: Colors.white,
              ),
            ),
            CircularProgressIndicator(color: Colors.white,),
          ],
        ),
      ),

    );

  }
}
