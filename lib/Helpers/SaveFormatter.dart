import 'dart:convert';

import 'package:inventory_second/Helpers/url_model.dart';

import 'getMethodHelperFunction.dart';

Future saveFormatter(String? query) async {
  final UrlGlobal urlObject = new UrlGlobal(
    p2: query!,
    p1: '1',
  );
  try {
    final url = urlObject.getUrl();
    var result = await Get.call(url);
    final data = json.decode(result.body);
    return data;
  } catch (e) {
    print(e.toString());
    return [];
  }
}
