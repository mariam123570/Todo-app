import 'package:flutter/material.dart';
import 'package:todo_app1/shared/cubit/cubit.dart';
import 'layout/home_layout.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),

    );

  }

}





