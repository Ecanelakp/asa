import 'package:Asamexico/app/home/lateral_app.dart';
import 'package:Asamexico/app/notificaciones/lista_notificaciones.dart';
import 'package:Asamexico/app/tareas/calendar.dart';
import 'package:Asamexico/app/tareas/detalle_tareas.dart';
import 'package:Asamexico/app/tareas/home_tareas.dart';
import 'package:Asamexico/app/variables/colors.dart';
import 'package:Asamexico/app/variables/servicesurl.dart';
import 'package:Asamexico/app/variables/variables.dart';

import 'package:Asamexico/models/tareas_model.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:badges/badges.dart' as badges;

DateTime _hoy = DateTime.now();

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
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => calendar()));
              },
              icon: Icon(Icons.calendar_month))
        ],
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Notificaciones',
                style: GoogleFonts.itim(
                  textStyle: TextStyle(color: gris),
                )),
            Flexible(flex: 1, child: lista_notifaciones()),
            Flexible(flex: 2, child: Tareas())
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

                    return ListView(
                        children: snapshot.data!
                            .map((data) => Card(
                                  child: ListTile(
                                    onTap: (() {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  detalle_tareas(
                                                      data.id,
                                                      data.titulo,
                                                      data.descripcion,
                                                      data.fechaVencimiento,
                                                      data.usuario)));
                                    }),
                                    trailing: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            borrantareas(data.id);
                                          });
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: rojo,
                                        )),
                                    leading: Text(DateFormat('dd/MM/yy')
                                        .format(data.fechaVencimiento)),
                                    title: Text(data.titulo + '' + data.id,
                                        style: GoogleFonts.itim(
                                          textStyle: TextStyle(color: azulp),
                                        )),
                                    subtitle: Text(data.descripcion,
                                        style: GoogleFonts.itim(
                                          textStyle: TextStyle(color: gris),
                                        )),
                                  ),
                                ))
                            .toList());
                  }))
        ],
      ),
    );
  }

  Future borrantareas(String _id) async {
    var data = {
      'tipo': 'baja_tarea',
      'id_tarea': _id,
    };
    print(data);
    final reponse = await http.post(urltareas,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    print(reponse.body);
  }
}
