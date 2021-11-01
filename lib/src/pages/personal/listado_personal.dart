import 'package:asa_mexico/src/models/models_personal.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'maps_personal.dart';

class Listapersonalregistro extends StatefulWidget {
  @override
  _ListapersonalregistroState createState() => _ListapersonalregistroState();
}

final apiurl = Uri.parse(
  'https://asamexico.com.mx/php/controller/listamovpersonal.php',
);

Future<List<Locationpersonal>?> listaregistroper() async {
  var response = await http.get(apiurl);
  //print('====aqui =====$nmes===========aqui');
  if (response.statusCode == 200) {
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    //print(response.body);
    List<Locationpersonal>? locationpersonal =
        items.map<Locationpersonal>((json) {
      return Locationpersonal.fromJson(json);
    }).toList();

    return locationpersonal;
  } else {
    throw Exception('Failed to load data from Server.');
  }
}

class _ListapersonalregistroState extends State<Listapersonalregistro> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Locationpersonal>?>(
        future: listaregistroper(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
                children: snapshot.data!
                    .map((data) => Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        //Centramos con el Widget <a href="https://zimbronapps.com/flutter/center/">Center</a>
                        child: Card(
                            color: Colors.white,
                            child: ListTile(
                                leading: Icon(Icons.account_circle,
                                    size: 30.0,
                                    color: Color.fromRGBO(35, 56, 120, 1.0)),
                                title: Text(data.nombre!),
                                subtitle: Text('Tipo: ' +
                                    data.tipo! +
                                    ' Fecha:' +
                                    data.dia.toString() +
                                    '/' +
                                    data.mes.toString() +
                                    ' Hora: ' +
                                    data.hora!),
                                trailing: data.tipo == 'salida'
                                    ? Icon(
                                        Icons.arrow_forward_ios,
                                        size: 30,
                                        color: Colors.red,
                                      )
                                    : Icon(
                                        Icons.arrow_back_ios,
                                        size: 30,
                                        color: Colors.green,
                                      ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Mapersonal(
                                              data.nombre,
                                              data.tipo,
                                              data.latitude,
                                              data.longitude,
                                              data.fechaReg)));
                                }))))
                    .toList()),
          );
        });
  }
}
