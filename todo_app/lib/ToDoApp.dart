import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ToDoApp extends StatefulWidget {
  @override
  _ToDoAppState createState() => _ToDoAppState();
}

class _ToDoAppState extends State<ToDoApp> {
  List lst = [];
  var item = "";
  TextEditingController editText = TextEditingController();

  late Future<List> todoArr = [] as Future<List>;

  Map loadObj = {"isLoading": false, "action": ""};

  void initState() {
    todoArr = getTodoArr();
    super.initState();
  }

  Future<List> getTodoArr() async {
    var dio = Dio();
    String url = "https://todo-app-apis.herokuapp.com/apis/todos";
    final response = await dio.get(url);
    return response.data;
  }

  addItem(var item) async {
    setState(() {
      loadObj['isLoading'] = true;
      loadObj['action'] = "adding";
    });
    Navigator.of(context)
        .pop(); //for after clicking move to  homescreen immediately
    if (item != "") {
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

      // print("===================>${response.data}");
      // lst.add(response.data);
    } else {
      emptyInputDialogBox();
      // addItemDialogBox();
    }
    setState(() {});
  }

  editItem(var id, var item) async {
    setState(() {
      loadObj['isLoading'] = true;
      loadObj['action'] = "updating";
    });
    Navigator.of(context)
        .pop(); //for after clicking move to  homescreen immediately
    if (item != "") {
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
      // print("===================>${response.data}");
      // print("last============>$lst");
      // lst.replaceRange(index, index + 1, {item});
      return response.data;
    } else {
      emptyInputDialogBox();
      // editItemDialogBox(index);
    }
    setState(() {});
  }

  deleteItem(var id) async {
    print(id);
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
    print("===================>${response.data}");
    setState(() {});
    // return response.data;
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
                              : Center(
                                  child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Text("No Data Found")));
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
