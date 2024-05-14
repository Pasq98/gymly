import 'package:bloc/bloc.dart';
import 'package:gymly/model/WorkoutScheduleModel.dart';

import 'state.dart';

/*
Cubit che ha il compito di creare le label per il dropDownMenu usato per scorrere i giorni e le settimane
* */
class CreateLabelFilterCubit extends Cubit<CreateLabelFilterState> {
  CreateLabelFilterCubit() : super(CreateLabelFilterState.initial());

  void createLabels(WorkoutScheduleModel currentSchedule) {
    emit(state.copyWith(labelState: LabelFilterState.retrieving));

    final List<String> _nWeeksLabel = [];
    final List<String> _nOfDaysLabels = [];

    //Create week label
    for (int i = 1; i < currentSchedule.weeksLenght + 1; i++) {
      _nWeeksLabel.add('Week $i');
    }

    //Create days label
    for (int j = 1; j < currentSchedule.workoutDays + 1; j++) {
      _nOfDaysLabels.add('Day $j');
    }

    emit(state.copyWith(labelState: LabelFilterState.retrieved, nDaysLabel: _nOfDaysLabels, nWeeksLabel: _nWeeksLabel));
  }
}
