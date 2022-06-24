import 'package:http/http.dart' as http;

class Get {
  static Future call(url) async {
    try {
      final uri = Uri.parse(url);
      final result = await http.get(
        uri,
      );
      return result;
    } catch (e) {
      print("Error From get method helper function");
      print(e);
    }
  }
}
