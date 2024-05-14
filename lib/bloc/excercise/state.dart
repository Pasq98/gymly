import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

import 'package:gymly/model/CustomError.dart';
import 'package:gymly/model/ExcerciseModel.dart';
import 'package:gymly/model/WorkoutScheduleModel.dart';

enum ExcerciseEnumState {
  initial,
  inserting,
  inserted,
  failedInsert,
  retrieving,
  retrieved,
  failderRetrieving,
}

final class ExcerciseState extends Equatable {
  final ExcerciseEnumState excerciseStatus;
  final List<ExcerciseModel> listExcercise;
  final CustomError error;
  const ExcerciseState({required this.excerciseStatus, required this.error, required this.listExcercise});

  factory ExcerciseState.initial() {
    return const ExcerciseState(
      excerciseStatus: ExcerciseEnumState.initial,
      error: CustomError(),
      listExcercise: [],
    );
  }

  @override
  List<Object> get props => [excerciseStatus, error, listExcercise];

  @override
  String toString() => 'WorkoutScheduleState(workoutScheduleStatus: $excerciseStatus, error: $error)';

  ExcerciseState copyWith({
    ExcerciseEnumState? workoutScheduleStatus,
    List<ExcerciseModel>? listExcercise,
    CustomError? error,
  }) {
    return ExcerciseState(
        excerciseStatus: workoutScheduleStatus ?? this.excerciseStatus,
        error: error ?? this.error,
        listExcercise: listExcercise ?? this.listExcercise);
  }
}
