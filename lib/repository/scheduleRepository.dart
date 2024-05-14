import 'package:gymly/dabase/DBService.dart';
import 'package:gymly/model/CustomError.dart';
import 'package:gymly/model/ExcerciseModel.dart';
import 'package:gymly/model/RepModel.dart';
import 'package:gymly/model/WorkoutScheduleModel.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

class ScheduleRepository {
  final Database database;
  var logger = Logger();

  ScheduleRepository({required this.database});

  Future<void> addSchedule(WorkoutScheduleModel schedule) async {
    try {
      final id = await database.insert('Schedules', schedule.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

      for (int weekNumber = 1; weekNumber < schedule.weeksLenght + 1; weekNumber++) {
        var idWeek = await database.insert('Weeks', {'nome': 'week $weekNumber', 'id_schedules': id});
        for (int daysNumber = 1; daysNumber < schedule.workoutDays + 1; daysNumber++) {
          await database.insert('Days', {'nome': 'day $weekNumber', 'id_weeks': idWeek, 'id_schedules': id});
        }
      }
      print('row id returned $id');
    } catch (e) {
      throw CustomError(
        code: 'Exception insert schedule',
        message: e.toString(),
        plugin: 'sql_error',
      );
    }
  }

  Future<List<WorkoutScheduleModel>> getSchedules() async {
    final List<Map<String, Object?>> queryResult = await database.query('Schedules');
    return queryResult.map((e) => WorkoutScheduleModel.fromMap(e)).toList();
  }

  Future<void> addExcercise(ExcerciseModel excercise) async {
    try {
      final id_excercise = await database.insert('Excercise', excercise.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      int nOfSet = int.parse(excercise.setsAndRep.substring(0, 1));
      for (int currentSet = 0; currentSet < nOfSet; currentSet++) {
        //TODO controllare che id sia effettivamente l'id dell'esercizio creato
        final int idSet =
            await database.rawInsert('INSERT INTO Sets(idExcercise,setNumber) values (?,?)', [id_excercise, currentSet + 1]);

        logger.d(
          'INSERT INTO Reps(idSet,idExcercise,idScheda,idDay,idWeek,peso,rep,ced) values ($idSet,$id_excercise,${excercise.idSchedule},${excercise.idDay},${excercise.idWeek},0,0,0)',
        );
        final int idRep = await database.rawInsert(
            'INSERT INTO Reps(idSet,idExcercise,idScheda,idDay,idWeek,peso,rep,ced) values (?,?,?,?,?,?,?,?)',
            [idSet, id_excercise, excercise.idSchedule, excercise.idDay, excercise.idWeek, 0, 0, 0]);
      }
    } catch (e) {
      throw CustomError(
        code: 'Exception insert Excercise',
        message: e.toString(),
        plugin: 'sql_error',
      );
    }
  }

  Future<List<ExcerciseModel>> getExcercise(int idScheda, String week, String day) async {
    // print('SELECT * FROM Excercise WHERE idSchedule=$idScheda and idDay=$day and idWeek=$week');
    final List<Map<String, Object?>> queryResult =
        await database.rawQuery('SELECT * FROM Excercise WHERE idSchedule=? and idDay=? and idWeek=?', [idScheda, day, week]);
    queryResult.forEach((row) => print(row));
    return queryResult.map((e) => ExcerciseModel.fromMap(e)).toList();
  }

  Future<int> getNumberOfDays(int id_scheda) async {
    List<Map> result = await database.rawQuery('SELECT workoutDays FROM Schedules WHERE id=?', [id_scheda]);

    return result[0]['workoutDays'];
  }

  Future<void> addPesoToRep(int peso, int nSet, ExcerciseModel excercise) async {
    try {
      print(
          'UPDATE Reps SET peso = $peso WHERE idSet=$nSet and idDay=${excercise.idDay} and idWeek=${excercise.idWeek} and idExcercise=${excercise.id}');
      final id = await database.rawUpdate(
          'UPDATE Reps SET peso = ? WHERE idSet=? and idScheda=? and idDay=? and idWeek=? and idExcercise=?',
          [peso, nSet, excercise.idSchedule, excercise.idDay, excercise.idWeek, excercise.id]);
    } catch (e) {
      throw CustomError(
        code: 'Exception insert Excercise',
        message: e.toString(),
        plugin: 'sql_error',
      );
    }
  }

  Future<List<RepModel>> getRep(ExcerciseModel excercise) async {
    logger.d(
        'SELECT * FROM Reps WHERE idScheda=${excercise.idSchedule} and idDay=${excercise.idDay} and idWeek=${excercise.idWeek} and idExcercise=${excercise.id}');
    final List<Map<String, Object?>> queryResult = await database.rawQuery(
        'SELECT * FROM Reps WHERE idScheda=? and idDay=? and idWeek=? and idExcercise=?',
        [excercise.idSchedule, excercise.idDay, excercise.idWeek, excercise.id]);
    // queryResult.forEach((row) => logger.d(row));
    return queryResult.map((e) => RepModel.fromMap(e)).toList();
  }
}
