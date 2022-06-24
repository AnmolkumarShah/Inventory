import 'package:flutter/material.dart';
import 'package:inventory_second/Helpers/Text_check.dart';
import 'package:inventory_second/Interface/User_interface.dart';
import 'package:inventory_second/Models/Shade.dart';
import 'package:inventory_second/Models/Size.dart';
import 'package:inventory_second/Models/Type.dart';
import 'package:inventory_second/Screens/AddShade.dart';
import 'package:inventory_second/Screens/AddSize.dart';
import 'package:inventory_second/Screens/AddType.dart';
import 'package:inventory_second/Screens/AddUser.dart';
import 'package:inventory_second/Screens/ResetPassword.dart';
import 'package:inventory_second/Screens/StockINOUT/StockInStockOutScreen.dart';
import 'package:inventory_second/Screens/StockSTATEMENT/StockStatementScreen.dart';

import 'package:inventory_second/Screens/TransactionScreen.dart';

class Admin extends User {
  Admin({String? usrname, String? pass, int? id, bool? isAdm, bool? isBlk})
      : super(
          usrname: usrname,
          pass: pass,
          id: id,
          isadmin: isAdm,
          isblock: isBlk,
        );

  static castAdmin(User u) {
    return Admin(
      id: u.id,
      pass: u.pass,
      usrname: u.usrname,
      isAdm: u.isadmin,
      isBlk: u.isblock,
    );
  }

  display(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(
                forUser: this,
              ),
            ),
          );
        },
        child: ListTile(
          tileColor:
              this.isblock == true ? Colors.redAccent : Colors.amber[100],
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Name : " + this.usrname!,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Id  : " + this.id.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextCheck(
                label: "Admin",
                value: this.isadmin,
                cbkfun: this.ulterAdmin,
              ),
              TextCheck(
                label: "Blocked",
                value: this.isblock,
                cbkfun: this.ulterBlock,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  List<Map<String, dynamic>> available_option() {
    List<Map<String, dynamic>> list = [
      {
        "name": "Transactions",
        "value": TransactionScreen(),
      },
      {
        "name": "Stock Statement",
        "value": StockStatement(),
      },
      {
        "name": "Add ${Shade.getFieldName()}",
        "value": AllShade(),
      },
      {
        "name": "Stock In Out Report",
        "value": StockInOutScreen(),
      },
      {
        "name": "Add User",
        "value": AddUser(),
      },
      {
        "name": "Add ${Size.getFieldName()}",
        "value": AddSize(),
      },
      {
        "name": "Add ${Type.getFieldName()}",
        "value": AddType(),
      },
      {
        "name": "Reset Password",
        "value": ResetPasswordScreen(),
      }
    ];
    return list;
  }
}
