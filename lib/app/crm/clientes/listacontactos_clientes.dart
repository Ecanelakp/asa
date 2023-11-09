import 'package:asamexico/app/crm/clientes/contactodetalles_clientes.dart';
import 'package:asamexico/app/crm/clientes/interaccion_clientes.dart';
import 'package:asamexico/app/variables/colors.dart';
import 'package:asamexico/app/variables/servicesurl.dart';
import 'package:asamexico/models/clientes_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class listacontactos_clientes extends StatefulWidget {
  final String _id;
  listacontactos_clientes(this._id);

  @override
  State<listacontactos_clientes> createState() =>
      _listacontactos_clientesState();
}

class _listacontactos_clientesState extends State<listacontactos_clientes> {
  @override
  void initState() {
    super.initState();
    listaclientes();
  }

  Future<List<Modellistcontactos>> listaclientes() async {
    //print('======$notmes======');
    var data = {'tipo': 'lista_contactos', 'id_cliente': widget._id};
    // print(data);
    final response = await http.post(urlcontactos,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      //print(response.body);

      List<Modellistcontactos> studentList =
          items.map<Modellistcontactos>((json) {
        return Modellistcontactos.fromJson(json);
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
        child: FutureBuilder<List<Modellistcontactos>>(
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
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                contactodetalles_clientes(
                                                    data.id,
                                                    data.idCliente,
                                                    data.correo,
                                                    data.nombre,
                                                    data.puesto,
                                                    data.telefono,
                                                    data.ubicacion)));
                                  },
                                  title: Text(data.nombre,
                                      style: GoogleFonts.itim(
                                          textStyle: TextStyle(color: azulp))),
                                  subtitle: Text(data.ubicacion,
                                      style: GoogleFonts.itim(
                                          textStyle: TextStyle(color: gris))),
                                  leading: IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Borrar contacto',
                                                  style: GoogleFonts.itim(
                                                      textStyle: TextStyle(
                                                          color: azulp))),
                                              content: Text(
                                                  'Se borrara el contacto ' +
                                                      data.nombre +
                                                      ' con el puesto ' +
                                                      data.puesto +
                                                      ' ¿Estas seguro de querer borrarlo?',
                                                  style: GoogleFonts.itim(
                                                      textStyle: TextStyle(
                                                          color: gris))),
                                              actions: <Widget>[
                                                Card(
                                                  elevation: 10,
                                                  color: azuls,
                                                  child: TextButton(
                                                    child: Text('Cerrar',
                                                        style: GoogleFonts.itim(
                                                            textStyle: TextStyle(
                                                                color:
                                                                    blanco))),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ),
                                                Card(
                                                  elevation: 10,
                                                  color: rojo,
                                                  child: TextButton(
                                                    child: Text('Borrar',
                                                        style: GoogleFonts.itim(
                                                            textStyle: TextStyle(
                                                                color:
                                                                    blanco))),
                                                    onPressed: () {
                                                      borrar(data.id);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: rojo,
                                      )),
                                )),
                                Card(
                                    elevation: 10,
                                    color: azulp,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: IconButton(
                                          onPressed: () async {
                                            final url = "mailto:" + data.correo;
                                            if (await canLaunch(url)) {
                                              await launch(url);
                                            } else {
                                              throw 'No se pudo lanzar la llamada: $url';
                                            }
                                          },
                                          icon:
                                              Icon(Icons.mail, color: blanco)),
                                    )),
                                Card(
                                    elevation: 10,
                                    color: gris,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: IconButton(
                                          onPressed: () async {
                                            final url = "tel:" + data.telefono;
                                            if (await canLaunch(url)) {
                                              await launch(url);
                                            } else {
                                              throw 'No se pudo lanzar la llamada: $url';
                                            }
                                          },
                                          icon:
                                              Icon(Icons.phone, color: blanco)),
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
                                                        interacciones_clientes(
                                                            widget._id,
                                                            data.id)));
                                          },
                                          icon: Icon(Icons.comment,
                                              color: blanco)),
                                    )),
                              ],
                            ),
                          ))
                      .toList());
            }));
  }

  Future borrar(String _id) async {
    var data = {
      'tipo': 'borra_contacto',
      'id': _id,
    };
    print(data);

    var res = await http.post(urlcontactos,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    // print(res.body);

    final snackBar = SnackBar(
      content: const Text('Se borró correctamente'),
      backgroundColor: (azulp),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    setState(() {
      listaclientes();
    });
  }
}
