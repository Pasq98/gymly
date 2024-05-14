import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymly/bloc/create_label_filter/cubit.dart';
import 'package:gymly/bloc/create_label_filter/state.dart';
import 'package:gymly/bloc/excercise/cubit.dart';
import 'package:gymly/bloc/filter_excercise/cubit.dart';
import 'package:gymly/bloc/reps/cubit.dart';
import 'package:gymly/colors.dart';
import 'package:gymly/model/ExcerciseModel.dart';
import 'package:gymly/model/WorkoutScheduleModel.dart';

class FilterExcercise extends StatefulWidget {
  FilterExcercise({
    required this.currentSchedule,
    Key? key,
  }) : super(key: key);
  final WorkoutScheduleModel currentSchedule;

  @override
  State<FilterExcercise> createState() => _FilterExcerciseState();
}

class _FilterExcerciseState extends State<FilterExcercise> {
  String? _selectedWeek, _selectedDay;

  @override
  void initState() {
    //TODO: context da dove lo prende???
    context.read<CreateLabelFilterCubit>().createLabels(widget.currentSchedule);
    super.initState();
  }

  Widget dropDownWeek(List<String> _nWeeksLabel) {
    return DropdownButton(
      focusColor: CustomColor.orangePrimary,
      underline: Container(
        height: 1,
        color: CustomColor.orangePrimary,
      ),
      value: _selectedWeek,
      isExpanded: true,
      hint: Center(
        child: Text(_nWeeksLabel.first,
            style: const TextStyle(color: CustomColor.orangePrimary, fontSize: 16, fontWeight: FontWeight.w500)),
      ),
      onChanged: (value) {
        setState(() {
          _selectedWeek = value!;

          context.read<FilterExcerciseCubit>().changeFilter(week: _selectedWeek);
          //TODO collegare cubit in maniera automatica, poco corretto sto accrocchio
          context.read<ExcerciseCubit>().getExcercises(
                context.read<FilterExcerciseCubit>().state.id_schedule,
                context.read<FilterExcerciseCubit>().state.selectedWeek,
                context.read<FilterExcerciseCubit>().state.selectedDays,
              );

          context.read<SetsAndRepCubit>().getRep(
                ExcerciseModel(
                    idDay: context.read<FilterExcerciseCubit>().state.selectedDays,
                    idSchedule: widget.currentSchedule.id!,
                    idWeek: context.read<FilterExcerciseCubit>().state.selectedWeek,
                    nome: '',
                    recovery: 0,
                    setsAndRep: ''),
              );
        });
      },
      items: _nWeeksLabel.map((String val) {
        return DropdownMenuItem(
          value: val,
          child: Center(
            child: Text(
              val,
              style: TextStyle(fontSize: 16, color: CustomColor.orangePrimary, fontWeight: FontWeight.w500),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget dropDownDay(List<String> _nOfDaysLabels) {
    return DropdownButton(
      value: _selectedDay,
      underline: Container(
        height: 1,
        color: CustomColor.orangePrimary,
      ),
      isExpanded: true,
      hint: Center(
        child: Text(_nOfDaysLabels.first,
            style: TextStyle(color: CustomColor.orangePrimary, fontSize: 16, fontWeight: FontWeight.w500)),
      ),
      onChanged: (value) async {
        //  setState(() {
        _selectedDay = value!;
        print("SelctedDay $_selectedDay");
        context.read<FilterExcerciseCubit>().changeFilter(day: _selectedDay);
        //TODO collegare cubit in maniera automatica, poco corretto sto accrocchio

        await context.read<ExcerciseCubit>().getExcercises(
              context.read<FilterExcerciseCubit>().state.id_schedule,
              context.read<FilterExcerciseCubit>().state.selectedWeek,
              context.read<FilterExcerciseCubit>().state.selectedDays,
            );

        await context.read<SetsAndRepCubit>().getRep(
              ExcerciseModel(
                  idDay: context.read<FilterExcerciseCubit>().state.selectedDays,
                  idSchedule: widget.currentSchedule.id!,
                  idWeek: context.read<FilterExcerciseCubit>().state.selectedWeek,
                  nome: '',
                  recovery: 0,
                  setsAndRep: ''),
            );
        //});
      },
      items: _nOfDaysLabels.map((String val) {
        return DropdownMenuItem(
          value: val,
          child: Center(
            child: Text(
              val,
              style: TextStyle(fontSize: 16, color: CustomColor.orangePrimary, fontWeight: FontWeight.w500),
            ),
          ),
        );
      }).toList(),
    );
  }

  //TODO: come evitare build multipli? BuildWhen?
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateLabelFilterCubit, CreateLabelFilterState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.labelState == LabelFilterState.retrieving) {
            return Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.05,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(child: CircularProgressIndicator()),
                  SizedBox(
                    width: 100,
                  ),
                  Flexible(child: CircularProgressIndicator()),
                ],
              ),
            );
          }
          if (state.labelState == LabelFilterState.retrieved) {
            return Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(child: dropDownWeek(state.nWeeksLabel)),
                  const SizedBox(
                    width: 100,
                  ),
                  Flexible(child: dropDownDay(state.nDaysLabel)),
                ],
              ),
            );
          } else {
            return Container(child: Text(' E mos o cazi'));
          }
        });
  }
}