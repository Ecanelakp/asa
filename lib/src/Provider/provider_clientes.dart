import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Providerclientes {
  String selectedSpinnerItem = '1104-001';
  List? data = [];
  Future? myFuture;
  final format = ("yyyy-MM-dd");
  TextEditingController referenciactl = TextEditingController();
  TextEditingController proyectoctl = TextEditingController();
  TextEditingController responsablectl = TextEditingController();
  TextEditingController noclientectl = TextEditingController();
  TextEditingController observacionesctl = TextEditingController();

  String estado = "";
  bool? error, sending, success;
  String? msg;

  final url = Uri.parse(
      'https://asamexico.com.mx/php/controller/clientes.php?op=GetClientes');

  Future<String> fetchData() async {
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var res = await http.get(url);

      var resBody = json.decode(res.body);

      print(resBody);

      data = resBody;

      print('Loaded Successfully');

      return "Loaded Successfully";
    } else {
      throw Exception('Failed to load data.');
    }
  }
}
