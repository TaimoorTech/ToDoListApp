import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_todo_list_app/bloc/cubit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_todo_list_app/sqlite_files/sql_helper.dart';
import '../model_layer/Task.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _finishedTimeController = TextEditingController();
  final TextEditingController _searchBarController = TextEditingController();

  bool isChecked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<TaskCubit>().getAllItems();
  }

  void display_message(String message){
    Fluttertoast.showToast(
        msg: message,
        textColor: Colors.black,
        fontSize: 15,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.blue,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG);
  }

  void _showForm(int? id, int index, List<Task> listOfTask) async {

    if(id != null){
      final existingItem = listOfTask.firstWhere((element) => element.id == id);
      _titleController.text = existingItem.title;
      _dueDateController.text = existingItem.dueDate;
      _finishedTimeController.text = existingItem.finishedTime;
    }


    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
          padding: EdgeInsets.only(top: 15, left: 15, right: 15,
              bottom: MediaQuery.of(context).viewInsets.bottom+85),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                    labelText: "Title", hintText: "Title"),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _dueDateController,
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
                      setState(() {
                        _dueDateController.text = intl.DateFormat("dd-MM-yyyy").format(pickedDate);
                      });
                    }
                  },
              ),
              SizedBox(height: 20),
              TextField(
                controller: _finishedTimeController,
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
                    _finishedTimeController.text = formattedTime;
                  }
                },
              ),
              SizedBox(height: 20),
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
                        Task task =  Task(id: taskID+1, title: _titleController.text.toString(),
                            dueDate: _dueDateController.text.toString(),
                            finishedTime: _finishedTimeController.text.toString(),
                            status: TaskStatus.Active, isDone: "false");
                        context.read<TaskCubit>().addTask(task, listOfTask);
                        SnackBar snackBar = SnackBar(
                          content: Text("Work has been listed..."),
                          elevation: 5,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        // _runFilter(_searchBarController.text.trim());
                      }
                      if (id != null){
                        context.read<TaskCubit>()
                            .editTask(listOfTask[index].id, index, _titleController.text.toString(),
                            _dueDateController.text.toString(),
                            _finishedTimeController.text.toString(), listOfTask);
                        SnackBar snackBar = SnackBar(
                          content: Text("Work has been Updated..."),
                          elevation: 5,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        // _runFilter(_searchBarController.text.trim());
                      }
                      _titleController.text='';
                      _dueDateController.text='';
                      _finishedTimeController.text='';

                      Navigator.of(context).pop();
                  },
                  child: Text(id == null ? 'Create New' : 'Update')
              )

            ],
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
         backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 5,
            title: Text("ToDo List App"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () async {
                List<Task> list = await SQLHelper.getAllItems();
                _titleController.text='';
                _dueDateController.text='';
                _finishedTimeController.text='';
                _showForm(null, 0, list);
              },
              child: Icon(
                Icons.add
              ),
          ),
          body: Container(
            margin: EdgeInsets.only(top: 30),
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                searchBar(),
                SizedBox(height: 30),
                Text("All Tasks", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                SizedBox(height: 30),
                showList()

              ],
            ),
          ),
      ),
    );
  }


  Widget showList() {
    return Expanded(
      // height: MediaQuery. of(context). size. height-230,
      child: BlocBuilder<TaskCubit, InitialState>(
        builder: (BuildContext context, InitialState state) => ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: state.listOfTasks.length,
              itemBuilder: (context, index) =>
                  Card(
                    shape: StadiumBorder(
                        side: BorderSide(color: Colors.blue, width: 2.6)),
                    elevation: 15,
                    color: Colors.white,
                    margin: EdgeInsets.only(bottom: 40),
                    child: ListTile(
                      leading: Checkbox(
                        value: toBoolean(state.listOfTasks[index].isDone),
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              state.listOfTasks[index].isDone = "true";
                              context.read<TaskCubit>().editStatus(index, "true", state.listOfTasks);
                              // _runFilter(_searchBarController.text.trim());
                            }
                            else {
                              state.listOfTasks[index].isDone = "false";
                              context.read<TaskCubit>().editStatus(index, "false", state.listOfTasks);
                              // _runFilter(_searchBarController.text.trim());
                            }
                          });
                        },
                      ),
                      title: Text(state.listOfTasks[index].title,
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Due Date : " + state.listOfTasks[index].dueDate + "\n"
                            + "Finished Time : " +
                            state.listOfTasks[index].finishedTime,
                        style: TextStyle(color: Colors.black),
                      ),
                      trailing: SizedBox(
                        width: 114,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              state.listOfTasks[index].status.name, style: TextStyle(
                                fontSize: 16.5),),
                            SizedBox(
                              height: 30,
                              child: Row(
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      color: Colors.black,
                                      onPressed: () => _showForm(
                                          state.listOfTasks[index].id, index, state.listOfTasks),
                                      icon: Icon(Icons.edit)
                                  ),
                                  IconButton(
                                      color: Colors.black,
                                      onPressed: () async {
                                        context.read<TaskCubit>()
                                            .deleteTask(index, state.listOfTasks);

                                        SnackBar snackBar = SnackBar(
                                          content: Text(
                                              "Work has been deleted..."),
                                          elevation: 5,);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
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
                  )
          ),
      ),
    );
  }

  // void _runFilter(String value) async {
  //   List <Task> result = [];
  //   if(value.isEmpty){
  //     // result = state.listOfTasks;
  //   }
  //   else{
  //     // result = await SQLHelper.searchItem(value);
  //   }
  //   setState(() {
  //     // listOfTasks = result;
  //     // _refresh();
  //   });
  // }

  Widget searchBar() {
    return Container(
      height: 44,
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(16)
      ),
      child:  TextField(//Search Bar
        style: TextStyle(color: Colors.white,
            fontSize: 19),
        controller: _searchBarController,
        onChanged: (value) => {
          // _runFilter(value.trim())
        },
        onTapOutside: (event){
          FocusManager.instance.primaryFocus?.unfocus();
        },
        cursorWidth: 2,
        cursorHeight: 20,
        cursorColor: Colors.white,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search_sharp,
              color: Colors.white,
              size: 19,
            ),
            border: InputBorder.none,
            hintText: "Search Task",
            hintStyle: TextStyle(
              color: Colors.white,
              fontSize: 19
            )
        ),
      ),
    );
  }

  bool toBoolean(String status) {
    if (status.toLowerCase() == "true") {
      return true;
    } else {
      return false;
    }
  }

}

