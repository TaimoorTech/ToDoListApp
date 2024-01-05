import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:simple_todo_list_app/hive/hiveBox.dart';
import 'package:simple_todo_list_app/hive/hiveDatabase.dart';
import 'package:simple_todo_list_app/sqlite_files/sql_helper.dart';
import '../model_layer/task.dart';


part 'task_listing.dart';

class TaskCubit extends Cubit<TaskListing>{

  TaskCubit() : super(TaskListing(listOfTasks: [])){
    // getAllItems();
    getHiveTask();
  }

  void getHiveTask() async {
    List<Task> list_of_tasks = await HiveDatabase.getAllItems();
    print("list : $list_of_tasks");
    emit(TaskListing(listOfTasks: list_of_tasks));
  }

  void putHiveTask(Task newTask, List<Task> list_of_tasks) async{
    HiveDatabase.addTask(newTask);
    list_of_tasks = await HiveDatabase.getAllItems();
    print("list : $list_of_tasks");
    emit(TaskListing(listOfTasks: list_of_tasks));
  }

  void deleteHiveTask(int index, List<Task> list_of_tasks) async {
    await HiveDatabase.deleteItem(list_of_tasks[index].id);
    list_of_tasks.removeAt(index);
    emit(TaskListing(listOfTasks: list_of_tasks));
  }

  void updateHiveTask(int id, int index, String title, String dueDate, String finishedTime, List<Task> list_of_tasks) async {
    list_of_tasks[index].id=id;
    list_of_tasks[index].title=title;
    list_of_tasks[index].dueDate=dueDate;
    list_of_tasks[index].finishedTime=finishedTime;
    list_of_tasks[index].status = statesCheck(index, list_of_tasks[index].isDone, list_of_tasks);
    await HiveDatabase.updateItem(index, list_of_tasks[index]);
    list_of_tasks = await HiveDatabase.getAllItems();
    emit(TaskListing(listOfTasks: list_of_tasks));
  }

  void updateHiveTaskStatus(int index, String isDone, List<Task> list_of_tasks) async {
    list_of_tasks[index].isDone = isDone;
    list_of_tasks[index].status = statesCheck(index, isDone, list_of_tasks);
    await HiveDatabase.updateItem(index, list_of_tasks[index]);
    emit(TaskListing(listOfTasks: list_of_tasks));
  }

  void getAllItems() async {
    List<Task> list_of_tasks = await SQLHelper.getAllItems();
    emit(TaskListing(listOfTasks: list_of_tasks));
  }


  void addTask(Task newTask, List<Task> list_of_tasks) async {
    await SQLHelper.createItem(newTask);
    list_of_tasks.add(newTask);
    emit(TaskListing(listOfTasks: list_of_tasks));
  }

  void deleteTask(int index, List<Task> list_of_tasks) async {

    await SQLHelper.deleteItem(list_of_tasks[index].id);
    list_of_tasks.removeAt(index);
    emit(TaskListing(listOfTasks: list_of_tasks));
  }

  void editStatus(int index, String isDone, List<Task> list_of_tasks) async {
    list_of_tasks[index].isDone = isDone;
    list_of_tasks[index].status = statesCheck(index, isDone, list_of_tasks);
    await SQLHelper.updateItem(list_of_tasks[index]);
    emit(TaskListing(listOfTasks: list_of_tasks));
  }

  void editTask(int id, int index, String title, String dueDate, String finishedTime, List<Task> list_of_tasks) async {
    list_of_tasks[index].id=id;
    list_of_tasks[index].title=title;
    list_of_tasks[index].dueDate=dueDate;
    list_of_tasks[index].finishedTime=finishedTime;
    await SQLHelper.updateItem(list_of_tasks[index]);
    emit(TaskListing(listOfTasks: list_of_tasks));
  }

  static TaskStatus statesCheck(int index, String isDone, List<Task> tasks){
    int dueDate_day = DateFormat('dd-MM-yyyy').parse(tasks[index].dueDate).day;
    int dueDate_month = DateFormat('dd-MM-yyyy').parse(tasks[index].dueDate).month;
    int dueDate_year = DateFormat('dd-MM-yyyy').parse(tasks[index].dueDate).year;
    int dueDate_hour = DateFormat('hh:mm').parse(tasks[index].finishedTime).hour;
    int dueDate_min = DateFormat('hh:mm').parse(tasks[index].finishedTime).minute;

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