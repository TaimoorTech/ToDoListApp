import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../model_layer/task.dart';
import 'hiveBox.dart';

part 'hiveDatabase.g.dart';

@HiveType(typeId: 1)
class HiveDatabase{


  HiveDatabase({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.finishedTime,
    required this.status,
    required this.isDone,
    required this.imageTask,
  });

  @HiveField(0)
  int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String dueDate;

  @HiveField(3)
  String finishedTime;

  @HiveField(4)
  String status;

  @HiveField(5)
  String isDone;

  @HiveField(6)
  String imageTask;

  static int addTask(Tasks newTask){
    int id = newTask.toMap()['id'];
    Map<String, dynamic> values = newTask.toMap();
    String title = values['title'];
    String dueDate = values['dueDate'];
    String finishedTime = values['finishedTime'];
    String isDone = values['isDone'];
    String status = statesCheck(isDone, newTask).name;
    // String image = values['image'];
    taskBox.put('$id', HiveDatabase(id: id, title: title, dueDate: dueDate, finishedTime: finishedTime, status: status, isDone: isDone, imageTask: newTask.imageTask));
    return id;
  }

  static Future<void> updateItem(int index, Tasks updatedTask) async {
    Map<String, dynamic> values = updatedTask.toMap();
    int id = updatedTask.id;
    String title = updatedTask.title;
    String dueDate = updatedTask.dueDate;
    String finishedTime = updatedTask.finishedTime;
    String status = values['status'];
    String isDone = updatedTask.isDone;
    String image = updatedTask.imageTask;
    taskBox.putAt(index, HiveDatabase(id: id, title: title, dueDate: dueDate, finishedTime: finishedTime, status: status, isDone: isDone, imageTask: image));
  }

  static Future<void> deleteItem(int id) async {
    taskBox.delete('$id');
    print("task box: $taskBox");
  }

  static Future<List<Tasks>> getAllItems() async {
    // final Map<dynamic, dynamic> result = taskBox.g;
    final result = taskBox.toMap().map(
          (k, e) => MapEntry(
        k.toString(), HiveDatabase.conversion(e)
      ),
    );
    List<Map<String, dynamic>> resultList = [];
    result.values.forEach((v) => resultList.add(v));
    // taskBox.ge
    return resultList.map(Tasks.fromMap).toList();
  }
  
  static Map<String, dynamic> conversion(HiveDatabase db_val) {
    int id = db_val.id;
    String title = db_val.title;
    String dueDate = db_val.dueDate;
    String finishedTime = db_val.finishedTime;
    String status = db_val.status;
    String isDone = db_val.isDone;
    String imageTask = db_val.imageTask;

    Map<String, dynamic> map = {'id' : id, 'title': title,
    'dueDate' : dueDate, 'finishedTime' : finishedTime, 'status' : status,
    'isDone' : isDone, 'imageTask': imageTask};
    
    return map;
  }

  static HiveReopen() async {
    taskBox = await Hive.openBox<HiveDatabase>('taskBox');
  }

  static HiveClose(){
    taskBox.close();
  }

  static TaskStatus statesCheck(String isDone, Tasks task){
    int dueDate_day = DateFormat('dd-MM-yyyy').parse(task.dueDate).day;
    int dueDate_month = DateFormat('dd-MM-yyyy').parse(task.dueDate).month;
    int dueDate_year = DateFormat('dd-MM-yyyy').parse(task.dueDate).year;
    int dueDate_hour = DateFormat('hh:mm').parse(task.finishedTime).hour;
    int dueDate_min = DateFormat('hh:mm').parse(task.finishedTime).minute;

    int now_day = DateTime.now().day;
    int now_month = DateTime.now().month;
    int now_year = DateTime.now().year;
    int now_hour = DateTime.now().hour;
    int now_min = DateTime.now().minute;

    bool dueDateBeforeCheck;
    if(dueDate_year<=now_year && dueDate_month<=now_month && dueDate_day<=now_day){
      dueDateBeforeCheck = true;
    }
    else{
      dueDateBeforeCheck = false;
    }

    bool dueDateAtCheck;
    if(dueDate_year==now_year && dueDate_month==now_month && dueDate_day==now_day){
      dueDateAtCheck = true;
    }
    else{
      dueDateAtCheck = false;
    }

    bool check1 = dueDateBeforeCheck;
    bool check2 = dueDateAtCheck;
    bool check3 = (dueDate_hour<now_hour && dueDate_min<now_min);
    bool check4 = (dueDate_hour<=now_hour);
    bool check5 = (dueDate_hour==now_hour && now_hour<=now_min);
    if(isDone=='true'){
      return TaskStatus.Completed;
    }
    else{
      if(check2){
        if(check3 || check4 || check5){
          return TaskStatus.NotCompleted;
        }
        else{
          return TaskStatus.Active;
        }
      }
      else if(check1)
      {
        return TaskStatus.NotCompleted;
      }
      else{
        return TaskStatus.Active;
      }
    }

  }

}