import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymly/bloc/filter_excercise/cubit.dart';
import 'package:gymly/colors.dart';
import 'package:gymly/model/WorkoutScheduleModel.dart';
import 'package:gymly/pages/ViewExcercise/view_excercise.dart';

class WorkoutScheduleItem extends StatelessWidget {
  final WorkoutScheduleModel workoutSchedule;

  const WorkoutScheduleItem({Key? key, required this.workoutSchedule}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(25),
      ),
      elevation: 3,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.17,
        child: Row(children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 16),
              child: Column(
                children: [
                  Text(
                    workoutSchedule.title,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    workoutSchedule.dieta,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        workoutSchedule.workoutDays.toString(),
                        style: TextStyle(color: Colors.orange, fontSize: 18),
                      ),
                      const Text(
                        ' days for week',
                        style: TextStyle(color: CustomColor.fontBlack, fontSize: 18),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          const Expanded(
            //Take only space needed
            child: VerticalDivider(
              indent: 15,
              endIndent: 15,
              thickness: 1,
              color: Colors.orange,
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 25,
                bottom: 16,
              ),
              child: Container(
                margin: EdgeInsets.only(right: 14),
                child: Column(
                  children: [
                    const Text(
                      'Start date',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      workoutSchedule.dataInizio,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.orange),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'End Date',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      workoutSchedule.dataFine,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.orange),
                    ),
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
