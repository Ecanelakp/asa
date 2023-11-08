import 'package:asamexico/app/variables/colors.dart';
import 'package:asamexico/app/variables/servicesurl.dart';
import 'package:asamexico/models/clientes_model.dart';
import 'package:asamexico/models/compras_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

TextEditingController _nombre = TextEditingController();
TextEditingController _rfc = TextEditingController();
TextEditingController _correo = TextEditingController();
TextEditingController _telefono = TextEditingController();

class catalogoprov_compras extends StatefulWidget {
  const catalogoprov_compras({super.key});

  @override
  State<catalogoprov_compras> createState() => _catalogoprov_comprasState();
}

class _catalogoprov_comprasState extends State<catalogoprov_compras> {
  @override
  void initState() {
    super.initState();
    listaproveedoes();
  }

  Future<List<Modellisproveedores>> listaproveedoes() async {
    //print('======$notmes======');
    var data = {
      'tipo': 'lista_prov',
    };
    // print(data);
    final response = await http.post(urlcompras,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      // print(response.body);

      List<Modellisproveedores> studentList =
          items.map<Modellisproveedores>((json) {
        return Modellisproveedores.fromJson(json);
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
        title: Text('Catálogo de proveedores',
            style: GoogleFonts.itim(
              textStyle: TextStyle(),
            )),
        backgroundColor: azulp,
      ),
      body: FutureBuilder<List<Modellisproveedores>>(
          future: listaproveedoes(),
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
                            title: Text(data.nombre,
                                style: GoogleFonts.itim(
                                  textStyle: TextStyle(color: azulp),
                                )),
                            subtitle: Text(data.rfc,
                                style: GoogleFonts.itim(
                                  textStyle: TextStyle(),
                                )),
                          ),
                        ))
                    .toList());
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: rojo,
        onPressed: () {
          altaproyecto(context);
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => alta_clientes()));
        },
        child: Icon(
          Icons.add,
          color: blanco,
        ),
      ),
    );
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
              'Alta de proveedor',
              style: GoogleFonts.itim(textStyle: TextStyle(color: rojo)),
            ),
            content: Column(
              children: [
                Card(
                  elevation: 10,
                  child: TextField(
                    controller: _nombre,
                    maxLines: 1,
                    onChanged: (value) {
                      setState(() {});
                    },
                    style: GoogleFonts.itim(textStyle: TextStyle(color: azulp)),
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Razon Social',
                        prefixIcon: Icon(Icons.person),
                        hintStyle: TextStyle(
                          color: Colors.black26,
                        )),
                  ),
                ),
                Card(
                  elevation: 10,
                  child: TextField(
                    controller: _rfc,
                    onChanged: (value) {
                      setState(() {});
                    },
                    style: GoogleFonts.itim(textStyle: TextStyle(color: azulp)),
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(Icons.corporate_fare),
                        hintText: 'RFC',
                        hintStyle: TextStyle(
                          color: Colors.black26,
                        )),
                  ),
                ),
                Card(
                  elevation: 10,
                  child: TextField(
                    controller: _telefono,
                    onChanged: (value) {
                      setState(() {});
                    },
                    style: GoogleFonts.itim(textStyle: TextStyle(color: azulp)),
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(Icons.phone),
                        hintText: 'Telefono',
                        hintStyle: TextStyle(
                          color: Colors.black26,
                        )),
                  ),
                ),
                Card(
                  elevation: 10,
                  child: TextField(
                    controller: _correo,
                    onChanged: (value) {
                      setState(() {});
                    },
                    style: GoogleFonts.itim(textStyle: TextStyle(color: azulp)),
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(Icons.mail),
                        hintText: 'Correo electronico',
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
                            primary: _nombre.text != '' && _rfc.text != ''
                                ? azulp
                                : gris),
                        onPressed: () {
                          _nombre.text != '' && _rfc.text != ''
                              ? guardar()
                              : print('nada');
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

  Future guardar() async {
    var data = {
      'tipo': 'alta_proveedor',
      'telefono': _telefono.text,
      'correo': _correo.text,
      'rfc': _rfc.text,
      'nombre': _nombre.text
    };
    print(data);

    var res = await http.post(urlcompras,
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
      _rfc.clear();
      _nombre.clear();
      _correo.clear();

      _correo.clear();
      _telefono.clear();
    });
  }
}
