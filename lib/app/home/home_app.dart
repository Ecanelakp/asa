import 'package:asamexico/app/home/lateral_app.dart';
import 'package:asamexico/app/tareas/detalle_tareas.dart';
import 'package:asamexico/app/tareas/home_tareas.dart';
import 'package:asamexico/app/variables/colors.dart';
import 'package:asamexico/app/variables/servicesurl.dart';
import 'package:asamexico/app/variables/variables.dart';

import 'package:asamexico/models/tareas_model.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Home_app extends StatefulWidget {
  @override
  State<Home_app> createState() => _Home_appState();
}

class _Home_appState extends State<Home_app> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido',
            style: GoogleFonts.itim(
              textStyle: TextStyle(color: blanco),
            )),
        backgroundColor: azulp,
      ),
      drawer: menulateral(),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child:
                    Text('Aqui veras las notificaciones más relevantes del día',
                        style: GoogleFonts.itim(
                          textStyle: TextStyle(color: gris),
                        ))),
            Spacer(),
            Flexible(child: Tareas())
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: rojo,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => alta_tareas()));
        },
        child: Icon(
          Icons.add,
          color: blanco,
        ),
      ),
    );
  }
}

class Tareas extends StatefulWidget {
  const Tareas({
    super.key,
  });

  @override
  State<Tareas> createState() => _TareasState();
}

class _TareasState extends State<Tareas> {
  @override
  void initState() {
    super.initState();
    listacoti();
  }

  Future<List<Modellisttareas>> listacoti() async {
    //print('======$notmes======');
    var data = {'tipo': 'tipo_tareas', 'usuario': usuario};
    //print(data);
    final response = await http.post(urltareas,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      //print(response.body);

      List<Modellisttareas> studentList = items.map<Modellisttareas>((json) {
        return Modellisttareas.fromJson(json);
      }).toList();

      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width <= 600
          ? MediaQuery.of(context).size.width * 1
          : 400,
      child: Column(
        children: [
          ListTile(
            title: Align(
              alignment: Alignment.center,
              child: Text('Tareas',
                  style: GoogleFonts.itim(
                    textStyle: TextStyle(color: gris),
                  )),
            ),
            trailing: IconButton(
                onPressed: () {
                  setState(() {
                    listacoti();
                  });
                },
                icon: Icon(
                  Icons.refresh,
                  color: azuls,
                )),
          ),
          Flexible(
            child: FutureBuilder<List<Modellisttareas>>(
                future: listacoti(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Container(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                      ),
                    );

                  return GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 3,
                          mainAxisSpacing: 5),
                      children: snapshot.data!
                          .map((data) => Container(
                                child: GestureDetector(
                                  onTap: (() {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                detalle_tareas(
                                                    data.id,
                                                    data.titulo,
                                                    data.descripcion)));
                                  }),
                                  child: Card(
                                      elevation: 10,
                                      color: data.tipo == 'Creador'
                                          ? blanco
                                          : azuls,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(data.tipo,
                                                style: GoogleFonts.itim(
                                                  textStyle: TextStyle(
                                                      color:
                                                          data.tipo == 'Creador'
                                                              ? gris
                                                              : blanco),
                                                )),
                                            Icon(
                                              Icons.work_history,
                                              color: data.tipo == 'Creador'
                                                  ? azuls
                                                  : blanco,
                                            ),
                                            Text(data.titulo,
                                                style: GoogleFonts.itim(
                                                  textStyle: TextStyle(
                                                      color:
                                                          data.tipo == 'Creador'
                                                              ? gris
                                                              : blanco),
                                                )),

                                            // Text(data.descripcion,
                                            //     style: GoogleFonts.itim(
                                            //       textStyle: TextStyle(color: gris),
                                            //     )),
                                            // Text(data.usuario,
                                            //     style: GoogleFonts.itim(
                                            //       textStyle: TextStyle(color: gris),
                                            //     )),
                                            Text(
                                                DateFormat('dd/MM/yy').format(
                                                    data.fechaVencimiento),
                                                style: GoogleFonts.itim(
                                                  textStyle:
                                                      TextStyle(color: gris),
                                                )),
                                          ],
                                        ),
                                      )),
                                ),
                              ))
                          .toList());
                }),
          ),
        ],
      ),
    );
  }
}
