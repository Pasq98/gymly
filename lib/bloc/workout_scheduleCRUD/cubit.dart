import 'package:bloc/bloc.dart';
import 'package:gymly/model/CustomError.dart';
import 'package:gymly/model/WorkoutScheduleModel.dart';
import 'package:gymly/repository/scheduleRepository.dart';

import 'state.dart';

class WorkoutScheduleCubit extends Cubit<WorkoutScheduleState> {
  final ScheduleRepository scheduleRepository;
  WorkoutScheduleCubit({required this.scheduleRepository}) : super(WorkoutScheduleState.initial());

  Future<void> addSchedule(WorkoutScheduleModel schedule) async {
    emit(state.copyWith(workoutScheduleStatus: WorkScheduleStatus.inserting));

    try {
      print('Inserting.. ${schedule}');
      await scheduleRepository.addSchedule(schedule);
      emit(state.copyWith(workoutScheduleStatus: WorkScheduleStatus.inserted, listSchedules: state.listSchedules));
    } on CustomError catch (e) {
      emit(state.copyWith(workoutScheduleStatus: WorkScheduleStatus.failedInsert, error: e));
    }
  }

  Future<void> getSchedule() async {
    final List<WorkoutScheduleModel> list = await scheduleRepository.getSchedules();
    emit(state.copyWith(workoutScheduleStatus: WorkScheduleStatus.retrieved, listSchedules: list));
  }

  Future<void> deleteSchedule() async {}
}
