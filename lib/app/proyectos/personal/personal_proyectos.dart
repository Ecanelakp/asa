import 'package:Asamexico/app/variables/colors.dart';
import 'package:Asamexico/app/variables/servicesurl.dart';
import 'package:Asamexico/models/tareas_model.dart';
import 'package:Asamexico/models/usuarios_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Asignados {
  String? idresponsable;
  String? responsable;

  Asignados(
    this.idresponsable,
    this.responsable,
  );
}

class Entradapersonal {
  String? idpersonal;
  String? nombrepersonal;
  DateTime? horaentrada;
  DateTime? horasalida;
  String? referencia;

  Entradapersonal(this.idpersonal, this.nombrepersonal, this.horaentrada,
      this.horasalida, this.referencia);
}

List<Asignados> _selectperson = [];
List<Entradapersonal> _Registroentrda = [];
List<usuariosmodel> _sugesttioncliente = [];
String _emailusuario = '';
String _usuario = '';
TextEditingController _usuarioselect = TextEditingController();

class personal_proyectos extends StatefulWidget {
  const personal_proyectos({super.key});

  @override
  State<personal_proyectos> createState() => _personal_proyectosState();
}

class _personal_proyectosState extends State<personal_proyectos> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listaclientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blanco,
      appBar: AppBar(
        backgroundColor: azulp,
        title: Text('Asignación de personal',
            style: GoogleFonts.sulphurPoint(
              textStyle: TextStyle(color: blanco),
            )),
      ),
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
            Row(
              children: [
                Flexible(
                  child: Container(
                    child: ListTile(
                      subtitle: Text('Selecciona responsables',
                          style: GoogleFonts.sulphurPoint(
                            textStyle: TextStyle(color: azulp),
                          )),
                      title: Autocomplete<usuariosmodel>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          return _sugesttioncliente
                              .where((usuariosmodel county) => county.nombre
                                  .toString()
                                  .toLowerCase()
                                  .startsWith(
                                      textEditingValue.text.toLowerCase()))
                              .toList();
                        },
                        displayStringForOption: (usuariosmodel option) =>
                            option.nombre.toString(),
                        fieldViewBuilder: (BuildContext context,
                            _usuarioselect,
                            FocusNode fieldFocusNode,
                            VoidCallback onFieldSubmitted) {
                          return TextField(
                              controller: _usuarioselect,
                              focusNode: fieldFocusNode,
                              style: GoogleFonts.sulphurPoint(
                                textStyle: TextStyle(color: azulp),
                              ),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintStyle: TextStyle(color: azuls)));
                        },
                        onSelected: (usuariosmodel selection) {
                          setState(() {
                            print(selection.nombre);
                            _emailusuario = selection.email.toString();
                            _usuario = selection.nombre.toString();
                            _usuarioselect.clear();
                            _usuarioselect.text = '';

                            //fieldTextEditingController
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
                          _selectperson.add(Asignados(_emailusuario, _usuario));
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
            Text('Lista de personal asigando',
                style: GoogleFonts.sulphurPoint(
                  textStyle: TextStyle(color: azulp),
                )),
            Flexible(
                flex: 8,
                child: Container(
                    child: ListView.builder(
                        itemCount: _selectperson.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 10,
                              child: Row(
                                children: [
                                  Flexible(
                                    child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage: AssetImage(
                                            "assets/images/profile.png",
                                          ),
                                        ),
                                        title: Text(
                                            _selectperson[index]
                                                .responsable
                                                .toString(),
                                            style: GoogleFonts.sulphurPoint(
                                                textStyle:
                                                    TextStyle(color: azulp)))),
                                  ),
                                  Card(
                                    color: azuls,
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.punch_clock,
                                            color: blanco,
                                          ),
                                        )),
                                  ),
                                  Card(
                                    color: rojo,
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _selectperson.removeAt(index);
                                              });
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: blanco,
                                            ))),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }))),
            Flexible(
                flex: 8,
                child: Container(
                    child: ListView.builder(
                        itemCount: _selectperson.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 10,
                              child: Row(
                                children: [
                                  Flexible(
                                    child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage: AssetImage(
                                            "assets/images/profile.png",
                                          ),
                                        ),
                                        title: Text(
                                            _selectperson[index]
                                                .responsable
                                                .toString(),
                                            style: GoogleFonts.sulphurPoint(
                                                textStyle:
                                                    TextStyle(color: azulp)))),
                                  ),
                                  Card(
                                    color: rojo,
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: blanco,
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }))),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: azuls,
      //   onPressed: () {
      //     // Navigator.push(context,
      //     //     MaterialPageRoute(builder: (context) => alta_productos()));
      //   },
      //   child: Icon(
      //     Icons.punch_clock,
      //     color: blanco,
      //   ),
      // ),
    );
  }

  Future<List<usuariosmodel>> listaclientes() async {
    //print('======$notmes======');
    var data = {
      'tipo': 'lista',
    };
    // print(data);
    final response = await http.post(urluser,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      //print(response.body);

      List<usuariosmodel> studentList = items.map<usuariosmodel>((json) {
        return usuariosmodel.fromJson(json);
      }).toList();
      setState(() {});
      _sugesttioncliente = items.map<usuariosmodel>((json) {
        return usuariosmodel.fromJson(json);
      }).toList();
      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }
}
