import 'dart:convert';
import 'package:Asamexico/app/variables/servicesurl.dart';

import 'package:http/http.dart' as http;

Future altanotificaciones(
  String? _user,
  String? _asunto,
  String? _descripcion,
) async {
  var data = {
    'tipo': 'alta_notificacion',
    'asunto': _asunto,
    'descripcion': _descripcion,
    'usuario': _user
  };
  print(data);

  final reponse = await http.post(urlnotificaciones,
      headers: {
        "Accept": "application/json",
        // "Content-Type": "application/json;charset=UTF-8",
        // "Charset": "utf-8"
      },
      body: json.encode(data));
  // print('aquiiiiiiiiiiiiiiiiiiiiiiii');
  // print(reponse.body);
}
