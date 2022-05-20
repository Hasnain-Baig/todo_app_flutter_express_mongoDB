import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todo_app/models/todoModel.dart';
import 'dart:async';

class ABC extends StatefulWidget {
  const ABC({Key? key}) : super(key: key);

  @override
  State<ABC> createState() => _ABCState();
}

class _ABCState extends State<ABC> {
  StreamController<TodoModel> _streamController = StreamController();

  void initState() {
    super.initState();
    // Timer.periodic(Duration(seconds: 10), (timer) {
    getTodos();
    // });
  }

  Future getTodos() async {
    var dio = Dio();
    String url = "https://todo-app-apis.herokuapp.com/apis/todos";
    final response = await dio.get(url);
    // print("Response===================>${response.statusCode}");
    print("===================>${response}");

    for (var i = 0; i < response.data.length; i++) {
      TodoModel todoModel = TodoModel.fromJSON(response.data[i]);
      _streamController.sink.add(todoModel);
    }
    // print("todo model---------------->$todoModel");

    return response.data;
  }

  @override
  void dispose() {
    _streamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<TodoModel>(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          print("steam data snap======================>${snapshot.data}");
          switch (snapshot.connectionState) {
            case ConnectionState.active:
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return BuildTodoWidget(snapshot.data!);
                  // return BuildTodoWidget(snapshot.data!);
                  // return Text(snapshot.data!);
                  // return Text("snapshot.data");
                },
              );

            default:
              if (snapshot.hasError) {
                return Text("PLEASE WAIT: ERROR");
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
          }
        },
      ),
    );
  }

  Widget BuildTodoWidget(TodoModel todoModel) {
    return Container(
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 250, 245, 238),
            border: Border(
              bottom: BorderSide(width: 3.0, color: Colors.white),
            )),
        // margin: EdgeInsets.only(top:5),
        child: ListTile(
          // tileColor: Colors.orange[50],
          title: Text(
            "${todoModel.item}",
            style: TextStyle(color: Colors.black),
          ),
          trailing: Container(
            width: 50,
            child: Row(
              children: [
                GestureDetector(
                    onTap: () => {
                          // editItemDialogBox(
                          //   snapshot.data![index]['_id'],
                          //   snapshot.data![index]['item'],
                          // ),
                        },
                    child: Icon(
                      Icons.edit,
                      color: Color.fromARGB(255, 243, 158, 31),
                    )),
                GestureDetector(
                    // onTap: () => {deleteItem()},
                    child: Icon(
                  Icons.delete,
                  color: Color.fromARGB(255, 243, 158, 31),
                )),
              ],
            ),
          ),
        ));
  }
}
