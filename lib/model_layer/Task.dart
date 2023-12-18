
import 'package:simple_todo_list_app/sqlite_files/sql_helper.dart';

enum TaskStatus{Active, Completed, NotCompleted}

class Task{
  int id;
  String title;
  String dueDate;
  String finishedTime;
  TaskStatus status;
  String isDone;

  Task(
    {
      required this.id,
      required this.title,
      required this.dueDate,
      required this.finishedTime,
      required this.status,
      required this.isDone
    }

  );


  Map<String, dynamic> toMap(){
    return{
      'id':this.id,
      'title': this.title,
      'dueDate': this.dueDate,
      'finishedTime': this.finishedTime,
      'status': this.status.name,
      'isDone': this.isDone
    };
  }

  static Task fromMap(Map<String, dynamic> map){
    String Status = map['status'];
    var task;
    if(Status=="Active"){
      task = TaskStatus.Active;
    }
    else if(Status=="Completed"){
      task = TaskStatus.Completed;
    }
    else if(Status=="NotCompleted"){
      task = TaskStatus.NotCompleted;
    }
    return Task(
        id: map['id'],
        title: map['title'],
        dueDate: map['dueDate'],
        finishedTime: map['finishedTime'],
        status: task,
        isDone: map['isDone']
    );
  }


}