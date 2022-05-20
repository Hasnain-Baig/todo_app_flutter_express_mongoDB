import 'package:flutter/material.dart';
// import 'package:todo_app/ToDoApp.dart';
import 'package:todo_app/a.dart';
import 'package:todo_app/abc.dart';

import 'ToDoApp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home:
            //  A()
            ToDoApp()
        // ABC()
        );
  }
}