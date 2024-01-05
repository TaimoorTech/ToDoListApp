import 'package:hive/hive.dart';

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

  static int addTask(Task newTask){
    int id = newTask.toMap()['id'];
    Map<String, dynamic> values = newTask.toMap();
    String title = values['title'];
    String dueDate = values['dueDate'];
    String finishedTime = values['finishedTime'];
    String status = values['status'];
    String isDone = values['isDone'];
    taskBox.put('$id', HiveDatabase(id: id, title: title, dueDate: dueDate, finishedTime: finishedTime, status: status, isDone: isDone));
    return id;
  }

  static Future<void> updateItem(int index, Task updatedTask) async {
    Map<String, dynamic> values = updatedTask.toMap();
    int id = updatedTask.id;
    String title = updatedTask.title;
    String dueDate = updatedTask.dueDate;
    String finishedTime = updatedTask.finishedTime;
    String status = values['status'];
    String isDone = updatedTask.isDone;
    taskBox.putAt(index, HiveDatabase(id: id, title: title, dueDate: dueDate, finishedTime: finishedTime, status: status, isDone: isDone));
  }

  static Future<void> deleteItem(int id) async {
    taskBox.delete('$id');
    print("task box: $taskBox");
  }

  static Future<List<Task>> getAllItems() async {
    // final Map<dynamic, dynamic> result = taskBox.g;
    final result = taskBox.toMap().map(
          (k, e) => MapEntry(
        k.toString(), HiveDatabase.conversion(e)
      ),
    );
    List<Map<String, dynamic>> resultList = [];
    result.values.forEach((v) => resultList.add(v));
    // taskBox.ge
    return resultList.map(Task.fromMap).toList();
  }
  
  static Map<String, dynamic> conversion(HiveDatabase db_val) {
    int id = db_val.id;
    String title = db_val.title;
    String dueDate = db_val.dueDate;
    String finishedTime = db_val.finishedTime;
    String status = db_val.status;
    String isDone = db_val.isDone;
    
    Map<String, dynamic> map = {'id' : id, 'title': title,
    'dueDate' : dueDate, 'finishedTime' : finishedTime, 'status' : status,
    'isDone' : isDone};
    
    return map;
  }

}