import 'package:Asamexico/app/notificaciones/alta_notificaciones.dart';
import 'package:Asamexico/app/variables/colors.dart';
import 'package:Asamexico/app/variables/servicesurl.dart';
import 'package:Asamexico/app/variables/variables.dart';
import 'package:Asamexico/models/tareas_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

List<TextEditingController> _comentarios = [];
List<Modellisttareasusaasig> _lista_usr_tarea = [];

class detalle_tareas extends StatefulWidget {
  final String _id;
  final String _titulo;
  final String _descripcion;
  final DateTime _fechaVencimiento;
  final String _usuario;
  detalle_tareas(this._id, this._titulo, this._descripcion,
      this._fechaVencimiento, this._usuario);

  @override
  State<detalle_tareas> createState() => _detalle_tareasState();
}

class _detalle_tareasState extends State<detalle_tareas> {
  @override
  void initState() {
    super.initState();
    listacoti();
    // _lista_usr_tarea.clear();
  }

  Future<List<Modellisttareasusaasig>> listacoti() async {
    //print('======$notmes======');
    var data = {'tipo': 'lista_usr_tarea', 'id_tarea': widget._id};
    // print(data);
    final response = await http.post(urltareas,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
//      print(response.body);

      List<Modellisttareasusaasig> studentList =
          items.map<Modellisttareasusaasig>((json) {
        return Modellisttareasusaasig.fromJson(json);
      }).toList();
      _lista_usr_tarea = items.map<Modellisttareasusaasig>((json) {
        return Modellisttareasusaasig.fromJson(json);
      }).toList();
      setState(() {});
      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle tarea',
            style: GoogleFonts.itim(
                textStyle: TextStyle(
              color: blanco,
            ))),
        backgroundColor: azulp,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(widget._titulo,
                      style: GoogleFonts.itim(
                          textStyle: TextStyle(
                        color: azuls,
                      ))),
                  subtitle: Text(widget._descripcion,
                      style: GoogleFonts.itim(textStyle: TextStyle())),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text('Usuarios asignados',
                  style: GoogleFonts.itim(
                      textStyle: TextStyle(
                    color: gris,
                  ))),
            ),
            Flexible(
              child: Container(
                child: ListView.builder(
                    itemCount: _lista_usr_tarea.length,
                    itemBuilder: (BuildContext context, int index) {
                      _comentarios.add(new TextEditingController());

                      return Card(
                        color: azulp,
                        elevation: 10,
                        child: ExpansionTile(
                          iconColor: azuls,
                          title: Text(_lista_usr_tarea[index].usuario,
                              style: GoogleFonts.itim(
                                  textStyle: TextStyle(
                                color: blanco,
                              ))),
                          children: [
                            Container(
                              child: Text('Comentarios',
                                  style: GoogleFonts.itim(
                                      textStyle: TextStyle(
                                    color: azuls,
                                  ))),
                            ),
                            Container(
                              width: double.infinity,
                              height: 400,
                              child: FutureBuilder<
                                      List<Modellisttareacomentarios>>(
                                  future:
                                      comentarios(_lista_usr_tarea[index].id),
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
                                                  child: ListTile(
                                                    leading: Text(
                                                        DateFormat('dd/MM')
                                                            .format(data.fecha),
                                                        style: GoogleFonts.itim(
                                                            textStyle:
                                                                TextStyle())),
                                                    title: Text(data.comentario,
                                                        style: GoogleFonts.itim(
                                                            textStyle:
                                                                TextStyle(
                                                          color: azulp,
                                                        ))),
                                                    subtitle: Text(data.usuario,
                                                        style: GoogleFonts.itim(
                                                            textStyle:
                                                                TextStyle())),
                                                  ),
                                                ))
                                            .toList());
                                  }),
                            ),
                            Card(
                              elevation: 10,
                              child: TextField(
                                  controller: _comentarios[index],
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                      hintText: 'Agrega comentarios ',
                                      //labelText: 'Comentarios',
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            comentarios_tarea(
                                                _lista_usr_tarea[index].id,
                                                _comentarios[index].text);
                                            altanotificaciones(
                                                usuario ==
                                                        _lista_usr_tarea[index]
                                                            .id
                                                    ? widget._usuario
                                                    : _lista_usr_tarea[index]
                                                        .id,
                                                widget._titulo,
                                                usuario +
                                                    ' ha agregado el comentario:' +
                                                    _comentarios[index].text);
                                          },
                                          icon: Icon(
                                            Icons.add,
                                            color: rojo,
                                          )),
                                      border: OutlineInputBorder(),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintStyle:
                                          TextStyle(color: Colors.grey))),
                            )
                          ],
                        ),
                      );
                    }),
              ),
            ),
            Card(
              elevation: 10,
              child: Row(
                children: [
                  Flexible(
                    child: ListTile(
                      subtitle: Text('Vencimiento',
                          style: GoogleFonts.itim(
                              textStyle: TextStyle(
                            color: azuls,
                          ))),
                      title: Text(
                          DateFormat('dd/MM/yyyy')
                              .format(widget._fechaVencimiento),
                          style: GoogleFonts.itim(
                              textStyle: TextStyle(
                            color: azuls,
                          ))),
                      trailing: widget._usuario == usuario
                          ? Text('Cerrar tarea',
                              style: GoogleFonts.itim(
                                  textStyle: TextStyle(
                                color: rojo,
                              )))
                          : Text(''),
                    ),
                  ),
                  widget._usuario == usuario
                      ? Card(
                          color: Colors.green,
                          child: Icon(
                            Icons.check,
                            color: blanco,
                          ))
                      : Container()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Modellisttareacomentarios>> comentarios(String _id) async {
    //print('======$notmes======');
    var data = {'tipo': 'lista_coment_tares', 'id_seguimiento': _id};
    // print(data);
    final response = await http.post(urltareas,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      // print(response.body);

      List<Modellisttareacomentarios> studentList =
          items.map<Modellisttareacomentarios>((json) {
        return Modellisttareacomentarios.fromJson(json);
      }).toList();
      //setState(() {});
      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  Future comentarios_tarea(String _idseg, String? _comentario) async {
    var data = {
      'tipo': 'comentarios_tarea',
      'id_seguimiento': _idseg,
      'usuario': usuario,
      'comentario': _comentario
    };
    print(data);
    final reponse = await http.post(urltareas,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));
    print(reponse.body);

    _comentarios.clear();
    setState(() {});
  }
}
