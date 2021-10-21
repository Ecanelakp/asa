import 'dart:convert';
import 'package:asa_mexico/src/models/models_mate.dart';
//import 'package:asa_mexico/src/pages/materiales/listamateriales.dart';
import 'package:http/http.dart' as http;

final apiurl = Uri.parse(
  'https://asamexico.com.mx/php/controller/listamateriales.php',
);
final url = Uri.parse(
  'https://jsonplaceholder.typicode.com/users',
);

class Services {
  static Future<List<User>> getUsers() async {
    try {
      final response = await http.get(apiurl);
      if (response.statusCode == 200) {
        List<User> list = parseUsers(response.body);
        return list;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static List<User> parseUsers(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }
}
