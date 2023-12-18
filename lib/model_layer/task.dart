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
      'id':id,
      'title': title,
      'dueDate': dueDate,
      'finishedTime': finishedTime,
      'status': status.name,
      'isDone': isDone
    };
  }

  static Task fromMap(Map<String, dynamic> map){
    String status = map['status'];
    TaskStatus task;
    if(status=="Completed"){
      task = TaskStatus.Completed;
    }
    else if(status=="NotCompleted"){
      task = TaskStatus.NotCompleted;
    }
    else{
      task = TaskStatus.Active;
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