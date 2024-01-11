enum TaskStatus{Active, Completed, NotCompleted}

class Tasks{
  int id;
  String title;
  String dueDate;
  String finishedTime;
  TaskStatus status;
  String isDone;
  String imageTask;

  Tasks(
    {
      required this.id,
      required this.title,
      required this.dueDate,
      required this.finishedTime,
      required this.status,
      required this.isDone,
      required this.imageTask,
    }

  );


  Map<String, dynamic> toMap(){
    return{
      'id':id,
      'title': title,
      'dueDate': dueDate,
      'finishedTime': finishedTime,
      'status': status.name,
      'isDone': isDone,
      'imageTask': imageTask,
    };
  }

  static Tasks fromMap(Map<String, dynamic> map){
    String status = map['status'];
    String image = map['imageTask'];
    String image2 = image;
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
    return Tasks(
        id: map['id'],
        title: map['title'],
        dueDate: map['dueDate'],
        finishedTime: map['finishedTime'],
        status: task,
        isDone: map['isDone'],
        imageTask: (image==null)?" ":image

    );
  }


}