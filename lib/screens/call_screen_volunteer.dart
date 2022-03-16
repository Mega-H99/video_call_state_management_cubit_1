import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../socket.io_cubit/volunteer_side_cubit.dart';
import '../socket.io_cubit/volunteer_states.dart';

class CallScreenVolunteer extends StatelessWidget {
  const CallScreenVolunteer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {

    return  BlocProvider(
      create: (BuildContext context) => VolunteerCubitSide(),
      child: BlocConsumer<VolunteerCubitSide,VolunteerStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Video Conference'),
            ),
            body: VolunteerCubitSide.get(context)
                .volunteerCallWidgets[VolunteerCubitSide.get(context).screenIndex],
          );
        },
      ),
    );
  }
}