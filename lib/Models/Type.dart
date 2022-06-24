import 'package:flutter/material.dart';

import '../Interface/Model_Interface.dart';

class Type implements Model {
  int? id;
  String? desc;
  static String query = 'select * from type';
  Type({this.desc, this.id});
  @override
  display() {
    return Text(this.desc!);
  }

  static late String fieldName = "Type Anmol";

  static void setFieldName(String name) {
    fieldName = name;
  }

  static String getFieldName() {
    return fieldName;
  }

  @override
  getQuery() {
    return Type.query;
  }

  @override
  format(List li) {
    return li.map((e) => Type(desc: e['type'], id: e['id'])).toList();
  }
}
