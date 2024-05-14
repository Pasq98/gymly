import 'package:flutter/material.dart';
import 'package:gymly/bloc/excercise/cubit.dart';
import 'package:gymly/bloc/excercise/state.dart';
import 'package:gymly/bloc/filter_excercise/cubit.dart';
import 'package:gymly/bloc/filter_excercise/state.dart';
import 'package:gymly/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymly/model/WorkoutScheduleModel.dart';
import 'package:gymly/pages/ViewExcercise/excerciseItem.dart';
import 'package:gymly/pages/ViewExcercise/filterExcercise.dart';
import 'package:gymly/pages/addExcercise/addExcercise.dart';
import 'package:gymly/repository/scheduleRepository.dart';
import 'package:gymly/widget/customAppBarWithBack.dart';

class ViewExcercise extends StatefulWidget {
  const ViewExcercise({
    Key? key,
    required this.currentSchedule,
  }) : super(key: key);

  final WorkoutScheduleModel currentSchedule;
  @override
  State<ViewExcercise> createState() => _ViewExcerciseState();
}

class _ViewExcerciseState extends State<ViewExcercise> {
  @override
  void initState() {
    // TODO: implement initState
    /* context.read<ExcerciseCubit>().getExcercises(
          context.read<FilterExcerciseCubit>().state.id_schedule,
          context.read<FilterExcerciseCubit>().state.selectedWeek,
          context.read<FilterExcerciseCubit>().state.selectedDays,
        );*/

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ExcerciseCubit>().state.listExcercise;
    return Scaffold(
      appBar: const CustomAppBarWithBack(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => AddExcercise()));
          },
          backgroundColor: CustomColor.orangePrimary,
          child: const Icon(
            Icons.add,
            color: CustomColor.fontBlack,
          )),
      body: BlocConsumer<ExcerciseCubit, ExcerciseState>(
        listener: (context, state) {
          //print(state);
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: [
                FilterExcercise(
                  //TODO si può utilizzare il filterCubit anzichè passare il paramentro "currentSchedule"?
                  currentSchedule: widget.currentSchedule,
                ),
                Flexible(
                    child: ListView.builder(
                        itemCount: state.listExcercise.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ExcerciseItem(excercise: state.listExcercise[index]);
                        }))
              ],
            ),
          );
        },
      ),
    );
  }
}
