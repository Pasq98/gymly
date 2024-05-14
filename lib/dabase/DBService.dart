import 'package:flutter/services.dart';
import 'package:gymly/model/WorkoutScheduleModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBService {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    print('Path ${path}');

    return openDatabase(
      join(path, 'database.db'),

      //Called when db is created for first time
      onCreate: (database, version) async {
        print("Creating new copy from asset");

        Batch batch = database.batch();
        batch.execute(
            'CREATE TABLE Schedules (id INTEGER PRIMARY KEY AUTOINCREMENT,dataInizio varchar,dataFine varchar,title varchar,dieta varchar,workoutDays integer,weeksLenght integer);');

        batch.execute('CREATE TABLE Weeks(id INTEGER PRIMARY KEY AUTOINCREMENT,id_schedules number,nome varchar);');
        batch.execute('CREATE TABLE Days(id INTEGER PRIMARY KEY AUTOINCREMENT,id_weeks, id_schedules number, nome varchar);');
        //TODO: rimuovere il nome da Excercise e metterlo in join con Excercise_List-> dropDownButton per inserire il nome dell'esecizio con la select.
        batch.execute(
            'CREATE TABLE Excercise(id INTEGER PRIMARY KEY AUTOINCREMENT, idSchedule number, idDay varchar, idWeek varchar, setsAndRep varc har, recovery number, nome varchar);');
        batch.execute('create table Excercise_list(id INTEGER PRIMARY KEY AUTOINCREMENT, nome varchar);');
        batch.insert('Excercise_list', {'nome': 'Pulley'});
        batch.insert('Excercise_list', {'nome': 'Panca piana manubri'});

        batch.execute('CREATE TABLE Sets(id INTEGER PRIMARY KEY AUTOINCREMENT, idExcercise number, setNumber number);');
        batch.execute(
            'CREATE TABLE Reps(id INTEGER PRIMARY KEY AUTOINCREMENT,idScheda number,idExcercise number, idSet number, idDay number, idWeek number, peso number, rep number ,ced number);');
        await batch.commit(noResult: true);

        // final String scriptSQL = await loadAsset();

        //Create SQL
        // await database.execute(scriptSQL);
      },

      version: 1,
    );
  }

  Future<int> createItem(WorkoutScheduleModel schedule) async {
    int result = 0;
    final Database db = await initializeDB();
    final id = await db.insert('Schedules', schedule.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  //Select * in pratica
  Future<List<WorkoutScheduleModel>> getItems() async {
    final db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('Schedules');
    return queryResult.map((e) => WorkoutScheduleModel.fromMap(e)).toList();
  }

  /*


  tatic Future<void> deleteItem(String id) async {
    final db = await SqliteService.initializeDB();
    try {
      await db.delete("Notes", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      print("Something went wrong when deleting an item: $err");
    }
  }
   */
}
