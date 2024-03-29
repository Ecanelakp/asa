import 'package:Asamexico/app/crm/cotizaciones/homecotizacion_clientes.dart';
import 'package:Asamexico/app/crm/clientes/detalles_clientes.dart';
import 'package:Asamexico/app/variables/colors.dart';
import 'package:Asamexico/app/variables/servicesurl.dart';
import 'package:Asamexico/models/clientes_model.dart';

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
                            child: Row(
                              children: [
                                Flexible(
                                  child: ListTile(
                                    onTap: () {},
                                    title: Text(data.razonSocial,
                                        style: GoogleFonts.itim(
                                            textStyle:
                                                TextStyle(color: azulp))),
                                    subtitle: Text(data.rfc,
                                        style: GoogleFonts.itim(
                                            textStyle: TextStyle(color: gris))),
                                  ),
                                ),
                                Card(
                                    elevation: 10,
                                    color: azulp,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.attach_money,
                                              color: blanco)),
                                    )),
                                Card(
                                    elevation: 10,
                                    color: azuls,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        homecotizacion_clientes()));
                                          },
                                          icon: Icon(Icons.request_quote,
                                              color: blanco)),
                                    )),
                                Card(
                                    elevation: 10,
                                    color: rojo,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        detalles_clientes(
                                                            data.razonSocial,
                                                            data.rfc,
                                                            data.domicilio,
                                                            data.cp,
                                                            data.usoCfdi,
                                                            data.regimen,
                                                            data.telefono,
                                                            data.email,
                                                            data.nombreContacto,
                                                            data.id)));
                                          },
                                          icon: Icon(Icons.arrow_forward_ios,
                                              color: blanco)),
                                    )),
                              ],
                            ),
                          ))
                      .toList());
            }));
  }
}
