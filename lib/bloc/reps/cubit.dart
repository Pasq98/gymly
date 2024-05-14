import 'package:bloc/bloc.dart';
import 'package:gymly/model/CustomError.dart';
import 'package:gymly/model/ExcerciseModel.dart';
import 'package:gymly/model/RepModel.dart';
import 'package:gymly/repository/scheduleRepository.dart';

import 'state.dart';

class SetsAndRepCubit extends Cubit<SetAndRepState> {
  final ScheduleRepository scheduleRepository;

  SetsAndRepCubit({required this.scheduleRepository}) : super(SetAndRepState.initial());

  Future<void> getRep(ExcerciseModel excercise) async {
    late final listOfRep;
    emit(state.copyWith(repStatus: RepEnumState.retrieving));

    try {
      listOfRep = await scheduleRepository.getRep(excercise);
    } on CustomError catch (e) {
      emit(state.copyWith(
        repStatus: RepEnumState.failderRetrieving,
        error: e,
      ));
    }

    emit(state.copyWith(repStatus: RepEnumState.retrieved, listRep: listOfRep));
  }

  void insertRep() {}

  Future<void> addPesoToRep(int peso, int nSet, ExcerciseModel excercise) async {
    late final listOfRep;

    emit(state.copyWith(repStatus: RepEnumState.inserting));

    //UPDATING
    try {
      await scheduleRepository.addPesoToRep(peso, nSet, excercise);
    } on CustomError catch (e) {
      emit(state.copyWith(repStatus: RepEnumState.failedInsert, error: e));
    }

    //RETRIVING
    try {
      listOfRep = await scheduleRepository.getRep(excercise);
    } on CustomError catch (e) {
      emit(state.copyWith(
        repStatus: RepEnumState.failderRetrieving,
        error: e,
      ));
    }

    emit(state.copyWith(repStatus: RepEnumState.retrieved, listRep: listOfRep));
  }
}
