import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

import 'package:gymly/model/CustomError.dart';
import 'package:gymly/model/ExcerciseModel.dart';
import 'package:gymly/model/WorkoutScheduleModel.dart';

enum LabelFilterState {
  initial,
  retrieving,
  retrieved,
}

final class CreateLabelFilterState extends Equatable {
  final List<String> nWeeksLabel;
  final List<String> nDaysLabel;
  final LabelFilterState labelState;

  const CreateLabelFilterState({
    required this.labelState,
    required this.nWeeksLabel,
    required this.nDaysLabel,
  });

  factory CreateLabelFilterState.initial() {
    return const CreateLabelFilterState(
      labelState: LabelFilterState.initial,
      nDaysLabel: [],
      nWeeksLabel: [],
    );
  }

  @override
  List<Object> get props => [labelState, nDaysLabel, nWeeksLabel];

  //@override
  // String toString() => 'WorkoutScheduleState(workoutScheduleStatus: $excerciseStatus, error: $error)';

  CreateLabelFilterState copyWith({
    LabelFilterState? labelState,
    List<String>? nDaysLabel,
    List<String>? nWeeksLabel,
    CustomError? error,
  }) {
    return CreateLabelFilterState(
        labelState: labelState ?? this.labelState,
        nDaysLabel: nDaysLabel ?? this.nDaysLabel,
        nWeeksLabel: nWeeksLabel ?? this.nWeeksLabel);
  }
}
