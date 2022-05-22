import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:todo_app/components/errorDialogBox.dart';

class ToDoApp extends StatefulWidget {
  @override
  _ToDoAppState createState() => _ToDoAppState();
}

class _ToDoAppState extends State<ToDoApp> with WidgetsBindingObserver {
  var item = "";
  TextEditingController editText = TextEditingController();

  late Future<List> todoArr = [] as Future<List>;

  Map loadObj = {"isLoading": false, "action": ""};
  var isInternetConnected = false;

// initSTATE
  void initState() {
    todoArr = getTodoArr();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isInternetConnected = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isInternetConnected = false;
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      // print("paused----$isInternetConnected");
    }
    if (state == AppLifecycleState.resumed) {
      // print("resumed----$isInternetConnected");
      checkConnection();
    }
    if (state == AppLifecycleState.inactive) {
      // print("inact");
    }
    if (state == AppLifecycleState.detached) {
      // print("detached");
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // fetching data
  Future<List> getTodoArr() async {
    try {
      var dio = Dio();
      String url = "https://todo-app-apis.herokuapp.com/apis/todos";
      final response = await dio.get(url);
      // print("Try response----------->${response.data}");
      return response.data;
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return ErrorDialogBox(dataError: "No Internet Connection");
          });
      // print("Error----------->$e");
      return [];
    }
  }

// posting todo
  addItem(var item) async {
    //for after clicking move to  homescreen immediately
    try {
      Navigator.of(context).pop();
      if (item != "") {
        setState(() {
          loadObj['isLoading'] = true;
          loadObj['action'] = "adding";
        });
        var dio = Dio();
        String url = "https://todo-app-apis.herokuapp.com/apis/todos";
        final response = await dio.post(url, data: {"item": item});
        setState(() {
          todoArr = getTodoArr();
        });
        setState(() {
          loadObj['isLoading'] = false;
          loadObj['action'] = "";
        });
      } else {
        emptyInputDialogBox();
      }
    } catch (e) {
      setState(() {
        loadObj['isLoading'] = false;
        loadObj['action'] = "";
      });
      showDialog(
          context: context,
          builder: (context) {
            return ErrorDialogBox(dataError: "No Internet Connection");
          });
    }

    setState(() {});
  }

// put todo
  editItem(var id, var item) async {
    try {
      Navigator.of(context).pop();
      if (item != "") {
        setState(() {
          loadObj['isLoading'] = true;
          loadObj['action'] = "updating";
        });
        var dio = Dio();
        String url = "https://todo-app-apis.herokuapp.com/apis/todos/$id";
        final response = await dio.put(url, data: {"item": item});
        setState(() {
          todoArr = getTodoArr();
        });
        setState(() {
          loadObj['isLoading'] = false;
          loadObj['action'] = "";
        });
        return response.data;
      } else {
        emptyInputDialogBox();
      }
    } catch (e) {
      setState(() {
        loadObj['isLoading'] = false;
        loadObj['action'] = "";
      });
      showDialog(
          context: context,
          builder: (context) {
            return ErrorDialogBox(dataError: "No Internet Connection");
          });
    }

    setState(() {});
  }

