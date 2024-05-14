import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

import 'package:gymly/model/CustomError.dart';
import 'package:gymly/model/ExcerciseModel.dart';
import 'package:gymly/model/RepModel.dart';
import 'package:gymly/model/WorkoutScheduleModel.dart';

enum RepEnumState {
  initial,
  inserting,
  inserted,
  failedInsert,
  retrieving,
  retrieved,
  failderRetrieving,
}

final class SetAndRepState extends Equatable {
  final RepEnumState repStatus;
  final List<RepModel> listRep;
  final CustomError error;
  const SetAndRepState({required this.repStatus, required this.error, required this.listRep});

  factory SetAndRepState.initial() {
    return const SetAndRepState(
      repStatus: RepEnumState.initial,
      error: CustomError(),
      listRep: [],
    );
  }

  @override
  List<Object> get props => [repStatus, error, listRep];

  @override
  String toString() => 'SetAndRepState(RepEnumState: $RepEnumState, listRep: $listRep, error: $error)';

  SetAndRepState copyWith({
    RepEnumState? repStatus,
    List<RepModel>? listRep,
    CustomError? error,
  }) {
    return SetAndRepState(repStatus: repStatus ?? this.repStatus, error: error ?? this.error, listRep: listRep ?? this.listRep);
  }
}
