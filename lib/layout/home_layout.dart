import 'package:flutter/material.dart';
import 'package:todo_app1/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app1/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app1/modules/new_tasks/new_tasks_screen.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app1/shared/components/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app1/shared/cubit/states.dart';
import '../shared/cubit/cubit.dart';

class HomeLayout extends StatelessWidget {



  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();


  @override

  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child:  BlocConsumer<AppCubit , AppStates>(
       listener: (BuildContext context , AppStates state){
         if(state is AppInsertDatabaseState){
           Navigator.pop(context);
         }
       },
        builder: (BuildContext context , AppStates state){

         AppCubit cubit = AppCubit.get(context);
         cubit.createDatabase();
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
             body: cubit.newTasks.length == 0? Center( child: Text("No tasks added yet. Please add some tasks!")) : cubit.screens[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                //createDatabase();
                //insertToDatabase();

                if(cubit.isBottomSheetShown){
                  if(formKey.currentState!.validate()){
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);


                  }

                }
                else{
                  scaffoldKey.currentState?.showBottomSheet(
                        (context) => Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: titleController,
                              decoration:InputDecoration(
                                labelText: 'Task title',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(
                                  Icons.title,
                                ),

                              ),
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Title must be added!';
                                }
                                return null;
                              },

                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.datetime,
                              controller: timeController,
                              onTap: (){
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value) {
                                  timeController.text = value!.format(context);
                                  // print(value?.format(context));
                                });
                              },
                              decoration:InputDecoration(
                                labelText: 'Task time',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(
                                  Icons.watch_later_outlined,
                                ),

                              ),
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Time must be added!';
                                }
                                return null;
                              },

                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.datetime,
                              controller: dateController,
                              onTap: (){
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2023-10-30'),
                                ).then((value){

                                  dateController.text= DateFormat.yMMMd().format(value!);
                                });
                              },
                              decoration:InputDecoration(
                                labelText: 'Task date',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(
                                  Icons.calendar_month,
                                ),

                              ),
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Date must be added!';
                                }
                                return null;
                              },

                            ),
                          ],
                        ),
                      ),
                    ),
                    elevation: 15.0,
                  ).closed.then((value){
                    cubit.changeBottomSheetState(
                        isShow: false,
                        icon: Icons.edit);

                  });
                  cubit.changeBottomSheetState(
                      isShow: true,
                      icon: Icons.add);

                }
              },
              child: Icon(
                cubit.fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index){
                cubit.changeIndex(index);
                // setState(() {
                //   currentIndex = index;
                // });
              },
              items: [
                BottomNavigationBarItem(
                  icon:Icon(
                    Icons.menu,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon:Icon(
                    Icons.check,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon:Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archived',
                ),
              ],
            ),
          );
        } ,
      ),
    );


  }



}




