import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_todo_list_app/screens/bottomsheet.dart';

import '../bloc/cubit.dart';
import '../model_layer/Task.dart';

class listViewCard extends StatelessWidget{

  const listViewCard({required this.id, required this.context,
    required this.index, required this.listOfTask, required this.titleController,
    required this.dueDateController, required this.finishedTimeController
  });

  final BuildContext context;
  final id;
  final int index;
  final List<Task> listOfTask;
  final TextEditingController titleController;
  final TextEditingController dueDateController;
  final TextEditingController finishedTimeController;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      shape: StadiumBorder(side: BorderSide(color: Colors.blue, width: 2.6)),
      elevation: 15,
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 40),
      child: ListTile(
        leading: Checkbox(
          value: toBoolean(listOfTask[index].isDone),
          onChanged: (val) {
              if (val == true) {
                // state.listOfTasks[index].isDone = "true";
                context.read<TaskCubit>().editStatus(index, "true", listOfTask);
                // _runFilter(_searchBarController.text.trim());
              }
              else {
                // state.listOfTasks[index].isDone = "false";
                context.read<TaskCubit>().editStatus(index, "false", listOfTask);
                // _runFilter(_searchBarController.text.trim());
              }
          },
        ),
        title: Text(listOfTask[index].title,
          style: TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Due Date : " + listOfTask[index].dueDate + "\n"
              + "Finished Time : " +
              listOfTask[index].finishedTime,
          style: TextStyle(color: Colors.black),
        ),
        trailing: SizedBox(
          width: 114,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              statusApplied(listOfTask[index].status.name),
              SizedBox(
                height: 30,
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        color: Colors.black,
                        onPressed: () {
                          bottomSheet sheet2 = bottomSheet(
                              id: listOfTask[index].id, context: context, index: index,
                              listOfTask: listOfTask,
                              titleController: titleController, dueDateController: dueDateController,
                              finishedTimeController: finishedTimeController);
                          sheet2.showForm();
                        },
                        icon: Icon(Icons.edit)
                    ),
                    IconButton(
                        color: Colors.black,
                        onPressed: () async {
                          context.read<TaskCubit>().deleteTask(index, listOfTask);
                          SnackBar snackBar = SnackBar(content: Text("Work has been deleted..."), elevation: 5,);
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          // _runFilter(
                          //     _searchBarController.text.trim());
                        },
                        icon: Icon(Icons.delete)
                    )
                  ],
                ),
              )
            ],
          ),
        ),

      ),
    );
  }

  Widget statusApplied(String status){
    if(status=="Completed"){
      return RichText(
          text: TextSpan(children: [
            WidgetSpan(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Icon(Icons.check_circle_rounded, size: 16, color: Colors.green)),
            ),
            TextSpan(text: 'Completed', style: TextStyle(color: Colors.green,
                fontWeight: FontWeight.bold)),
          ]
          )
      );
    }
    else if(status=="NotCompleted"){
      return RichText(
          text: TextSpan(children: [
            WidgetSpan(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Icon(Icons.close_rounded, size: 15, color: Colors.red)),
            ),
            TextSpan(text: 'NotCompleted', style: TextStyle(color: Colors.red,
                fontWeight: FontWeight.bold)),
          ]
          )
      );
    }
    else{
      return RichText(
          text: TextSpan(children: [
            WidgetSpan(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Icon(Icons.circle, size: 16, color: Colors.green)),
            ),
            TextSpan(text: 'Active', style: TextStyle(color: Colors.green,
                fontWeight: FontWeight.bold)),
          ]
          )
      );
    }
  }

  bool toBoolean(String status) {
    if (status.toLowerCase() == "true") {
      return true;
    } else {
      return false;
    }
  }

}