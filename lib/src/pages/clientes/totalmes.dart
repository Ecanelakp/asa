import 'package:asa_mexico/src/Provider/meselect.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Pagina extends StatefulWidget {
  @override
  _PaginaState createState() => _PaginaState();
}

String _mensaje = "";
final apiurl1 = Uri.parse(
  'https://asamexico.com.mx/php/controller/ventassummes.php',
);
int? nmes;

class _PaginaState extends State<Pagina> {
  //Future<String> futureAlbum;

  //dynamic gasto = double.parse(_mensaje);
  @override
  Widget build(BuildContext context) {
    final wmes = Provider.of<Meses>(context);

    nmes = wmes.mes as int?;
    recibirString();

    dynamic gasto = double.parse(_mensaje);

    return Column(
      children: [
        Text(
          NumberFormat.currency(locale: 'es-mx').format(gasto),
          style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 2),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ignore: missing_return
  Future<String?> recibirString() async {
    var data = {'nmes': nmes.toString()};
    final respuesta = await http.post(apiurl1, body: json.encode(data));

    if (respuesta.statusCode == 200) {
      //log(respuesta.body.toString());

      setState(() {
        _mensaje = respuesta.body.toString();
      });
    } else {
      throw Exception("Fallo");
    }
  }

  @override
  void initState() {
    recibirString();
    _mensaje = '0';
    super.initState();
  }
}
