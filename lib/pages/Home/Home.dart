import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymly/bloc/filter_excercise/cubit.dart';
import 'package:gymly/bloc/workout_scheduleCRUD/cubit.dart';
import 'package:gymly/bloc/workout_scheduleCRUD/state.dart';
import 'package:gymly/colors.dart';
import 'package:gymly/pages/Home/WorkoutScheduleItem.dart';
import 'package:gymly/pages/ViewExcercise/view_excercise.dart';
import 'package:gymly/pages/createSchedule.dart';
import 'package:gymly/widget/customAppBar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _addSchedule() {}

  @override
  void initState() {
    // TODO: implement initState
    context.read<WorkoutScheduleCubit>().getSchedule();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.whiteBackground,
      extendBodyBehindAppBar: false,
      appBar: const CustomAppBar(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => CreateSchedule()));
          },
          backgroundColor: CustomColor.orangePrimary,
          child: const Icon(
            Icons.add,
            color: CustomColor.fontBlack,
          )),
      body: BlocConsumer<WorkoutScheduleCubit, WorkoutScheduleState>(
        listener: (context, state) {
          //Quando una nuova scheda è inserita rifaccio la select da db2
          if (state.workoutScheduleStatus == WorkScheduleStatus.inserted) {
            context.read<WorkoutScheduleCubit>().getSchedule();
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 1,
              width: MediaQuery.of(context).size.width * 1,
              child: Column(
                children: [
                  const Text(
                    'Le mie schede',
                    style: TextStyle(color: CustomColor.fontBlack, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Flexible(
                    child: ListView.builder(
                      itemCount: state.listSchedules.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          child: GestureDetector(
                            onTap: () {
                              context
                                  .read<FilterExcerciseCubit>()
                                  .changeFilter(week: 'Week 1', day: 'Day 1', id_schedule: state.listSchedules[index].id!);

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => ViewExcercise(
                                        currentSchedule: state.listSchedules[index],
                                      )));
                            },
                            child: WorkoutScheduleItem(
                              workoutSchedule: state.listSchedules[index],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
