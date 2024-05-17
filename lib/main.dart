//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymly/bloc/create_label_filter/cubit.dart';
import 'package:gymly/bloc/excercise/cubit.dart';
import 'package:gymly/bloc/filter_excercise/cubit.dart';
import 'package:gymly/bloc/workout_scheduleCRUD/cubit.dart';
import 'package:gymly/dabase/DBService.dart';
import 'package:gymly/pages/SpashScreen.dart';
import 'package:gymly/repository/scheduleRepository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';*/

/*class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}*/

final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: const Color.fromARGB(255, 244, 108, 58),
  //primary: Color.fromARGB(255, 217, 217, 217),
  //onPrimary: Color.fromARGB(255, 5, 50, 37),
  secondary: const Color.fromARGB(255, 152, 222, 248),
  tertiary: const Color.fromARGB(255, 91, 143, 5),
  background: const Color.fromARGB(251, 251, 251, 255),
);

final themeMaterial = ThemeData(
  fontFamily: 'Inter',
).copyWith(
  //useMaterial3: true,
  //ElevatedButton
  colorScheme: colorScheme,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), backgroundColor: Colors.white),
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp(
  // options: DefaultFirebaseOptions.currentPlatform,
  //);*/
  final Database database = await DBService().initializeDB();

  runApp(MyApp(
    database: database,
  ));
}

class MyApp extends StatefulWidget {
  final Database database;
  const MyApp({required this.database, super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ScheduleRepository>(
          create: (context) => ScheduleRepository(database: widget.database),
        ),
      ],
      child: MultiBlocProvider(providers: [
        BlocProvider<WorkoutScheduleCubit>(
          create: (context) => WorkoutScheduleCubit(scheduleRepository: context.read<ScheduleRepository>()),
        ),
        BlocProvider<FilterExcerciseCubit>(
          create: (context) => FilterExcerciseCubit(),
        ),
        BlocProvider<CreateLabelFilterCubit>(
          create: (context) => CreateLabelFilterCubit(),
        ),
        BlocProvider<ExcerciseCubit>(
          create: (context) => ExcerciseCubit(scheduleRepository: context.read<ScheduleRepository>()),
        ),
      ], child: MaterialApp(debugShowCheckedModeBanner: false, title: 'Easy Chat', home: const SplashScreen())),
    );
  }
}