// todo delete
  deleteItem(var id) async {
    try {
      setState(() {
        loadObj['isLoading'] = true;
        loadObj['action'] = "deleting";
      });

      var dio = Dio();
      String url = "https://todo-app-apis.herokuapp.com/apis/todos/$id";
      final response = await dio.delete(url);
      setState(() {
        todoArr = getTodoArr();
      });
      setState(() {
        loadObj['isLoading'] = false;
        loadObj['action'] = "";
      });
    } catch (e) {
      setState(() {
        loadObj['isLoading'] = false;
        loadObj['action'] = "";
      });
      showDialog(
          context: context,
          builder: (context) {
            return ErrorDialogBox(dataError: "No Internet Connection");
          });
    }
    setState(() {});
  }

  addItemDialogBox() {
    item = "";
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Container(
                width: MediaQuery.of(context).size.width * 1,
                padding: EdgeInsets.all(10),
                color: Colors.orange,
                child: Center(
                    child: Text(
                  "Add Item",
                  style: TextStyle(color: Colors.white),
                ))),
            content: TextField(
              cursorColor: Colors.orange,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
              autofocus: true,
              onChanged: (value) {
                item = value;
              },
            ),
            actions: [
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.orange)),
                onPressed: () => {addItem(item)},
                child: Text("Add"),
              )
            ],
          );
        });
  }

  editItemDialogBox(var id, var oldItem) {
    editText.text = oldItem;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Container(
              width: MediaQuery.of(context).size.width * 1,
              padding: EdgeInsets.all(10),
              color: Colors.orange,
              child: Center(
                  child: Text(
                "Edit Item",
                style: TextStyle(color: Colors.white),
              )),
            ),
            content: TextField(
              controller: editText,
              cursorColor: Colors.orange,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
              // style:StrutStyle() ,
              autofocus: true,
              onChanged: (value) {
                item = value;
              },
            ),
            actions: [
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.orange)),
                onPressed: () => {editItem(id, item)},
                child: Text(
                  "Update",
                ),
              )
            ],
          );
        });
  }

  emptyInputDialogBox() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Container(
            width: MediaQuery.of(context).size.width * .3,
            padding: EdgeInsets.all(8),
            color: Colors.orange,
            child: Center(
                child: Text(
              "ERROR",
              style: TextStyle(color: Colors.white),
            )),
          ),
          content: Container(
              width: MediaQuery.of(context).size.width * .3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("No Input Found!\nKindly fill the text field"),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.orange)),
                    onPressed: () {
                      Navigator.of(context).pop();
                      // addItemDialogBox();
                    },
                    child: Text("OK"),
                  )
                ],
              )),
        );
      },
    );
  }

  loadingDialog() {
    return AlertDialog(
      title: Container(
        width: MediaQuery.of(context).size.width * .3,
        padding: EdgeInsets.all(8),
        color: Colors.orange,
        child: Center(
            child: Text(
          loadObj['action'],
          style: TextStyle(color: Colors.white),
        )),
      ),
      content: Container(
          width: MediaQuery.of(context).size.width * .3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: CircularProgressIndicator(
                  color: Colors.orange,
                ),
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To Do App"),
        backgroundColor: Colors.orange,
        actions: [
          GestureDetector(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.refresh,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                checkConnection();
                todoArr = getTodoArr();
              })
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(children: [
            FutureBuilder<List>(
                future: todoArr,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(
                          child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: CircularProgressIndicator(
                                color: Color.fromARGB(255, 243, 158, 31),
                              )));
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        return isInternetConnected == false
                            ? Center(
                                child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text("Internet Connection Error")))
                            : loadObj['isLoading'] == true
                                ? loadingDialog()
                                : snapshot.data!.length == 0
                                    ? Center(
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Text("No Item Found")))
                                    : ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, index) {
                                          var itemVal =
                                              snapshot.data![index]['item'];
                                          var itemId =
                                              snapshot.data![index]['_id'];

                                          return Container(
                                            decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 250, 245, 238),
                                                border: Border(
                                                  bottom: BorderSide(
                                                      width: 3.0,
                                                      color: Colors.white),
                                                )),
                                            child: ListTile(
                                              title: Text(
                                                "$itemVal",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              trailing: Container(
                                                width: 50,
                                                child: Row(
                                                  children: [
                                                    GestureDetector(
                                                        onTap: () => {
                                                              editItemDialogBox(
                                                                itemId,
                                                                itemVal,
                                                              ),
                                                            },
                                                        child: Icon(
                                                          Icons.edit,
                                                          color: Color.fromARGB(
                                                              255,
                                                              243,
                                                              158,
                                                              31),
                                                        )),
                                                    GestureDetector(
                                                        onTap: () => {
                                                              deleteItem(itemId)
                                                            },
                                                        child: Icon(
                                                          Icons.delete,
                                                          color: Color.fromARGB(
                                                              255,
                                                              243,
                                                              158,
                                                              31),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                      }
                  }
                  return Center(
                      child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: CircularProgressIndicator(
                            color: Color.fromARGB(255, 243, 158, 31),
                          )));
                }),

            // ),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange,
          onPressed: () => addItemDialogBox(),
          child: Icon(Icons.add)),
    );
  }
}
