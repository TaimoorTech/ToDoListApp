import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:simple_todo_list_app/bloc/cubit.dart';
import 'package:simple_todo_list_app/screens/home.dart';

import 'hive/hiveBox.dart';
import 'hive/hiveDatabase.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(HiveDatabaseAdapter());
  taskBox = await Hive.openBox<HiveDatabase>('taskBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<TaskCubit>(
          create: (BuildContext context) => TaskCubit(),
          child: Home()),

    );
  }
}
