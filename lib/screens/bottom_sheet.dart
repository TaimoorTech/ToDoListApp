import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_todo_list_app/model_layer/task.dart';
import 'package:intl/intl.dart' as intl;


import '../bloc/cubit.dart';
import '../utils/util.dart';

class ModelBottomSheet extends StatelessWidget {

  const ModelBottomSheet({super.key, required this.id, required this.contexts,
    required this.index, required this.listOfTask, required this.titleController,
    required this.dueDateController, required this.finishedTimeController
  });

  final BuildContext contexts;
  final id;
  final int index;
  final List<Task> listOfTask;
  final TextEditingController titleController;
  final TextEditingController dueDateController;
  final TextEditingController finishedTimeController;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.only(top: 15, left: 15, right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom+85),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
                labelText: "Title", hintText: "Title"),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: dueDateController,
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
                dueDateController.text = intl.DateFormat("dd-MM-yyyy").format(pickedDate);
              }
            },
          ),
          const SizedBox(height: 20),
          TextField(
            controller: finishedTimeController,
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
                finishedTimeController.text = formattedTime;
              }
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () async {
                if (id == null) {
                  int taskID;
                  if(listOfTask.isEmpty){
                    taskID=1;
                  }
                  else{
                    taskID = listOfTask.last.id;
                  }
                  Task task =  Task(id: taskID+1, title: titleController.text.toString(),
                      dueDate: dueDateController.text.toString(),
                      finishedTime: finishedTimeController.text.toString(),
                      status: TaskStatus.Active, isDone: "false");
                  // contexts.read<TaskCubit>().addTask(task, listOfTask);
                  contexts.read<TaskCubit>().putHiveTask(task, listOfTask);
                  Util.snackBar(contexts, "Work has been listed...");
                  // _runFilter(_searchBarController.text.trim());
                }
                if (id != null){
                  // contexts.read<TaskCubit>()
                  //     .editTask(listOfTask[index].id, index, titleController.text.toString(),
                  //     dueDateController.text.toString(),
                  //     finishedTimeController.text.toString(), listOfTask);
                  contexts.read<TaskCubit>().updateHiveTask(
                      id, index, titleController.text.toString(),
                          dueDateController.text.toString(),
                          finishedTimeController.text.toString(), listOfTask);
                  Util.snackBar(contexts, "Work has been Updated...");
                  // _runFilter(_searchBarController.text.trim());
                }
                titleController.text='';
                dueDateController.text='';
                finishedTimeController.text='';

                Navigator.of(contexts).pop();
              },
              child: Text(id == null ? 'Create New' : 'Update')
          )

        ],
      ),
    );
  }

}

