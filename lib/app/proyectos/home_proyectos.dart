import 'package:asamexico/app/home/lateral_app.dart';

import 'package:asamexico/app/proyectos/menu_proyectos.dart';
import 'package:asamexico/app/variables/colors.dart';
import 'package:asamexico/app/variables/servicesurl.dart';
import 'package:asamexico/app/variables/variables.dart';

import 'package:asamexico/models/proyectos_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

TextEditingController _titulo = TextEditingController();
TextEditingController _observaciones = TextEditingController();

TextEditingController _cliente = TextEditingController();

class home_proyectos extends StatefulWidget {
  const home_proyectos({super.key});

  @override
  State<home_proyectos> createState() => _home_proyectosState();
}

class _home_proyectosState extends State<home_proyectos> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titulo.clear();
    _observaciones.clear();
    listaprod();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Proyectos',
            style: GoogleFonts.sulphurPoint(
              textStyle: TextStyle(color: blanco),
            )),
        backgroundColor: azulp,
      ),
      backgroundColor: blanco,
      drawer: menulateral(),
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
          child: FutureBuilder<List<Modellistaproyectos>>(
              future: listaprod(),
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
                                            builder: (context) =>
                                                menu_proyectos(
                                                    data.id,
                                                    data.nombre,
                                                    data.observaciones,
                                                    data.idCliente,
                                                    data.fecha)));

                                    // detalle_proyectos(
                                    //     data.id,
                                    //     data.nombre,
                                    //     data.observaciones,
                                    //     data.idCliente,
                                    //     data.fecha)));
                                  },
                                  leading: Text(data.id,
                                      style: GoogleFonts.sulphurPoint(
                                        textStyle: TextStyle(),
                                      )),
                                  title: Text(data.nombre,
                                      style: GoogleFonts.sulphurPoint(
                                        textStyle: TextStyle(),
                                      )),
                                  subtitle: Text(data.observaciones,
                                      style: GoogleFonts.sulphurPoint(
                                        textStyle: TextStyle(),
                                      )),
                                  trailing: Text(
                                      DateFormat('dd/MM')
                                          .format(data.fecha)
                                          .toString(),
                                      style: GoogleFonts.sulphurPoint(
                                        textStyle: TextStyle(),
                                      ))),
                            ))
                        .toList());
              })),
      floatingActionButton: FloatingActionButton(
        backgroundColor: rojo,
        onPressed: () {
          altaproyecto(context); //
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => alta_productos()));
        },
        child: Icon(
          Icons.add,
          color: blanco,
        ),
      ),
    );
  }

  void altaproyecto(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Alta de proyecto',
            style: GoogleFonts.itim(textStyle: TextStyle(color: rojo)),
          ),
          content: Column(
            children: [
              TextField(
                controller: _titulo,
                maxLines: 1,
                onChanged: (value) {},
                style: GoogleFonts.itim(textStyle: TextStyle(color: azulp)),
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Titulo',
                    hintStyle: TextStyle(
                      color: Colors.black26,
                    )),
              ),
              TextField(
                controller: _observaciones,
                maxLines: 5,
                onChanged: (value) {},
                style: GoogleFonts.itim(textStyle: TextStyle(color: azulp)),
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Notas o detalles',
                    hintStyle: TextStyle(
                      color: Colors.black26,
                    )),
              ),
            ],
          ),
          actions: <Widget>[
            Container(
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: rojo),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Cerrar',
                          style: GoogleFonts.itim(
                              textStyle: TextStyle(color: blanco)),
                        ),
                      ))),
            ),
            Container(
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: azulp),
                      onPressed: () {
                        altaprotectos();
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Crear',
                          style: GoogleFonts.itim(
                              textStyle: TextStyle(color: blanco)),
                        ),
                      ))),
            ),
          ],
        );
      },
    );
  }

  Future<List<Modellistaproyectos>> listaprod() async {
    //print('======$notmes======');
    var data = {
      'tipo': 'lista_proyectos',
    };
    //print(data);
    final response = await http.post(urlproyectos,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      //print(response.body);

      List<Modellistaproyectos> studentList =
          items.map<Modellistaproyectos>((json) {
        return Modellistaproyectos.fromJson(json);
      }).toList();
      setState(() {});
      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  Future altaprotectos() async {
    var data = {
      'tipo': 'alta',
      'nombre': _titulo.text,
      'observaciones': _observaciones.text,
      'id_cliente': '1',
      'usuario': usuario,
    };
    print(data);
    final reponse = await http.post(urlproyectos,
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
      _titulo.clear();
      _observaciones.clear();
    });
    // Navigator.pop(context);
  }
}
