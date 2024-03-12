<<<<<<< HEAD
import 'package:Asamexico/app/variables/colors.dart';
import 'package:Asamexico/app/variables/servicesurl.dart';
import 'package:Asamexico/app/variables/variables.dart';
import 'package:Asamexico/models/clientes_model.dart';
import 'package:Asamexico/models/proyectos_model.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

TextEditingController _titulo = TextEditingController();
TextEditingController _descripcion = TextEditingController();
final _format = DateFormat("dd-MM-yyyy");
TextEditingController _fecha = new TextEditingController();

class blog_proyectos extends StatefulWidget {
  final String _id;
  const blog_proyectos(
    this._id,
  );

  @override
  State<blog_proyectos> createState() => _blog_proyectosState();
}

class _blog_proyectosState extends State<blog_proyectos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: azulp,
          title: Text('Blog',
              style: GoogleFonts.sulphurPoint(
                textStyle: TextStyle(color: blanco),
              ))),
      backgroundColor: blanco,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: FractionalOffset(0.0, 0.3),
              end: FractionalOffset(0.0, 0.8),
              colors: [
                blanco,
                blanco,
              ]),
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
              BlendMode.modulate,
            ),
            image: AssetImage('assets/images/asablanco.jpg'),
            fit: BoxFit.contain,
          ),
        ),
        child: Column(
          children: [
            Flexible(
              child: Container(
                  child: FutureBuilder<List<Modelblogproyectos>>(
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
                                    child: Container(
                                      child: ListTile(
                                        leading: Text(
                                            DateFormat('dd/MM')
                                                .format(data.fechaAvance)
                                                .toString(),
                                            style: GoogleFonts.itim(
                                                textStyle:
                                                    TextStyle(color: gris))),
                                        subtitle: Text(
                                            data.observacion +
                                                ' creada por: ' +
                                                data.usuario,
                                            style: GoogleFonts.itim(
                                                textStyle:
                                                    TextStyle(color: gris))),
                                        title: Text(data.titulo,
                                            style: GoogleFonts.itim(
                                                textStyle:
                                                    TextStyle(color: azulp))),
                                      ),
                                    )))
                                .toList());
                      })),
            ),
            ExpansionTile(
              collapsedBackgroundColor: azulp,
              collapsedIconColor: blanco,
              iconColor: rojo,
              backgroundColor: azulp,
              title: Text('Nuevo Comentario',
                  style: GoogleFonts.itim(textStyle: TextStyle(color: blanco))),
              children: [
                Container(
                  width: double.infinity,
                  color: azulp,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _titulo,
                            onChanged: (value) {},
                            style: GoogleFonts.itim(
                                textStyle: TextStyle(color: azulp)),
                            decoration: InputDecoration(
                              labelText: 'Titulo',
                              filled: true,
                              fillColor: blanco,
                              labelStyle: GoogleFonts.sulphurPoint(
                                  textStyle: TextStyle(color: azuls)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _descripcion,
                            style: GoogleFonts.itim(
                                textStyle: TextStyle(color: azulp)),
                            maxLines: 3,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              labelText: 'Comentarios',
                              filled: true,
                              fillColor: blanco,
                              labelStyle: GoogleFonts.sulphurPoint(
                                  textStyle: TextStyle(color: azuls)),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new DateTimeField(
                                  controller: _fecha,
                                  format: _format,
                                  style: GoogleFonts.itim(
                                      textStyle: TextStyle(color: azulp)),
                                  onShowPicker: (context, currentValue) {
                                    return showDatePicker(
                                        context: context,
                                        firstDate: DateTime(1900),
                                        initialDate:
                                            currentValue ?? DateTime.now(),
                                        lastDate: DateTime(2100));
                                  },
                                  onChanged: (string) {
                                    setState(() {});
                                  },
                                  keyboardType: TextInputType.datetime,
                                  decoration: InputDecoration(
                                    hintText: 'Fecha',
                                    filled: true,
                                    fillColor: blanco,
                                    hintStyle: TextStyle(color: azuls),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: rojo),
                                      onPressed: () {
                                        guardar();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Publicar',
                                          style: GoogleFonts.itim(
                                              textStyle:
                                                  TextStyle(color: blanco)),
                                        ),
                                      ))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future guardar() async {
    var data = {
      'tipo': 'alta_seguimiento',
      'id_proyecto': widget._id,
      'usuario': usuario,
      'titulo': _titulo.text,
      'observaciones': _descripcion.text,
      'fecha_seg': _fecha.text
    };
    print(data);

    var res = await http.post(urlproyectos,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    print(res.body);

    final snackBar = SnackBar(
      content: const Text('Se registro correctamente'),
      backgroundColor: (azulp),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    setState(() {
      _titulo.clear();
      _descripcion.clear();
      _fecha.clear();
      listaclientes();
    });
  }

  Future<List<Modelblogproyectos>> listaclientes() async {
    //print('======$notmes======');
    var data = {'tipo': 'lista_seguimiento', 'id_proyecto': widget._id};
    //print(data);
    final response = await http.post(urlproyectos,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      //print(response.body);

      List<Modelblogproyectos> studentList =
          items.map<Modelblogproyectos>((json) {
        return Modelblogproyectos.fromJson(json);
      }).toList();
      setState(() {});
      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }
}
=======
import 'package:Asamexico/app/variables/colors.dart';
import 'package:Asamexico/app/variables/servicesurl.dart';
import 'package:Asamexico/app/variables/variables.dart';
import 'package:Asamexico/models/clientes_model.dart';
import 'package:Asamexico/models/proyectos_model.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

TextEditingController _titulo = TextEditingController();
TextEditingController _descripcion = TextEditingController();
final _format = DateFormat("dd-MM-yyyy");
TextEditingController _fecha = new TextEditingController();

class blog_proyectos extends StatefulWidget {
  final String _id;
  const blog_proyectos(
    this._id,
  );

  @override
  State<blog_proyectos> createState() => _blog_proyectosState();
}

class _blog_proyectosState extends State<blog_proyectos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: azulp,
          title: Text('Blog',
              style: GoogleFonts.sulphurPoint(
                textStyle: TextStyle(color: blanco),
              ))),
      backgroundColor: blanco,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: FractionalOffset(0.0, 0.3),
              end: FractionalOffset(0.0, 0.8),
              colors: [
                blanco,
                blanco,
              ]),
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
              BlendMode.modulate,
            ),
            image: AssetImage('assets/images/asablanco.jpg'),
            fit: BoxFit.contain,
          ),
        ),
        child: Column(
          children: [
            Flexible(
              child: Container(
                  child: FutureBuilder<List<Modelblogproyectos>>(
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
                                    child: Container(
                                      child: ListTile(
                                        leading: Text(
                                            DateFormat('dd/MM')
                                                .format(data.fechaAvance)
                                                .toString(),
                                            style: GoogleFonts.itim(
                                                textStyle:
                                                    TextStyle(color: gris))),
                                        subtitle: Text(
                                            data.observacion +
                                                ' creada por: ' +
                                                data.usuario,
                                            style: GoogleFonts.itim(
                                                textStyle:
                                                    TextStyle(color: gris))),
                                        title: Text(data.titulo,
                                            style: GoogleFonts.itim(
                                                textStyle:
                                                    TextStyle(color: azulp))),
                                      ),
                                    )))
                                .toList());
                      })),
            ),
            ExpansionTile(
              collapsedBackgroundColor: azulp,
              collapsedIconColor: blanco,
              iconColor: rojo,
              backgroundColor: azulp,
              title: Text('Nuevo Comentario',
                  style: GoogleFonts.itim(textStyle: TextStyle(color: blanco))),
              children: [
                Container(
                  width: double.infinity,
                  color: azulp,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _titulo,
                            onChanged: (value) {},
                            style: GoogleFonts.itim(
                                textStyle: TextStyle(color: azulp)),
                            decoration: InputDecoration(
                              labelText: 'Titulo',
                              filled: true,
                              fillColor: blanco,
                              labelStyle: GoogleFonts.sulphurPoint(
                                  textStyle: TextStyle(color: azuls)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _descripcion,
                            style: GoogleFonts.itim(
                                textStyle: TextStyle(color: azulp)),
                            maxLines: 3,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              labelText: 'Comentarios',
                              filled: true,
                              fillColor: blanco,
                              labelStyle: GoogleFonts.sulphurPoint(
                                  textStyle: TextStyle(color: azuls)),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new DateTimeField(
                                  controller: _fecha,
                                  format: _format,
                                  style: GoogleFonts.itim(
                                      textStyle: TextStyle(color: azulp)),
                                  onShowPicker: (context, currentValue) {
                                    return showDatePicker(
                                        context: context,
                                        firstDate: DateTime(1900),
                                        initialDate:
                                            currentValue ?? DateTime.now(),
                                        lastDate: DateTime(2100));
                                  },
                                  onChanged: (string) {
                                    setState(() {});
                                  },
                                  keyboardType: TextInputType.datetime,
                                  decoration: InputDecoration(
                                    hintText: 'Fecha',
                                    filled: true,
                                    fillColor: blanco,
                                    hintStyle: TextStyle(color: azuls),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: rojo),
                                      onPressed: () {
                                        guardar();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Publicar',
                                          style: GoogleFonts.itim(
                                              textStyle:
                                                  TextStyle(color: blanco)),
                                        ),
                                      ))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future guardar() async {
    var data = {
      'tipo': 'alta_seguimiento',
      'id_proyecto': widget._id,
      'usuario': usuario,
      'titulo': _titulo.text,
      'observaciones': _descripcion.text,
      'fecha_seg': _fecha.text
    };
    print(data);

    var res = await http.post(urlproyectos,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    print(res.body);

    final snackBar = SnackBar(
      content: const Text('Se registro correctamente'),
      backgroundColor: (azulp),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    setState(() {
      _titulo.clear();
      _descripcion.clear();
      _fecha.clear();
      listaclientes();
    });
  }

  Future<List<Modelblogproyectos>> listaclientes() async {
    //print('======$notmes======');
    var data = {'tipo': 'lista_seguimiento', 'id_proyecto': widget._id};
    //print(data);
    final response = await http.post(urlproyectos,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      //print(response.body);

      List<Modelblogproyectos> studentList =
          items.map<Modelblogproyectos>((json) {
        return Modelblogproyectos.fromJson(json);
      }).toList();
      setState(() {});
      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }
}
>>>>>>> 7a0a6b2 (mac)
