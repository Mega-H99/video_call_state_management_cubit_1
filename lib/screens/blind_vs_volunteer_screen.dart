import 'package:flutter/material.dart';

import 'call_blind_screen.dart';
import 'call_screen_volunteer.dart';

class BlindVSVolunteerScreen extends StatefulWidget {
  const BlindVSVolunteerScreen({Key? key}) : super(key: key);

  @override
  State<BlindVSVolunteerScreen> createState() => _BlindVSVolunteerScreenState();
}

class _BlindVSVolunteerScreenState extends State<BlindVSVolunteerScreen> {
  bool isBlind = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                isBlind = true;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CallScreenBlind(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                minimumSize: const Size.fromWidth(double.infinity),
              ),
              child: const Text(
                'Blind',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                isBlind = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CallScreenVolunteer(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.purple,
                minimumSize: const Size.fromWidth(double.infinity),
              ),
              child: const Text(
                'Volunteer',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}