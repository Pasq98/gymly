import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

import 'package:gymly/model/CustomError.dart';
import 'package:gymly/model/WorkoutScheduleModel.dart';

enum WorkScheduleStatus {
  initial,
  inserting,
  inserted,
  failedInsert,
  retrieving,
  retrieved,
  failderRetrieving,
}

final class WorkoutScheduleState extends Equatable {
  final WorkScheduleStatus workoutScheduleStatus;
  final List<WorkoutScheduleModel> listSchedules;
  final CustomError error;
  const WorkoutScheduleState({required this.workoutScheduleStatus, required this.error, required this.listSchedules});

  factory WorkoutScheduleState.initial() {
    return const WorkoutScheduleState(
      workoutScheduleStatus: WorkScheduleStatus.initial,
      error: CustomError(),
      listSchedules: [],
    );
  }

  @override
  List<Object> get props => [workoutScheduleStatus, error];

  @override
  String toString() => 'WorkoutScheduleState(workoutScheduleStatus: $workoutScheduleStatus, error: $error)';

  WorkoutScheduleState copyWith({
    WorkScheduleStatus? workoutScheduleStatus,
    List<WorkoutScheduleModel>? listSchedules,
    CustomError? error,
  }) {
    return WorkoutScheduleState(
        workoutScheduleStatus: workoutScheduleStatus ?? this.workoutScheduleStatus,
        error: error ?? this.error,
        listSchedules: listSchedules ?? this.listSchedules);
  }
}
