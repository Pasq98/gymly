import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

import 'package:gymly/model/CustomError.dart';
import 'package:gymly/model/WorkoutScheduleModel.dart';

final class FilterExcerciseState extends Equatable {
  final String selectedWeek;
  final String selectedDays;
  final int id_schedule;

  const FilterExcerciseState({required this.selectedWeek, required this.selectedDays, required this.id_schedule});

  factory FilterExcerciseState.initial() {
    return const FilterExcerciseState(
      selectedDays: '',
      selectedWeek: '',
      id_schedule: 1,
    );
  }

  @override
  List<Object> get props => [selectedDays, selectedWeek, id_schedule];

  @override
  String toString() => 'FilterExcerciseState(id_scheda: $id_schedule, selectedWeek: $selectedWeek, selectedDays: $selectedDays)';

  FilterExcerciseState copyWith({
    String? selectedWeek,
    String? selectedDays,
    int? id_schedule,
  }) {
    return FilterExcerciseState(
        selectedWeek: selectedWeek ?? this.selectedWeek,
        selectedDays: selectedDays ?? this.selectedDays,
        id_schedule: id_schedule ?? this.id_schedule);
  }
}
