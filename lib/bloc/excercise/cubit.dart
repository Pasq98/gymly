import 'package:bloc/bloc.dart';
import 'package:gymly/model/CustomError.dart';
import 'package:gymly/model/ExcerciseModel.dart';
import 'package:gymly/repository/scheduleRepository.dart';

import 'state.dart';

class ExcerciseCubit extends Cubit<ExcerciseState> {
  final ScheduleRepository scheduleRepository;

  ExcerciseCubit({required this.scheduleRepository}) : super(ExcerciseState.initial());

  Future<void> addExcercise(ExcerciseModel excercise) async {
    emit(state.copyWith(workoutScheduleStatus: ExcerciseEnumState.inserting));

    //INSERTING
    try {
      await scheduleRepository.addExcercise(excercise);
      emit(state.copyWith(workoutScheduleStatus: ExcerciseEnumState.inserted));
    } on CustomError catch (e) {
      emit(state.copyWith(workoutScheduleStatus: ExcerciseEnumState.failedInsert, error: e));
    }

    //RETRIVNG
    final List<ExcerciseModel> list =
        await scheduleRepository.getExcercise(excercise.idSchedule, excercise.idWeek, excercise.idDay);
    emit(state.copyWith(workoutScheduleStatus: ExcerciseEnumState.retrieved, listExcercise: list));
  }

  Future<void> getExcercises(int idScheda, String week, String day) async {
    emit(state.copyWith(workoutScheduleStatus: ExcerciseEnumState.retrieving));

    final List<ExcerciseModel> list = await scheduleRepository.getExcercise(idScheda, week, day);
    emit(state.copyWith(workoutScheduleStatus: ExcerciseEnumState.retrieved, listExcercise: list));
  }
}
