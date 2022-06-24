import 'package:flutter/material.dart';

import '../Interface/Model_Interface.dart';

class Trantype implements Model {
  int? id;
  String? desc;
  static String query = 'select * from trantype';
  Trantype({this.desc, this.id});
  @override
  display() {
    return Text(this.desc!);
  }

  @override
  getQuery() {
    return Trantype.query;
  }

  @override
  format(List li) {
    return li.map((e) => Trantype(desc: e['Trantype'], id: e['id'])).toList();
  }


}
