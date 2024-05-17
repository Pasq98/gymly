import 'package:bloc/bloc.dart';
import 'package:gymly/model/CustomError.dart';
import 'package:gymly/model/ExcerciseModel.dart';
import 'package:gymly/repository/scheduleRepository.dart';

import 'state.dart';

class ExcerciseCubit extends Cubit<ExcerciseState> {
  final ScheduleRepository scheduleRepository;

  ExcerciseCubit({required this.scheduleRepository}) : super(ExcerciseState.initial());

  Future<void> addExcercise(ExcerciseModel excercise) async {
    emit(state.copyWith(excerciseStatus: ExcerciseEnumState.inserting));

    //INSERTING
    try {
      await scheduleRepository.addExcercise(excercise);
      emit(state.copyWith(excerciseStatus: ExcerciseEnumState.inserted));
    } on CustomError catch (e) {
      emit(state.copyWith(excerciseStatus: ExcerciseEnumState.failedInsert, error: e));
    }

    await getExcercises(excercise);
  }

  Future<void> addPesoToRep(int peso, int nSet, ExcerciseModel excercise) async {
    emit(state.copyWith(excerciseStatus: ExcerciseEnumState.updatingPeso));

    //UPDATING
    try {
      await scheduleRepository.addPesoToRep(peso, nSet, excercise);
    } on CustomError catch (e) {
      emit(state.copyWith(excerciseStatus: ExcerciseEnumState.failedInsert, error: e));
    }

    await getExcercises(excercise);
  }

  Future<void> getExcercises(ExcerciseModel excercise) async {
    emit(state.copyWith(excerciseStatus: ExcerciseEnumState.retrieving));

    final List<ExcerciseModel> list = await scheduleRepository.getExcercise(excercise);
    emit(state.copyWith(excerciseStatus: ExcerciseEnumState.retrieved, listExcercise: list));
  }

  Future<void> switchCed(int idSet, ExcerciseModel excercise) async {
    emit(state.copyWith(excerciseStatus: ExcerciseEnumState.updatingPeso));

    //UPDATING
    try {
      await scheduleRepository.switchCed(idSet, excercise);
    } on CustomError catch (e) {
      emit(state.copyWith(excerciseStatus: ExcerciseEnumState.failedInsert, error: e));
    }

    await getExcercises(excercise);
  }
}
