<<<<<<< HEAD
import 'package:Asamexico/app/notificaciones/alta_notificaciones.dart';
import 'package:Asamexico/app/variables/colors.dart';
import 'package:Asamexico/app/variables/servicesurl.dart';
import 'package:Asamexico/app/variables/variables.dart';
import 'package:Asamexico/models/clientes_model.dart';
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

class interacciones_clientes extends StatefulWidget {
  final String _idcliente;
  final String _idcontacto;
  const interacciones_clientes(this._idcliente, this._idcontacto);

  @override
  State<interacciones_clientes> createState() => _interacciones_clientesState();
}

class _interacciones_clientesState extends State<interacciones_clientes> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titulo.clear();
    _descripcion.clear();
    _fecha.clear();
    listaclientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interacciones',
            style: GoogleFonts.itim(textStyle: TextStyle(color: blanco))),
        backgroundColor: azulp,
      ),
      backgroundColor: azulp,
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.60,
                  child: FutureBuilder<List<Modellistinteracciones>>(
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
                                      child: ExpansionTile(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(data.descripcion,
                                                  textAlign: TextAlign.justify,
                                                  style: GoogleFonts.itim(
                                                      textStyle: TextStyle(
                                                          color: gris))),
                                            ),
                                          )
                                        ],
                                        leading: IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Borrar interacción',
                                                        style: GoogleFonts.itim(
                                                            textStyle: TextStyle(
                                                                color: azulp))),
                                                    content: Text(
                                                        'Se borrara la interaccion ' +
                                                            data.id +
                                                            ' realizada por ' +
                                                            data.usuario +
                                                            ' con el titulo ' +
                                                            data.titulo +
                                                            ' ¿Estas seguro de querer borrarla?',
                                                        style: GoogleFonts.itim(
                                                            textStyle:
                                                                TextStyle(
                                                                    color:
                                                                        gris))),
                                                    actions: <Widget>[
                                                      Card(
                                                        elevation: 10,
                                                        color: azuls,
                                                        child: TextButton(
                                                          child: Text('Cerrar',
                                                              style: GoogleFonts.itim(
                                                                  textStyle:
                                                                      TextStyle(
                                                                          color:
                                                                              blanco))),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
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
                                                                  textStyle:
                                                                      TextStyle(
                                                                          color:
                                                                              blanco))),
                                                          onPressed: () {
                                                            borrar(data.id);
                                                            Navigator.of(
                                                                    context)
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
                                        subtitle: Text(data.usuario,
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
              Container(
                width: double.infinity,
                color: azulp,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('Genera una interacción',
                          style: GoogleFonts.itim(
                              textStyle: TextStyle(color: blanco))),
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
                                  hintText: 'Fecha recordatorio',
                                  filled: true,
                                  fillColor: blanco,
                                  hintStyle: TextStyle(color: azuls),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
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
                                        backgroundColor: _titulo.text == '' ||
                                                _descripcion.text == ''
                                            ? gris
                                            : rojo),
                                    onPressed: () {
                                      if (_titulo.text == '' ||
                                          _descripcion.text == '') {
                                        print('nada');
                                      } else {
                                        guardar();
                                        altanotificaciones(
                                            'fcortes@asamexico.mx',
                                            _titulo.text,
                                            usuario +
                                                ' ha agregado el comentario:' +
                                                _descripcion.text);
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Guardar',
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Future guardar() async {
    var data = {
      'tipo': 'alta_interaccion',
      'usuario': usuario,
      'id_cliente': widget._idcliente,
      'id_contacto': widget._idcontacto,
      'titulo': _titulo.text,
      'descripcion': _descripcion.text,
      'fecha_recor': _fecha.text
    };
    //print(data);

    var res = await http.post(urlinteracciones,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    // print(res.body);

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

  Future borrar(String _id) async {
    var data = {
      'tipo': 'borra_interaccion',
      'id': _id,
    };
    print(data);

    var res = await http.post(urlinteracciones,
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
    });
  }

  Future<List<Modellistinteracciones>> listaclientes() async {
    //print('======$notmes======');
    var data = {
      'tipo': 'lista_interaccion',
      'id_cliente': widget._idcliente,
      'id_contacto': widget._idcontacto
    };
    //print(data);
    final response = await http.post(urlinteracciones,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      //print(response.body);

      List<Modellistinteracciones> studentList =
          items.map<Modellistinteracciones>((json) {
        return Modellistinteracciones.fromJson(json);
      }).toList();
      setState(() {});
      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }
}
=======
import 'package:Asamexico/app/notificaciones/alta_notificaciones.dart';
import 'package:Asamexico/app/variables/colors.dart';
import 'package:Asamexico/app/variables/servicesurl.dart';
import 'package:Asamexico/app/variables/variables.dart';
import 'package:Asamexico/models/clientes_model.dart';
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

class interacciones_clientes extends StatefulWidget {
  final String _idcliente;
  final String _idcontacto;
  const interacciones_clientes(this._idcliente, this._idcontacto);

  @override
  State<interacciones_clientes> createState() => _interacciones_clientesState();
}

class _interacciones_clientesState extends State<interacciones_clientes> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titulo.clear();
    _descripcion.clear();
    _fecha.clear();
    listaclientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interacciones',
            style: GoogleFonts.itim(textStyle: TextStyle(color: blanco))),
        backgroundColor: azulp,
      ),
      backgroundColor: azulp,
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.60,
                  child: FutureBuilder<List<Modellistinteracciones>>(
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
                                      child: ExpansionTile(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(data.descripcion,
                                                  textAlign: TextAlign.justify,
                                                  style: GoogleFonts.itim(
                                                      textStyle: TextStyle(
                                                          color: gris))),
                                            ),
                                          )
                                        ],
                                        leading: IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Borrar interacción',
                                                        style: GoogleFonts.itim(
                                                            textStyle: TextStyle(
                                                                color: azulp))),
                                                    content: Text(
                                                        'Se borrara la interaccion ' +
                                                            data.id +
                                                            ' realizada por ' +
                                                            data.usuario +
                                                            ' con el titulo ' +
                                                            data.titulo +
                                                            ' ¿Estas seguro de querer borrarla?',
                                                        style: GoogleFonts.itim(
                                                            textStyle:
                                                                TextStyle(
                                                                    color:
                                                                        gris))),
                                                    actions: <Widget>[
                                                      Card(
                                                        elevation: 10,
                                                        color: azuls,
                                                        child: TextButton(
                                                          child: Text('Cerrar',
                                                              style: GoogleFonts.itim(
                                                                  textStyle:
                                                                      TextStyle(
                                                                          color:
                                                                              blanco))),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
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
                                                                  textStyle:
                                                                      TextStyle(
                                                                          color:
                                                                              blanco))),
                                                          onPressed: () {
                                                            borrar(data.id);
                                                            Navigator.of(
                                                                    context)
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
                                        subtitle: Text(data.usuario,
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
              Container(
                width: double.infinity,
                color: azulp,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('Genera una interacción',
                          style: GoogleFonts.itim(
                              textStyle: TextStyle(color: blanco))),
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
                                  hintText: 'Fecha recordatorio',
                                  filled: true,
                                  fillColor: blanco,
                                  hintStyle: TextStyle(color: azuls),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
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
                                        backgroundColor: _titulo.text == '' ||
                                                _descripcion.text == ''
                                            ? gris
                                            : rojo),
                                    onPressed: () {
                                      if (_titulo.text == '' ||
                                          _descripcion.text == '') {
                                        print('nada');
                                      } else {
                                        guardar();
                                        altanotificaciones(
                                            'fcortes@asamexico.mx',
                                            _titulo.text,
                                            usuario +
                                                ' ha agregado el comentario:' +
                                                _descripcion.text);
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Guardar',
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Future guardar() async {
    var data = {
      'tipo': 'alta_interaccion',
      'usuario': usuario,
      'id_cliente': widget._idcliente,
      'id_contacto': widget._idcontacto,
      'titulo': _titulo.text,
      'descripcion': _descripcion.text,
      'fecha_recor': _fecha.text
    };
    //print(data);

    var res = await http.post(urlinteracciones,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    // print(res.body);

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

  Future borrar(String _id) async {
    var data = {
      'tipo': 'borra_interaccion',
      'id': _id,
    };
    print(data);

    var res = await http.post(urlinteracciones,
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
    });
  }

  Future<List<Modellistinteracciones>> listaclientes() async {
    //print('======$notmes======');
    var data = {
      'tipo': 'lista_interaccion',
      'id_cliente': widget._idcliente,
      'id_contacto': widget._idcontacto
    };
    //print(data);
    final response = await http.post(urlinteracciones,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      //print(response.body);

      List<Modellistinteracciones> studentList =
          items.map<Modellistinteracciones>((json) {
        return Modellistinteracciones.fromJson(json);
      }).toList();
      setState(() {});
      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }
}
>>>>>>> 7a0a6b2 (mac)
