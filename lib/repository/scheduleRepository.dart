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
        final int idSet =
            await database.rawInsert('INSERT INTO Sets(idExcercise,setNumber) values (?,?)', [id_excercise, currentSet + 1]);

        logger.d(
          'INSERT INTO Reps(idSet,idExcercise,idScheda,idDay,idWeek,peso,rep,ced) values (${currentSet + 1},$id_excercise,${excercise.idSchedule},${excercise.idDay},${excercise.idWeek},0,0,0)',
        );
        final int idRep = await database.rawInsert(
            'INSERT INTO Reps(idSet,idExcercise,idScheda,idDay,idWeek,peso,rep,ced) values (?,?,?,?,?,?,?,?)',
            [currentSet + 1, id_excercise, excercise.idSchedule, excercise.idDay, excercise.idWeek, 0, 0, 0]);
      }
    } catch (e) {
      throw CustomError(
        code: 'Exception insert Excercise',
        message: e.toString(),
        plugin: 'sql_error',
      );
    }
  }

  Future<List<ExcerciseModel>> getExcercise(ExcerciseModel excercise) async {
    List<Map<String, Object?>> queryResultListOfRep;

    final List<Map<String, Object?>> queryResultExcerciseList = await database.rawQuery(
        'SELECT * FROM Excercise WHERE idSchedule=? and idDay=? and idWeek=?',
        [excercise.idSchedule, excercise.idDay, excercise.idWeek]);

    //GET REPS
    List<ExcerciseModel> listOfExcercise = queryResultExcerciseList.map((e) => ExcerciseModel.fromMap(e)).toList();
    for (int i = 0; i < listOfExcercise.length; i++) {
      queryResultListOfRep =
          await database.rawQuery('SELECT * FROM Reps WHERE idScheda=? and idExcercise= ? and idDay=? and idWeek=?', [
        listOfExcercise[i].idSchedule,
        listOfExcercise[i].id,
        listOfExcercise[i].idDay,
        listOfExcercise[i].idWeek,
      ]);

      queryResultListOfRep.map((e) => logger.d(e));
      List<RepModel> listOfRep = queryResultListOfRep.map((e) => RepModel.fromMap(e)).toList();
      listOfExcercise[i].reps = listOfRep;
    }

    return listOfExcercise;
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

  Future<void> addRepToSet(int rep, int nSet, ExcerciseModel excercise) async {
    try {
      // print(
      //   'UPDATE Reps SET peso = $peso WHERE idSet=$nSet and idDay=${excercise.idDay} and idWeek=${excercise.idWeek} and idExcercise=${excercise.id}');
      final id = await database.rawUpdate(
          'UPDATE Reps SET rep = ? WHERE idSet=? and idScheda=? and idDay=? and idWeek=? and idExcercise=?',
          [rep, nSet, excercise.idSchedule, excercise.idDay, excercise.idWeek, excercise.id]);
    } catch (e) {
      throw CustomError(
        code: 'Exception insert Excercise',
        message: e.toString(),
        plugin: 'sql_error',
      );
    }
  }

  Future<void> switchCed(int idSet, ExcerciseModel excercise) async {
    final cedValue = excercise.reps![idSet - 1].ced == 0 ? 1 : 0;
    try {
      print(
          'UPDATE Reps SET ced = ${excercise.reps![idSet - 1].ced == 0 ? 1 : 0} WHERE idSet=$idSet and idDay=${excercise.idDay} and idWeek=${excercise.idWeek} and idExcercise=${excercise.id}');
      final id = await database.rawUpdate(
          'UPDATE Reps SET ced = ? WHERE idSet=? and idScheda=? and idDay=? and idWeek=? and idExcercise=?',
          [cedValue, idSet, excercise.idSchedule, excercise.idDay, excercise.idWeek, excercise.id]);
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
        'SELECT * FROM Reps WHERE idScheda=? and idExcercise= ?and idDay=? and idWeek=? and idExcercise=?',
        [excercise.idSchedule, excercise.id, excercise.idDay, excercise.idWeek, excercise.id]);
    // queryResult.forEach((row) => logger.d(row));
    return queryResult.map((e) => RepModel.fromMap(e)).toList();
  }
}
