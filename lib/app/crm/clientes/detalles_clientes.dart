import 'package:asamexico/app/crm/clientes/listacontactos_clientes.dart';
import 'package:asamexico/app/variables/colors.dart';
import 'package:asamexico/app/variables/servicesurl.dart';
import 'package:asamexico/app/variables/variables.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

TextEditingController _nombre = TextEditingController();
TextEditingController _puesto = TextEditingController();
TextEditingController _correo = TextEditingController();
TextEditingController _telefono = TextEditingController();
TextEditingController _ubicacion = TextEditingController();

class detalles_clientes extends StatefulWidget {
  final String _razonSocial;
  final String _rfc;
  final String _domicilio;
  final String _cp;
  final String _usoCfdi;
  final String _regimen;
  final String _telefono;
  final String _email;
  final String _nombreContacto;
  final String _id;

  detalles_clientes(
      this._razonSocial,
      this._rfc,
      this._domicilio,
      this._cp,
      this._usoCfdi,
      this._regimen,
      this._telefono,
      this._email,
      this._nombreContacto,
      this._id);

  @override
  State<detalles_clientes> createState() => _detalles_clientesState();
}

class _detalles_clientesState extends State<detalles_clientes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles',
            style: GoogleFonts.itim(textStyle: TextStyle(color: blanco))),
        backgroundColor: azulp,
      ),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 10,
                child: ExpansionTile(
                    title: _datos(widget._razonSocial, 'Nombre o razon social'),
                    leading: CircleAvatar(
                      backgroundColor: azulp,
                      child: Icon(
                        Icons.home_work,
                        color: blanco,
                      ),
                    ),
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Center(
                          //   child: CircleAvatar(
                          //     backgroundColor: azulp,
                          //     child: Icon(
                          //       Icons.home_work,
                          //       color: blanco,
                          //     ),
                          //   ),
                          // ),

                          _datos(widget._rfc, 'RFC'),
                          _datos(widget._domicilio, 'Domicilio'),
                          _datos(widget._cp, 'Codigo postal'),
                          _datos(widget._telefono, 'Telefono'),
                          _datos(widget._email, 'Email'),
                          _datos(widget._nombreContacto, 'Contacto'),
                        ],
                      )
                    ]),
              ),
            ),
            Text('Lista de contactos',
                style: GoogleFonts.itim(textStyle: TextStyle(color: azulp))),
            Flexible(child: listacontactos_clientes(widget._id))
          ],
        ),
      ),
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

  ListTile _datos(String _dato, String _label) {
    return ListTile(
      title: Text(_dato,
          style: GoogleFonts.itim(textStyle: TextStyle(color: azulp))),
      subtitle: Text(_label,
          style: GoogleFonts.itim(textStyle: TextStyle(color: gris))),
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
              'Alta de contacto',
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
                    onChanged: (value) {
                      setState(() {});
                    },
                    style: GoogleFonts.itim(textStyle: TextStyle(color: azulp)),
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
                Card(
                  elevation: 10,
                  child: TextField(
                    controller: _ubicacion,
                    onChanged: (value) {
                      setState(() {});
                    },
                    style: GoogleFonts.itim(textStyle: TextStyle(color: azulp)),
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
                          guardar();
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
      'tipo': 'alta_contacto',
      'usuario': usuario,
      'id_cliente': widget._id,
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

    setState(() {
      _ubicacion.clear();
      _nombre.clear();
      _correo.clear();
      _puesto.clear();
      _correo.clear();
      _telefono.clear();
    });
  }
}
