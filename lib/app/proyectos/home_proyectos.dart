import 'package:Asamexico/app/home/lateral_app.dart';

import 'package:Asamexico/app/proyectos/menu_proyectos.dart';
import 'package:Asamexico/app/variables/colors.dart';
import 'package:Asamexico/app/variables/servicesurl.dart';
import 'package:Asamexico/app/variables/variables.dart';
import 'package:Asamexico/models/clientes_model.dart';

import 'package:Asamexico/models/proyectos_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

TextEditingController _titulo = TextEditingController();
TextEditingController _observaciones = TextEditingController();

TextEditingController _cliente = TextEditingController();
List<Modellistaclientes> _sugesttioncliente = [];
String _idcliente = '';

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
    _idcliente = '';
    listaprod();
    listaclientes();
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
      // drawer: menulateral(),
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
                                                  data.fecha,
                                                )));

                                    // detalle_proyectos(
                                    //     data.id,
                                    //     data.nombre,
                                    //     data.observaciones,
                                    //     data.idCliente,
                                    //     data.fecha)));
                                  },
                                  leading: IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Borrar proyecto',
                                                  style: GoogleFonts.itim(
                                                      textStyle: TextStyle(
                                                          color: azulp))),
                                              content: Text(
                                                  'Se borrara el proyecto ' +
                                                      data.id +
                                                      ':  ' +
                                                      data.nombre +
                                                      ' del cliente ' +
                                                      data.nombre_cliente
                                                          .toString() +
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
                                  title: Text(
                                      data.id +
                                          ' ' +
                                          data.nombre_cliente.toString(),
                                      style: GoogleFonts.sulphurPoint(
                                        textStyle: TextStyle(),
                                      )),
                                  subtitle: Text(data.nombre,
                                      style: GoogleFonts.sulphurPoint(
                                        textStyle: TextStyle(),
                                      )),
                                  trailing: Text(
                                      DateFormat('dd/MM')
                                          .format(data.fecha)
                                          .toString(),
                                      style: GoogleFonts.sulphurPoint(
                                        textStyle: TextStyle(color: azulp),
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

  Future borrar(String _id) async {
    var data = {
      'tipo': 'borra_proyectos',
      'id_proyecto': _id,
    };
    print(data);

    var res = await http.post(urlproyectos,
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
      listaprod();
    });
  }

  void altaproyecto(BuildContext context) {
    // Acción al hacer clic en el botón
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text(
              'Alta de proyecto',
              style: GoogleFonts.itim(textStyle: TextStyle(color: rojo)),
            ),
            content: Column(
              children: [
                Container(
                  child: ListTile(
                    subtitle: Text('Selecciona un cliente',
                        style: GoogleFonts.sulphurPoint(
                          textStyle: TextStyle(color: azulp),
                        )),
                    title: Autocomplete<Modellistaclientes>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        return _sugesttioncliente
                            .where((Modellistaclientes county) =>
                                county.razonSocial.toLowerCase().startsWith(
                                    textEditingValue.text.toLowerCase()))
                            .toList();
                      },
                      displayStringForOption: (Modellistaclientes option) =>
                          option.razonSocial,
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
                      onSelected: (Modellistaclientes selection) {
                        setState(() {
                          print(selection.razonSocial);
                          _idcliente = selection.id;
                        });
                      },
                    ),
                  ),
                ),
                Card(
                  elevation: 10,
                  child: TextField(
                    controller: _titulo,
                    maxLines: 1,
                    onChanged: (value) {
                      setState(() {});
                    },
                    style: GoogleFonts.itim(textStyle: TextStyle(color: azulp)),
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Título',
                        hintStyle: TextStyle(
                          color: Colors.black26,
                        )),
                  ),
                ),
                Card(
                  elevation: 10,
                  child: TextField(
                    controller: _observaciones,
                    maxLines: 5,
                    onChanged: (value) {
                      setState(() {});
                    },
                    style: GoogleFonts.itim(textStyle: TextStyle(color: azulp)),
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Notas o detalles',
                        hintStyle: TextStyle(
                          color: Colors.black26,
                        )),
                  ),
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
                        style: ElevatedButton.styleFrom(
                            primary: _titulo.text != '' &&
                                    _observaciones.text != '' &&
                                    _idcliente != ''
                                ? azulp
                                : gris),
                        onPressed: () {
                          _titulo.text != '' &&
                                  _observaciones.text != '' &&
                                  _idcliente != ''
                              ? altaprotectos()
                              : print('Nada');
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
        });
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
      // print(response.body);

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
      _sugesttioncliente = items.map<Modellistaclientes>((json) {
        return Modellistaclientes.fromJson(json);
      }).toList();
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
      'id_cliente': _idcliente,
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
      _idcliente = '';
    });
    // Navigator.pop(context);
  }
}
