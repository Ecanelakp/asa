import 'package:Asamexico/app/variables/colors.dart';
import 'package:Asamexico/app/variables/servicesurl.dart';
import 'package:Asamexico/app/variables/variables.dart';
import 'package:Asamexico/models/tareas_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class lista_notifaciones extends StatefulWidget {
  @override
  State<lista_notifaciones> createState() => _lista_notifacionesState();
}

class _lista_notifacionesState extends State<lista_notifaciones> {
  @override
  void initState() {
    super.initState();
    listacoti();
  }

  Future<List<Modellistnotificaciones>> listacoti() async {
    //print('======$notmes======');
    var data = {'tipo': 'lista_notificaciones', 'usuario': usuario};
    //print(data);
    final response = await http.post(urlnotificaciones,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      // print(response.body);

      List<Modellistnotificaciones> studentList =
          items.map<Modellistnotificaciones>((json) {
        return Modellistnotificaciones.fromJson(json);
      }).toList();
      setState(() {});

      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Modellistnotificaciones>>(
        future: listacoti(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Container(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
              ),
            );

          return ListView(
              children: snapshot.data!
                  .map((data) => Card(
                        child: Container(
                          color: blanco,
                          child: ListTile(
                            onTap: (() {
                              actnotificacion(data.id);
                            }),
                            trailing: IconButton(
                                onPressed: () {
                                  borranotificacion(data.id);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: rojo,
                                )),
                            leading: data.leido == '2'
                                ? Text('')
                                : Text('Nueva!',
                                    style: GoogleFonts.itim(
                                      textStyle: TextStyle(color: Colors.amber),
                                    )),
                            title: Text(data.asunto,
                                style: GoogleFonts.itim(
                                  textStyle: TextStyle(color: azulp),
                                )),
                            subtitle: Text(data.descripcion,
                                style: GoogleFonts.itim(
                                  textStyle: TextStyle(color: gris),
                                )),
                          ),
                        ),
                      ))
                  .toList());
        });
  }

  Future actnotificacion(String _id) async {
    var data = {
      'tipo': 'act_notificacion',
      'id': _id,
      'leido': '2',
    };
    print(data);
    final reponse = await http.post(urlnotificaciones,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    print(reponse.body);
  }

  Future borranotificacion(String _id) async {
    var data = {
      'tipo': 'borra_notificacion',
      'id': _id,
    };
    print(data);
    final reponse = await http.post(urlnotificaciones,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    print(reponse.body);
  }
}
