// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';

// class A extends StatefulWidget {
//   @override
//   _AState createState() => _AState();
// }

// class _AState extends State<A> {
//   List lst = [];
//   var item = "";
//   TextEditingController editText = TextEditingController();

//   StreamController _streamController =
//       StreamController(); // <List> todoArr = [] as Future<List>;

//   Map loadObj = {"isLoading": false, "action": ""};

//   void initState() {
//     todoArr = getTodoArr() as StreamController;
//     super.initState();
//   }

//   Future<List> getTodoArr() async {
//     var dio = Dio();
//     String url = "https://todo-app-apis.herokuapp.com/apis/todos";
//     // String url = "https://fakestoreapi.com/products/category/jewelery";
//     final response = await dio.get(url);
//     print("Response===================>${response.statusCode}");
//     print("===================>${response.data}");
//     lst = response.data;
//     return response.data;

// //     var axios = Axios();
// //       String url = "http://crud-mern-1.herokuapp.com/apis/users";
// //       axios.get(url)
// //       .then((response)=>{
// // print(response.data);
// //       })
// //       .catch((err)=>{
// // print(err);

// //       })
//   }

//   addItem(var item) async {
//     setState(() {
//       loadObj['isLoading'] = true;
//       loadObj['action'] = "adding";
//     });
//     Navigator.of(context)
//         .pop(); //for after clicking move to  homescreen immediately
//     // await Future.delayed(const Duration(seconds: 5));
//     if (item != "") {
//       var dio = Dio();
//       String url = "https://todo-app-apis.herokuapp.com/apis/todos";
//       final response = await dio.post(url, data: {"item": item});
//       setState(() {
//         loadObj['isLoading'] = false;
//         loadObj['action'] = "";
//       });

//       print("===================>${response.data}");
//       lst.add(response.data);
//       // print("after last============>$response");
//       // return response.data;
//     } else {
//       emptyInputDialogBox();
//       // addItemDialogBox();
//     }
//     setState(() {});
//   }

//   editItem(var id, var item) async {
//     setState(() {
//       loadObj['isLoading'] = true;
//       loadObj['action'] = "updating";
//     });
//     Navigator.of(context)
//         .pop(); //for after clicking move to  homescreen immediately
//     if (item != "") {
//       var dio = Dio();
//       String url = "https://todo-app-apis.herokuapp.com/apis/todos/$id";
//       final response = await dio.put(url, data: {"item": item});
//       setState(() {
//         loadObj['isLoading'] = false;
//         loadObj['action'] = "";
//       });
//       print("===================>${response.data}");
//       // print("last============>$lst");
//       // lst.replaceRange(index, index + 1, {item});
//       return response.data;
//     } else {
//       emptyInputDialogBox();
//       // editItemDialogBox(index);
//     }
//     setState(() {});
//   }

//   deleteItem(var id) async {
//     print(id);
//     setState(() {
//       loadObj['isLoading'] = true;
//       loadObj['action'] = "deleting";
//     });

//     var dio = Dio();
//     String url = "https://todo-app-apis.herokuapp.com/apis/todos/$id";
//     final response = await dio.delete(url);
//     setState(() {
//       loadObj['isLoading'] = false;
//       loadObj['action'] = "";
//     });
//     print("===================>${response.data}");
//     // lst.removeAt(index);
//     initState();
//     setState(() {});
//     // return response.data;
//   }

//   addItemDialogBox() {
//     item = "";
//     showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Container(
//                 width: MediaQuery.of(context).size.width * 1,
//                 padding: EdgeInsets.all(10),
//                 color: Colors.orange,
//                 child: Center(
//                     child: Text(
//                   "Add Item",
//                   style: TextStyle(color: Colors.white),
//                 ))),
//             content: TextField(
//               cursorColor: Colors.orange,
//               decoration: InputDecoration(
//                 focusedBorder: UnderlineInputBorder(
//                   borderSide: BorderSide(color: Colors.red),
//                 ),
//               ),
//               autofocus: true,
//               onChanged: (value) {
//                 item = value;
//               },
//             ),
//             actions: [
//               ElevatedButton(
//                 style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all(Colors.orange)),
//                 onPressed: () => {addItem(item)},
//                 child: Text("Add"),
//               )
//             ],
//           );
//         });
//   }

