import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:inventory_second/Helpers/Text_check.dart';
import 'package:inventory_second/Interface/User_interface.dart';
import 'package:inventory_second/Screens/ResetPassword.dart';
import 'package:inventory_second/Screens/StockSTATEMENT/StockStatementScreen.dart';

class NormalUser extends User {
  NormalUser({
    String? usrname,
    String? pass,
    bool? isAdm,
    bool? isblk,
    int? id,
  }) : super(
            usrname: usrname,
            pass: pass,
            id: id,
            isadmin: isAdm,
            isblock: isblk);

  @override
  List<Map<String, dynamic>> available_option() {
    List<Map<String, dynamic>> list = [
      {
        "name": "Stock Screen",
        "value": StockStatement(),
      },
      {
        "name": "Reset Password",
        "value": ResetPasswordScreen(),
      }
    ];
    return list;
  }

  static castNormal(User u) {
    return NormalUser(
      id: u.id,
      pass: u.pass,
      usrname: u.usrname,
      isAdm: u.isadmin,
      isblk: u.isblock,
    );
  }

  @override
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
              this.isblock == true ? Colors.redAccent : Colors.lightBlue[100],
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
}
