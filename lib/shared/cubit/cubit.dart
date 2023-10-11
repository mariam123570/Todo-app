import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app1/shared/components/constants.dart';
import 'package:todo_app1/shared/cubit/states.dart';

import '../../modules/archived_tasks/archived_tasks_screen.dart';
import '../../modules/done_tasks/done_tasks_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super (AppInitialStates());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Map> newTasks=[];
  List<Map> doneTasks=[];
  List<Map> archivedTasks=[];

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  List<Widget> screens =[
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> titles =[
    'New Tasks',
    'Done Tasks',
    'Archived tasks',
  ];
  var  database;

  void changeIndex(int index){
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase()async{
    await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database.execute('CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT,date TEXT, time TEXT, status TEXT)').then((value)
        {
          print('table created');
        }).catchError((error){
          print('error in create database method : \n\n ${error.toString()}');
        });
      },
      onOpen: (database){
        getDataFromDatabase(database);
        print('database opened');
      },
    ).then((value){
      database =value;
      emit(AppCreateDatabaseState());
    }).catchError((){
      print("Error while opening Database !! - cubit");
    });
  }

  insertToDatabase({
    required String title,
    required String time,
    required String date,
  })
  async {
    await database.transaction((txn) async {
      txn.rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")')
          .then((value){
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database);

      }).catchError((error){
        print('error when inserting new record ${error.toString()}');
      });

    });
  }

  void getDataFromDatabase(database)  {
    newTasks.clear();
    doneTasks.clear();
    archivedTasks.clear();
    emit(AppGetDatabaseLoadingState());
     database.rawQuery('SELECT * FROM tasks').then((value){

       value.forEach((element) {
         if(element['status'] == 'new'){
           newTasks.add(element);
         }else if(element['status'] == 'done') {
           doneTasks.add(element);
         }else{
           archivedTasks.add(element);
         }
       });
       emit(AppGetDatabaseState());
     });

  }

  void updateData({
    required String status,
    required int id,

}) async {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id],
     ).then((value){
       getDataFromDatabase(database);
       emit(AppUpdateDatabaseState());

     });


  }

  void deleteData({

    required int id,

  }) async {
   await database.rawDelete(
      'DELETE FROM tasks WHERE id = ?', [id],
    ).then((value){
      // TODO : need to make Dismissable removed heer

      newTasks.removeWhere((element) => element['id'] == id);
      // getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());

    });


  }

  void changeBottomSheetState({
  required bool isShow,
  required IconData icon,
}){
    isBottomSheetShown = isShow;
    fabIcon = icon;

    emit(AppChangeBottomSheetState());
  }
}

