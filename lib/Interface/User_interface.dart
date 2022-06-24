import 'package:flutter/cupertino.dart';
import 'package:inventory_second/Helpers/FetchFormatter.dart';

class User {
  static String? query = "select * from usr_mast order by isadmin desc,id asc";

  String? usrname;
  String? pass;
  int? id;
  bool? isadmin;
  bool? isblock;

  User({
    this.id,
    this.pass,
    this.isadmin,
    this.isblock,
    this.usrname,
  });

  static format(List<dynamic> li) {
    List<User> userList = li
        .map((e) => User(
              id: e['id'],
              isadmin: e['isadmin'] == null ? false : e['isadmin'],
              isblock: e['isblock'] == null ? false : e['isblock'],
              pass: e['pwd'],
              usrname: e['usr_nm'],
            ))
        .toList();
    return userList;
  }

  ulterAdmin(bool? value) async {
    var result = await fetchQuery(
      query: """
        update usr_mast
        set isadmin = ${value == true ? 1 : 0}
        where id = ${this.id}
      """,
      p1: '1',
    );
    return result;
  }

  ulterBlock(bool? value) async {
    var result = await fetchQuery(
      query: """
        update usr_mast
        set isblock = ${value == true ? 1 : 0}
        where id = ${this.id}
      """,
      p1: '1',
    );
    return result;
  }

  getName() {
    return this.usrname;
  }

  getPass() {
    return this.pass;
  }

  getId() {
    return this.id;
  }

  login() async {
    var result = await fetchQuery(
        query:
            "select * from usr_mast where usr_nm = '${this.usrname}' and pwd = '${this.pass}' ");
    if ((result as List<dynamic>).length >= 1) {
      return {'msg': true, 'data': result[0]};
    }
    return {'msg': false, 'data': null};
  }

  addUser() async {
    var result = await fetchQuery(
      p1: '1',
      query: '''

        insert into usr_mast(usr_nm,pwd,isadmin,isblock)
        values('${this.usrname}', '${this.pass}',0,0)

      ''',
    );
    return result;
  }

  resetPassword(String? newP) async {
    var check = await this.login();
    print("------------");
    print(check);
    print("------------");
    if (check['msg'] == true) {
      var result = await fetchQuery(
        p1: '1',
        query: '''
          update usr_mast
          set pwd = '${newP}'
          where usr_nm = '${this.usrname}' and pwd = '${this.pass}'
        ''',
      );

      if (result['status'] == 'success') {
        this.pass = newP;
        return true;
      }
      return false;
    }
    return false;
  }

  available_option() {}
  display(BuildContext context) {}
}
