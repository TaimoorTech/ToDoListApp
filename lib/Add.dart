import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:simple_todo_list_app/bloc/cubit.dart';
import 'package:simple_todo_list_app/sqlite_files/sql_helper.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'model_layer/Task.dart';



class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  State<Add> createState() => _HomeState();
}

class _HomeState extends State<Add> {


  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _finishedTimeController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 5,
          title: Text("ToDo List App"),
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                    labelText: "Title", hintText: "Title"),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _dueDateController,
                decoration: const InputDecoration(
                    labelText: "Due Date",
                    suffixIconColor: Colors.black,
                    suffixIcon: Icon(Icons.calendar_today_rounded),
                    hintText: "Due Date"),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100)
                  );
                  if(pickedDate != null) {
                    setState(() {
                      _dueDateController.text = intl.DateFormat("dd-MM-yyyy").format(pickedDate);
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              TextField(
                controller: _finishedTimeController,
                decoration: const InputDecoration(
                    suffixIconColor: Colors.black,
                    suffixIcon: Icon(Icons.timelapse_rounded),
                    labelText: "Finished Time", hintText: "Finished Time"),
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now(),
                    builder: (BuildContext context, Widget? child) {
                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                        child: child!,
                      );
                    },
                  );
                  if(pickedTime != null){
                    final localizations = MaterialLocalizations.of(context);
                    String formattedTime = localizations.formatTimeOfDay(pickedTime, alwaysUse24HourFormat: true);
                    _finishedTimeController.text = formattedTime;
                  }
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    Task task = new Task(id: 1,
                        title: _titleController.text,
                        dueDate: _dueDateController.text,
                        finishedTime: _finishedTimeController.text,
                        status: TaskStatus.Active,
                        isDone: "true");
                    // task.addItem();
                  },
                  child: Text("Create New Item")
              )
            ],
          ),
        ),


      ),
    );
  }
}

