import 'dart:convert';
import 'package:inventory_second/Helpers/getMethodHelperFunction.dart';
import 'package:inventory_second/Helpers/url_model.dart';
import 'package:inventory_second/Interface/Model_Interface.dart';
import 'package:inventory_second/Interface/User_interface.dart';
import 'package:inventory_second/Models/Admin.dart';
import 'package:inventory_second/Models/NormalUser.dart';

Future fetch(Model m) async {
  final UrlGlobal urlObject = new UrlGlobal(
    p2: m.getQuery(),
  );
  try {
    final url = urlObject.getUrl();
    var result = await Get.call(url);
    final data = json.decode(result.body) as List<dynamic>;
    result = m.format(data);
    return result;
  } catch (e) {
    print(e.toString());
    return [];
  }
}

Future fetchUser() async {
  final UrlGlobal urlObject = new UrlGlobal(
    p2: User.query!,
  );
  try {
    final url = urlObject.getUrl();
    var result = await Get.call(url);
    final data = json.decode(result.body) as List<dynamic>;
    List<User> user_list = User.format(data);
    List<dynamic> final_list = user_list.map((element) {
      if (element.isadmin == true) {
        return Admin.castAdmin(element);
      } else {
        return NormalUser.castNormal(element);
      }
    }).toList();
    return final_list;
  } catch (e) {
    print(e.toString());
    return [];
  }
}

Future fetchQuery({String? query, String? p1 = '0'}) async {
  final UrlGlobal urlObject = new UrlGlobal(
    p2: query!,
    p1: p1!,
  );
  try {
    final url = urlObject.getUrl();
    var result = await Get.call(url);
    var data;
    try {
      data = json.decode(result.body) as List<dynamic>;
    } catch (e) {
      data = json.decode(result.body);
    }
    print(data);
    return data;
  } catch (e) {
    print(e.toString());
    return [];
  }
}
