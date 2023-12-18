import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cubit.dart';
import '../model_layer/task.dart';
import '../utils/util.dart';


class ListViewCard extends StatelessWidget{

  const ListViewCard({super.key, required this.function, required this.id, required this.contexts,
    required this.index, required this.listOfTask, required this.titleController,
    required this.dueDateController, required this.finishedTimeController
  });

  final BuildContext contexts;
  final Function function;
  final dynamic id;
  final int index;
  final List<Task> listOfTask;
  final TextEditingController titleController;
  final TextEditingController dueDateController;
  final TextEditingController finishedTimeController;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      shape: const StadiumBorder(side: BorderSide(color: Colors.blue, width: 2.6)),
      elevation: 15,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 40),
      child: ListTile(
        leading: Checkbox(
          value: toBoolean(listOfTask[index].isDone),
          onChanged: (val) {
              if (val == true) {
                // state.listOfTasks[index].isDone = "true";
                contexts.read<TaskCubit>().editStatus(index, "true", listOfTask);
                // _runFilter(_searchBarController.text.trim());
              }
              else {
                // state.listOfTasks[index].isDone = "false";
                contexts.read<TaskCubit>().editStatus(index, "false", listOfTask);
                // _runFilter(_searchBarController.text.trim());
              }
          },
        ),
        title: Text(listOfTask[index].title,
          style: const TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Due Date : ${listOfTask[index].dueDate}\nFinished Time : ${listOfTask[index].finishedTime}",
          style: const TextStyle(color: Colors.black),
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
                          function(id, index, listOfTask);
                        },
                        icon: const Icon(Icons.edit)
                    ),
                    IconButton(
                        color: Colors.black,
                        onPressed: () async {
                          contexts.read<TaskCubit>().deleteTask(index, listOfTask);
                          Util.snackBar(contexts, "Work has been deleted...");
                          // _runFilter(
                          //     _searchBarController.text.trim());
                        },
                        icon: const Icon(Icons.delete)
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
          text: const TextSpan(children: [
            WidgetSpan(child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.0),
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
          text: const TextSpan(children: [
            WidgetSpan(child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.0),
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
          text: const TextSpan(children: [
            WidgetSpan(child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.0),
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