import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:todo_app/components/errorDialogBox.dart';

class ToDoApp extends StatefulWidget {
  @override
  _ToDoAppState createState() => _ToDoAppState();
}

class _ToDoAppState extends State<ToDoApp> {
  // List lst = [];
  var item = "";
  TextEditingController editText = TextEditingController();

  late Future<List> todoArr = [] as Future<List>;

  Map loadObj = {"isLoading": false, "action": ""};
  var isInternetConnected = false;

// initSTATE
  void initState() {
    todoArr = getTodoArr();
    super.initState();
  }

  // fetching data
  Future<List> getTodoArr() async {
    try {
      var dio = Dio();
      String url = "https://todo-app-apis.herokuapp.com/apis/todos";
      final response = await dio.get(url);
      setState(() {
        isInternetConnected = true;
      });
      return response.data;
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return ErrorDialogBox(dataError: "No Internet Connection");
          });
      setState(() {
        isInternetConnected = false;
      });
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
      ),
      body: loadObj['isLoading']
          ? loadingDialog()
          : SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                children: [
                  FutureBuilder<List>(
                      future: todoArr,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return snapshot.data!.length != 0
                              ? ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
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
                                          "${snapshot.data![index]['item']}",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        trailing: Container(
                                          width: 50,
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                  onTap: () => {
                                                        editItemDialogBox(
                                                          snapshot.data![index]
                                                              ['_id'],
                                                          snapshot.data![index]
                                                              ['item'],
                                                        ),
                                                      },
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: Color.fromARGB(
                                                        255, 243, 158, 31),
                                                  )),
                                              GestureDetector(
                                                  onTap: () => {
                                                        deleteItem(snapshot
                                                                .data![index]
                                                            ['_id'])
                                                      },
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: Color.fromARGB(
                                                        255, 243, 158, 31),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : isInternetConnected == true
                                  ? Center(
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Text("No Data Found")))
                                  : Center(
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Text(
                                              "Internet Connection Error")));
                        } else {
                          return Center(
                              child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: CircularProgressIndicator(
                                    color: Color.fromARGB(255, 243, 158, 31),
                                  )));
                        }
                        return Center(
                            child:
                                Container(child: CircularProgressIndicator()));
                      }),

                  // ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange,
          onPressed: () =>
              {loadObj['isLoading'] ? loadingDialog() : addItemDialogBox()},
          child: Icon(Icons.add)),
    );
  }
}
