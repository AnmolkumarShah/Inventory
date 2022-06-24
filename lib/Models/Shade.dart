import 'package:flutter/material.dart';

import '../Interface/Model_Interface.dart';

class Shade implements Model {
  int? id;
  String? desc;
  int? rvalue;
  int? bvalue;
  int? gvalue;

  static late String fieldName = "Shade Anmol";

  static void setFieldName(String name) {
    fieldName = name;
  }

  static String getFieldName() {
    return fieldName;
  }

  static String query = 'select * from shade';
  Shade(
      {this.desc, this.id, this.bvalue = 0, this.gvalue = 0, this.rvalue = 0});

  getRGB() {
    return [this.rvalue, this.bvalue, this.gvalue];
  }

  @override
  display() {
    return Row(
      children: [
        Text(
          this.desc!,
        ),
        const SizedBox(width: 10),
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            border: Border.all(),
            color: Color.fromRGBO(this.rvalue!, this.gvalue!, this.bvalue!, 1),
            // color: Colors.amber,
          ),
        )
      ],
    );
  }

  @override
  getQuery() {
    return Shade.query;
  }

  @override
  format(List li) {
    return li
        .map((e) => Shade(
              desc: e['shade'],
              id: e['id'],
              rvalue: e['rvalue'],
              bvalue: e['bvalue'],
              gvalue: e['gvalue'],
            ))
        .toList();
  }
}
