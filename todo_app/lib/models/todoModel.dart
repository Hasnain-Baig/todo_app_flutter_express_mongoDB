import 'package:flutter/material.dart';

class TodoModel {
  var id;
  var item;

  TodoModel.fromJSON(Map data) {
    print(data);
    id = data['_id'];
    item = data['item'];
    // print("ilen============   $length");
    // print("item   $item");
  }

  Map toJSON() => {'_id': id, 'item': item};
}
