CREATE TABLE Schedules
(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  dataInizio varchar,
  dataFine varchar,
  title varchar,
  dieta varchar,
  workoutDays integer,
  weeksLenght integer
);

CREATE TABLE Weeks(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  id_schedules number,
  nome varchar
);

CREATE TABLE Days(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  id_weeks,
  id_schedules number,
  nome varchar
);

CREATE TABLE Excercise(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  idDay varchar,
  idWeek varchar,
  id_schedule number,
  setsAndRep varchar,
  recovery number,
  nome varchar
);

create table Excercise_list(
   id INTEGER PRIMARY KEY AUTOINCREMENT,
   nome varchar
 );

Insert into Excercise_list(nome) values ('Pulley');
Insert into Excercise_list(nome) values ('Panca piana manubri');
CREATE TABLE Sets(id INTEGER PRIMARY KEY AUTOINCREMENT, idExcercise number, setNumber number);
CREATE TABLE Reps(id INTEGER PRIMARY KEY AUTOINCREMENT, idScheda number, idExcercise number, idSet number, idDay number, idWeek number, peso number, rep number, ced number);