import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:simple_todo_list_app/sqlite_files/sql_helper.dart';
import '../model_layer/Task.dart';


part 'states.dart';

class TaskCubit extends Cubit<InitialState>{

  TaskCubit() : super(InitialState(listOfTasks: [])){
    getAllItems();
  }

  void getAllItems() async {
    List<Task> list_of_tasks = await SQLHelper.getAllItems();
    emit(InitialState(listOfTasks: list_of_tasks));
  }


  void addTask(Task newTask, List<Task> list_of_tasks) async {
    await SQLHelper.createItem(newTask);
    list_of_tasks.add(newTask);
    emit(InitialState(listOfTasks: list_of_tasks));
  }

  void deleteTask(int index, List<Task> list_of_tasks) async {

    await SQLHelper.deleteItem(list_of_tasks[index].id);
    list_of_tasks.removeAt(index);
    emit(InitialState(listOfTasks: list_of_tasks));
  }

  void editStatus(int index, String isDone, List<Task> list_of_tasks) async {
    list_of_tasks[index].isDone = isDone;
    list_of_tasks[index].status = statesCheck(index, isDone, list_of_tasks);
    await SQLHelper.updateItem(list_of_tasks[index]);
    emit(InitialState(listOfTasks: list_of_tasks));
  }

  void editTask(int id, int index, String title, String dueDate, String finishedTime, List<Task> list_of_tasks) async {
    list_of_tasks[index].id=id;
    list_of_tasks[index].title=title;
    list_of_tasks[index].dueDate=dueDate;
    list_of_tasks[index].finishedTime=finishedTime;
    await SQLHelper.updateItem(list_of_tasks[index]);
    emit(InitialState(listOfTasks: list_of_tasks));
  }

  static TaskStatus statesCheck(int index, String isDone, List<Task> tasks){
    if(isDone=='true'){
      return TaskStatus.Completed;
    }
    else if((isDone=='false')&&
        (DateFormat('dd-MM-yyyy').parse(tasks[index].dueDate).isBefore(DateTime.now()))
        && (DateFormat('hh:mm').parse(tasks[index].finishedTime).hour<=DateTime.now().hour
            && DateFormat('hh:mm').parse(tasks[index].finishedTime).minute<=DateTime.now().minute)
    ){
      return TaskStatus.NotCompleted;
    }
    else{
      return TaskStatus.Active;
    }
  }
}