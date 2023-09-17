import 'package:asamexico/app/clientes/detalles_clientes.dart';
import 'package:asamexico/app/variables/colors.dart';
import 'package:asamexico/app/variables/servicesurl.dart';
import 'package:asamexico/models/clientes_model.dart';
import 'package:asamexico/models/proyectos_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class lista_clientes extends StatefulWidget {
  @override
  State<lista_clientes> createState() => _lista_clientesState();
}

class _lista_clientesState extends State<lista_clientes> {
  @override
  void initState() {
    super.initState();
    listaclientes();
  }

  Future<List<Modellistaclientes>> listaclientes() async {
    //print('======$notmes======');
    var data = {
      'tipo': 'lista_clientes',
    };
    // print(data);
    final response = await http.post(urlclientes,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      // print(response.body);

      List<Modellistaclientes> studentList =
          items.map<Modellistaclientes>((json) {
        return Modellistaclientes.fromJson(json);
      }).toList();
      setState(() {});
      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder<List<Modellistaclientes>>(
            future: listaclientes(),
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
                            elevation: 10,
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => detalles_clientes(
                                            data.razonSocial,
                                            data.rfc,
                                            data.domicilio,
                                            data.cp,
                                            data.usoCfdi,
                                            data.regimen,
                                            data.telefono,
                                            data.email,
                                            data.nombreContacto)));
                              },
                              title: Text(data.razonSocial,
                                  style: GoogleFonts.itim(
                                      textStyle: TextStyle(color: azulp))),
                              subtitle: Text(data.rfc,
                                  style: GoogleFonts.itim(
                                      textStyle: TextStyle(color: gris))),
                              trailing:
                                  Icon(Icons.arrow_forward_ios, color: rojo),
                            ),
                          ))
                      .toList());
            }));
  }
}
