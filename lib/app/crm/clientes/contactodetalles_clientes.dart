import 'package:Asamexico/app/variables/colors.dart';
import 'package:Asamexico/app/variables/servicesurl.dart';
import 'package:Asamexico/app/variables/variables.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

TextEditingController _nombre = TextEditingController();
TextEditingController _puesto = TextEditingController();
TextEditingController _correo = TextEditingController();
TextEditingController _telefono = TextEditingController();
TextEditingController _ubicacion = TextEditingController();

bool _activar = false;

class contactodetalles_clientes extends StatefulWidget {
  final String _id;
  final String _idCliente;
  final String _correo;
  final String _nombre;
  final String _puesto;
  final String _telefono;
  final String _ubicacion;
  const contactodetalles_clientes(this._id, this._idCliente, this._correo,
      this._nombre, this._puesto, this._telefono, this._ubicacion);

  @override
  State<contactodetalles_clientes> createState() =>
      _contactodetalles_clientesState();
}

class _contactodetalles_clientesState extends State<contactodetalles_clientes> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nombre.text = widget._nombre;
    _puesto.text = widget._puesto;
    _telefono.text = widget._telefono;
    _correo.text = widget._correo;
    _ubicacion.text = widget._ubicacion;
    _activar = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalles:',
          style: GoogleFonts.itim(textStyle: TextStyle(color: blanco)),
        ),
        backgroundColor: azulp,
      ),
      backgroundColor: blanco,
      body: Container(
        child: Column(
          children: [
            Card(
              color: _activar == false ? gris : azuls,
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      _activar = !_activar;
                    });
                  },
                  icon: Icon(
                    Icons.lock_open,
                    color: blanco,
                  )),
            ),
            Card(
              elevation: 10,
              child: TextField(
                controller: _nombre,
                maxLines: 1,
                enabled: _activar,
                onChanged: (value) {
                  setState(() {});
                },
                style: GoogleFonts.itim(
                    textStyle:
                        TextStyle(color: _activar == false ? gris : azulp)),
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Nombre',
                    prefixIcon: Icon(Icons.person),
                    hintStyle: TextStyle(
                      color: Colors.black26,
                    )),
              ),
            ),
            Card(
              elevation: 10,
              child: TextField(
                controller: _puesto,
                enabled: _activar,
                onChanged: (value) {
                  setState(() {});
                },
                style: GoogleFonts.itim(
                    textStyle:
                        TextStyle(color: _activar == false ? gris : azulp)),
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: Icon(Icons.corporate_fare),
                    hintText: 'Puesto',
                    hintStyle: TextStyle(
                      color: Colors.black26,
                    )),
              ),
            ),
            Card(
              elevation: 10,
              child: TextField(
                controller: _telefono,
                enabled: _activar,
                onChanged: (value) {
                  setState(() {});
                },
                style: GoogleFonts.itim(
                    textStyle:
                        TextStyle(color: _activar == false ? gris : azulp)),
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
                enabled: _activar,
                onChanged: (value) {
                  setState(() {});
                },
                style: GoogleFonts.itim(
                    textStyle:
                        TextStyle(color: _activar == false ? gris : azulp)),
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
            Card(
              elevation: 10,
              child: TextField(
                controller: _ubicacion,
                enabled: _activar,
                onChanged: (value) {
                  setState(() {});
                },
                style: GoogleFonts.itim(
                    textStyle:
                        TextStyle(color: _activar == false ? gris : azulp)),
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: Icon(Icons.notes),
                    hintText: 'Ubicacion o referencia',
                    hintStyle: TextStyle(
                      color: Colors.black26,
                    )),
              ),
            ),
            _activar == false
                ? Container()
                : Card(
                    elevation: 10,
                    color: rojo,
                    child: GestureDetector(
                      onTap: (() {
                        guardar();
                      }),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Guardar y salir',
                          style: GoogleFonts.itim(
                              textStyle: TextStyle(color: blanco)),
                        ),
                      ),
                    )),
          ],
        ),
      ),
    );
  }

  Future guardar() async {
    var data = {
      'tipo': 'actua_contacto',
      'usuario': usuario,
      'id': widget._id,
      'telefono': _telefono.text,
      'ubicacion': _ubicacion.text,
      'correo': _correo.text,
      'puesto': _puesto.text,
      'nombre': _nombre.text
    };
    print(data);

    var res = await http.post(urlcontactos,
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

    Navigator.of(context).pop();
  }
}
