import 'package:flutter/cupertino.dart';

import '../Interface/Model_Interface.dart';

class Rollsize implements Model {
  int? id;
  String? desc;
  static String query = 'select * from rollsize';
  Rollsize({this.desc, this.id});
  @override
  display() {
    return Text(this.desc!) ;
  }

  @override
  getQuery() {
    return Rollsize.query;
  }

  @override
  format(List li) {
    return li
        .map((e) => Rollsize(desc: e['rollsize'].toString(), id: e['id']))
        .toList();
  }


}
