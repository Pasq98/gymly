enum Dieta { normocalorica, ipercalorica, ipocalorica }

class WorkoutScheduleModel {
  final String title;
  final String dieta;
  final String dataInizio;
  final String dataFine;
  final int workoutDays;
  final int weeksLenght;
  int? id;

  WorkoutScheduleModel(
      {required this.weeksLenght,
      required this.title,
      required this.dataFine,
      required this.dataInizio,
      required this.dieta,
      required this.workoutDays});

  WorkoutScheduleModel.fromMap(Map<String, dynamic> item)
      : id = item['id'],
        title = item['title'],
        dataFine = item['dataFine'],
        dataInizio = item['dataInizio'],
        dieta = item['dieta'],
        weeksLenght = item['weeksLenght'],
        workoutDays = item['workoutDays'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'dataFine': dataFine,
      'dataInizio': dataInizio,
      'dieta': dieta,
      'workoutDays': workoutDays,
      'weeksLenght': weeksLenght,
    };
  }

  @override
  String toString() {
    return "id : $id, title : $title, dataFine : $dataFine, dataInizio : $dataInizio, dieta : $dieta, workoutDays : $workoutDays";
  }
}
