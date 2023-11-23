import 'package:Asamexico/app/notificaciones/alta_notificaciones.dart';
import 'package:Asamexico/app/variables/colors.dart';
import 'package:Asamexico/app/variables/servicesurl.dart';
import 'package:Asamexico/app/variables/variables.dart';
import 'package:Asamexico/models/tareas_model.dart';

import 'package:flutter/material.dart';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class Tareas {
  String? idresponsable;
  String? responsable;
  String? comentario;

  Tareas(
    this.idresponsable,
    this.responsable,
    this.comentario,
  );
}

TextEditingController _titulo = TextEditingController();
TextEditingController _descripcion = TextEditingController();
final _format = DateFormat("dd-MM-yyyy");
TextEditingController _fecha = new TextEditingController();
List<Modellistusers> _sugesttioncliente = [];
List<Tareas> _tareas = [];
List<TextEditingController> _comentarios = [];
String _emailusuario = '';
String _usuario = '';

class alta_tareas extends StatefulWidget {
  const alta_tareas({super.key});

  @override
  State<alta_tareas> createState() => _alta_tareasState();
}

class _alta_tareasState extends State<alta_tareas> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listaclientes();
    _titulo.clear();
    _descripcion.clear();
    _comentarios.clear();
    _fecha.clear();
    _tareas.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alta tareas',
            style: GoogleFonts.itim(textStyle: TextStyle(color: blanco))),
        backgroundColor: azulp,
      ),
      body: Column(children: [
        Row(children: [
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _titulo,
                onChanged: (value) {},
                style: GoogleFonts.itim(textStyle: TextStyle(color: azulp)),
                decoration: InputDecoration(
                  labelText: 'Titulo',
                  filled: true,
                  fillColor: blanco,
                  labelStyle: GoogleFonts.sulphurPoint(
                      textStyle: TextStyle(color: gris)),
                ),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: new DateTimeField(
                controller: _fecha,
                format: _format,
                style: GoogleFonts.itim(textStyle: TextStyle(color: azulp)),
                onShowPicker: (context, currentValue) {
                  return showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100));
                },
                onChanged: (string) {
                  setState(() {});
                },
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  hintText: 'Fecha vencimiento',
                  filled: true,
                  fillColor: blanco,
                  hintStyle: TextStyle(color: gris),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
            ),
          ),
        ]),
        Flexible(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _descripcion,
              maxLines: 3,
              onChanged: (value) {},
              style: GoogleFonts.itim(textStyle: TextStyle(color: azulp)),
              decoration: InputDecoration(
                labelText: 'Descripcion',
                filled: true,
                fillColor: blanco,
                labelStyle:
                    GoogleFonts.sulphurPoint(textStyle: TextStyle(color: gris)),
              ),
            ),
          ),
        ),
        Row(
          children: [
            Flexible(
              child: Container(
                child: ListTile(
                  subtitle: Text('Selecciona responsables',
                      style: GoogleFonts.sulphurPoint(
                        textStyle: TextStyle(color: azulp),
                      )),
                  title: Autocomplete<Modellistusers>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      return _sugesttioncliente
                          .where((Modellistusers county) => county.nombre
                              .toLowerCase()
                              .startsWith(textEditingValue.text.toLowerCase()))
                          .toList();
                    },
                    displayStringForOption: (Modellistusers option) =>
                        option.nombre,
                    fieldViewBuilder: (BuildContext context,
                        TextEditingController fieldTextEditingController,
                        FocusNode fieldFocusNode,
                        VoidCallback onFieldSubmitted) {
                      return TextField(
                          controller: fieldTextEditingController,
                          focusNode: fieldFocusNode,
                          style: GoogleFonts.sulphurPoint(
                            textStyle: TextStyle(color: azulp),
                          ),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintStyle: TextStyle(color: azuls)));
                    },
                    onSelected: (Modellistusers selection) {
                      setState(() {
                        print(selection.nombre);
                        _emailusuario = selection.email;
                        _usuario = selection.nombre;
                        // _idcliente = selection.id;
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: rojo,
                child: IconButton(
                    onPressed: () {
                      _tareas.add(Tareas(
                          _emailusuario, _usuario, 'Agrega un comentario'));
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.add,
                      color: blanco,
                    )),
              ),
            )
          ],
        ),
        Flexible(
            flex: 4,
            child: Container(
                child: ListView.builder(
                    itemCount: _tareas.length,
                    itemBuilder: (BuildContext context, int index) {
                      _comentarios.add(new TextEditingController());

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 10,
                          child: ListTile(
                            trailing: IconButton(
                                onPressed: () {},
                                icon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _tareas.removeAt(index);
                                      });
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: rojo,
                                    ))),
                            title: Column(
                              children: [
                                Text(_tareas[index].responsable.toString()),
                                TextField(
                                    controller: _comentarios[index],
                                    onChanged: (value) {
                                      setState(() {
                                        _tareas[index] = Tareas(
                                            _tareas[index].idresponsable,
                                            _tareas[index].responsable,
                                            _comentarios[index].text);
                                      });
                                    },
                                    maxLines: 2,
                                    decoration: InputDecoration(
                                        hintText: 'Comentarios para  ' +
                                            _tareas[index]
                                                .responsable
                                                .toString(),
                                        labelText: 'Comentarios',
                                        border: OutlineInputBorder(),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        hintStyle:
                                            TextStyle(color: Colors.grey))),
                              ],
                            ),
                          ),
                        ),
                      );
                    }))),
        Card(
          elevation: 10,
          color: azulp,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  setState(() {
                    altacabecera();
                    // usuarios_tarea('1');
                  });
                },
                icon: Icon(
                  Icons.save,
                  color: blanco,
                )),
          ),
        )
      ]),
    );
  }

  Future<List<Modellistusers>> listaclientes() async {
    //print('======$notmes======');
    var data = {
      'tipo': 'lista_usuarios',
    };
    // print(data);
    final response = await http.post(urltareas,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      //print(response.body);

      List<Modellistusers> studentList = items.map<Modellistusers>((json) {
        return Modellistusers.fromJson(json);
      }).toList();
      setState(() {});
      _sugesttioncliente = items.map<Modellistusers>((json) {
        return Modellistusers.fromJson(json);
      }).toList();
      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  Future altacabecera() async {
    var data = {
      'tipo': 'alta_tarea',
      'descripcion': _descripcion.text,
      'titulo': _titulo.text,
      'fecha_ven': _fecha.text,
      'usuario': usuario
    };
    print(data);
    final reponse = await http.post(urltareas,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    print(reponse.body);
    usuarios_tarea(reponse.body);
  }

  Future usuarios_tarea(String _id) async {
    _tareas.forEach((elemento) async {
      var data = {
        'tipo': 'usuarios_tarea',
        'id_tarea': _id,
        'fecha_ven': _fecha.text,
        'usuario': elemento.idresponsable
      };
      print(data);

      final reponse = await http.post(urltareas,
          headers: {
            "Accept": "application/json",
          },
          body: json.encode(data));
      print('quiiii');
      print(reponse.body);
      comentarios_tarea(
          await reponse.body, elemento.idresponsable, elemento.comentario);
      altanotificaciones(
          elemento.idresponsable, _titulo.text, _descripcion.text);
    });
    final snackBar = SnackBar(
      content: Text(
        'Se ha creado correctamente.........',
        style: GoogleFonts.sulphurPoint(textStyle: TextStyle(color: blanco)),
      ),
      backgroundColor: (azulp),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pop(context);
  }

  Future comentarios_tarea(
      String _idseg, String? _idresponsable, String? _comentario) async {
    var data = {
      'tipo': 'comentarios_tarea',
      'id_seguimiento': _idseg,
      'usuario': usuario,
      'comentario': _comentario
    };
    final reponse = await http.post(urltareas,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));
    print(reponse.body);
    print(data);
  }
}
