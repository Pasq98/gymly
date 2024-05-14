import 'package:bloc/bloc.dart';

import 'state.dart';

/*
Usato per filtrare la pagina degli esercizi per settimana e per giorno
TODO collegare FIlterExcercise con Excercise.getExcercse
 */
class FilterExcerciseCubit extends Cubit<FilterExcerciseState> {
  FilterExcerciseCubit() : super(FilterExcerciseState.initial());

  void changeFilter({String? week, String? day, int? id_schedule}) {
    emit(state.copyWith(selectedWeek: week, selectedDays: day, id_schedule: id_schedule));
  }
}
