import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MyApp1 extends StatefulWidget {
  final String base64image;
  MyApp1(this.base64image);

  @override
  _MyApp1State createState() => _MyApp1State();
}

String _toname = 'Agustin Perez';
String _encargado = 'Edgardo Shancez';
String _puesto = 'Encargado de frezzers';
String _cantidad = '2.02';
String _sistemas = 'Sistema de Reconstruccion de agujeros';
String _titulo = 'Avance por dia';
String _date = '03/11/2021';

class _MyApp1State extends State<MyApp1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("pruaba de correo"),
      ),
      body: Center(
        child: Column(
          children: [
            Container(child: Text(_toname)),
            Text(_encargado),
            Text(_puesto),
            Text(_cantidad),
            Text(_sistemas),
            Text(_titulo),
            Text(_date),
            Container(
                color: Colors.amberAccent,
                child: TextButton(
                    onPressed: () {
                      sendmail();
                    },
                    child: Text("mandar"))),
          ],
        ),
      ),
    );
  }
}

Future sendmail() async {
  log('hola');
  final url = Uri.parse(
      'https://asamexico.com.mx/php/controller/notificacionavancesmail.php');
  final reponse = await http.post(url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'titiulo': _titulo,
        'to_name': _toname,
        'fecha': _date,
        'quatity': _cantidad,
        'system': _sistemas,
        'user': 'Joel',
        'nameencargado': _encargado,
        'puesto': _puesto,
      }));

  log(reponse.body);
}