//   editItemDialogBox(var id, var oldItem) {
//     editText.text = oldItem;
//     showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Container(
//               width: MediaQuery.of(context).size.width * 1,
//               padding: EdgeInsets.all(10),
//               color: Colors.orange,
//               child: Center(
//                   child: Text(
//                 "Edit Item",
//                 style: TextStyle(color: Colors.white),
//               )),
//             ),
//             content: TextField(
//               controller: editText,
//               cursorColor: Colors.orange,
//               decoration: InputDecoration(
//                 focusedBorder: UnderlineInputBorder(
//                   borderSide: BorderSide(color: Colors.red),
//                 ),
//               ),
//               // style:StrutStyle() ,
//               autofocus: true,
//               onChanged: (value) {
//                 item = value;
//               },
//             ),
//             actions: [
//               ElevatedButton(
//                 style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all(Colors.orange)),
//                 onPressed: () => {editItem(id, item)},
//                 child: Text(
//                   "Update",
//                 ),
//               )
//             ],
//           );
//         });
//   }

//   emptyInputDialogBox() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Container(
//             width: MediaQuery.of(context).size.width * .3,
//             padding: EdgeInsets.all(8),
//             color: Colors.orange,
//             child: Center(
//                 child: Text(
//               "ERROR",
//               style: TextStyle(color: Colors.white),
//             )),
//           ),
//           content: Container(
//               width: MediaQuery.of(context).size.width * .3,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text("No Input Found!\nKindly fill the text field"),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     style: ButtonStyle(
//                         backgroundColor:
//                             MaterialStateProperty.all(Colors.orange)),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                       // addItemDialogBox();
//                     },
//                     child: Text("OK"),
//                   )
//                 ],
//               )),
//         );
//       },
//     );
//   }

//   loadingDialog() {
//     return AlertDialog(
//       title: Container(
//         width: MediaQuery.of(context).size.width * .3,
//         padding: EdgeInsets.all(8),
//         color: Colors.orange,
//         child: Center(
//             child: Text(
//           loadObj['action'],
//           style: TextStyle(color: Colors.white),
//         )),
//       ),
//       content: Container(
//           width: MediaQuery.of(context).size.width * .3,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             // mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Center(
//                 child: CircularProgressIndicator(
//                   color: Colors.orange,
//                 ),
//               ),
//             ],
//           )),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("To Do App"),
//         backgroundColor: Colors.orange,
//       ),
//       body: loadObj['isLoading']
//           ? loadingDialog()
//           : SingleChildScrollView(
//               physics: ScrollPhysics(),
//               child: Column(
//                 children: [
//                   StreamBuilder<int>(
//                     stream: todoArr.stream,
//                     builder: (
//                       BuildContext context,
//                       AsyncSnapshot<int> snapshot,
//                     ) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return CircularProgressIndicator();
//                       } else if (snapshot.connectionState ==
//                               ConnectionState.active ||
//                           snapshot.connectionState == ConnectionState.done) {
//                         if (snapshot.hasError) {
//                           return const Text('Error');
//                         } else if (snapshot.hasData) {
//                           return Text(snapshot.data.toString(),
//                               style: const TextStyle(
//                                   color: Colors.red, fontSize: 40));
//                         } else {
//                           return const Text('Empty data');
//                         }
//                       } else {
//                         return Text('State: ${snapshot.connectionState}');
//                       }
//                     },
//                   ),
//                   // ),
//                 ],
//               ),
//             ),
//       floatingActionButton: FloatingActionButton(
//           backgroundColor: Colors.orange,
//           onPressed: () =>
//               {loadObj['isLoading'] ? loadingDialog() : addItemDialogBox()},
//           child: Icon(Icons.add)),
//     );
//   }
// }
