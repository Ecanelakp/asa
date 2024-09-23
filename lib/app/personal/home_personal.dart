import 'package:Asamexico/app/configuracion/usuarios/detalle_usuarios.configuracion.dart';
import 'package:Asamexico/app/variables/colors.dart';
import 'package:Asamexico/app/variables/servicesurl.dart';
import 'package:Asamexico/models/usuarios_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class home_personal extends StatefulWidget {
  const home_personal({super.key});

  @override
  State<home_personal> createState() => _home_personalState();
}

class _home_personalState extends State<home_personal> {
  Future<List<usuariosmodel>> listausuarios() async {
    //print('======$notmes======');
    var data = {
      'tipo': 'lista',
    };
    //print(data);
    final response = await http.post(urluser,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      //7print(response.body);

      List<usuariosmodel> studentList = items.map<usuariosmodel>((json) {
        return usuariosmodel.fromJson(json);
      }).toList();
      //setState(() {});
      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  Future<List<modelchecadorlista>> listachecador() async {
    //print('======$notmes======');
    var data = {
      'tipo': 'lista',
    };
    //print(data);
    final response = await http.post(urlchecador,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      print(response.body);

      List<modelchecadorlista> checadorList =
          items.map<modelchecadorlista>((json) {
        return modelchecadorlista.fromJson(json);
      }).toList();
      //setState(() {});
      return checadorList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listausuarios();
    listachecador();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal',
            style: GoogleFonts.sulphurPoint(
              textStyle: TextStyle(color: blanco),
            )),
        backgroundColor: azulp,
      ),
      body: Container(
          child: Container(
              child: Row(
        children: [
          Flexible(
            flex: 1,
            child: FutureBuilder<List<usuariosmodel>>(
                future: listausuarios(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Container(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                      ),
                    );

                  return ListView(
                      children: snapshot.data!
                          .map((data) => Container(
                                  child: Card(
                                elevation: 10,
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: ListTile(
                                        title: Text(
                                          data.nombre.toString(),
                                          style: GoogleFonts.sulphurPoint(
                                            textStyle: TextStyle(color: gris),
                                          ),
                                        ),
                                        onTap: (() {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      detalleusuarios_configuracion(
                                                          data.id,
                                                          data.email,
                                                          data.nombre,
                                                          data.perfil,
                                                          data.status)));
                                        }),
                                        subtitle: Text(data.perfil.toString(),
                                            style: GoogleFonts.sulphurPoint(
                                              textStyle:
                                                  TextStyle(color: azulp),
                                            )),
                                        leading: CircleAvatar(
                                          backgroundImage: AssetImage(
                                            "assets/images/profile.png",
                                          ),
                                        ),
                                      ),
                                    ),
                                    Card(
                                      color: azuls,
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: IconButton(
                                            onPressed: () {
                                              altareloj(data.id, data.nombre,
                                                  'personal');
                                            },
                                            icon: Icon(
                                              Icons.punch_clock,
                                              color: blanco,
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              )))
                          .toList());
                }),
          ),
          Flexible(
            child: Container(
              color: azuls,
              child: FutureBuilder<List<modelchecadorlista>>(
                  future: listachecador(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                        ),
                      );

                    return ListView(
                        children: snapshot.data!
                            .map((data) => Container(
                                    child: Card(
                                  elevation: 10,
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: ListTile(
                                          title: Text(
                                            data.nombre.toString(),
                                            style: GoogleFonts.sulphurPoint(
                                              textStyle: TextStyle(color: gris),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: ListTile(
                                            title: Text(
                                              DateFormat('dd/MM HH:mm')
                                                  .format(data.entrada!),
                                              style: GoogleFonts.sulphurPoint(
                                                textStyle:
                                                    TextStyle(color: azulp),
                                              ),
                                            ),
                                            subtitle: Text('entrada',
                                                style: GoogleFonts.sulphurPoint(
                                                  textStyle:
                                                      TextStyle(color: gris),
                                                ))),
                                      ),
                                      Flexible(
                                        child: ListTile(
                                            title: data.salida.toString() ==
                                                    '-0001-11-30 00:00:00.000'
                                                ? Container()
                                                : Text(
                                                    DateFormat('dd/MM HH:mm')
                                                        .format(data.salida!),
                                                    style: GoogleFonts
                                                        .sulphurPoint(
                                                      textStyle: TextStyle(
                                                          color: rojo),
                                                    ),
                                                  ),
                                            subtitle: Text('Salida',
                                                style: GoogleFonts.sulphurPoint(
                                                  textStyle:
                                                      TextStyle(color: gris),
                                                ))),
                                      ),
                                      data.salida!.toString() ==
                                              '-0001-11-30 00:00:00.000'
                                          ? Card(
                                              child: IconButton(
                                                  onPressed: () {
                                                    salida(data.id);
                                                  },
                                                  icon: Icon(Icons.input,
                                                      color: rojo)),
                                            )
                                          : Container()
                                    ],
                                  ),
                                )))
                            .toList());
                  }),
            ),
          ),
        ],
      ))),
    );
  }

  Future altareloj(String? _id, String? _nombre, String _personal) async {
    var data = {
      'tipo': 'alta',
      'nombre': _nombre,
      'idusuario': _id,
      'latitud': '19.3624571',
      'longitud': '-99.1400664',
      'referencia': _personal,
    };
    print(data);
    final reponse = await http.post(urlchecador,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    print(reponse.body);

    final snackBar = SnackBar(
      content: Text(
        'Se ha creado correctamente.........',
        style: GoogleFonts.sulphurPoint(textStyle: TextStyle(color: blanco)),
      ),
      backgroundColor: (azulp),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    setState(() {
      listachecador();
    });
  }

  Future salida(String? _id) async {
    var data = {'tipo': 'salida', 'id': _id};
    print(data);
    final reponse = await http.post(urlchecador,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    print(reponse.body);

    final snackBar = SnackBar(
      content: Text(
        'Se ha creado correctamente.........',
        style: GoogleFonts.sulphurPoint(textStyle: TextStyle(color: blanco)),
      ),
      backgroundColor: (azulp),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    setState(() {
      listachecador();
    });
  }
}
