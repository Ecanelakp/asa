import 'package:asamexico/app/home/home_app.dart';
import 'package:asamexico/app/variables/colors.dart';
import 'package:asamexico/app/variables/servicesurl.dart';
import 'package:asamexico/app/variables/variables.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

TextEditingController _usuario = TextEditingController();
TextEditingController _password = TextEditingController();
String _notificacion = '';
String _mensaje = '';
bool _checkrecord = false;
double _height = 0;
double _width = 0;
String _error = '';

class login_app extends StatefulWidget {
  @override
  State<login_app> createState() => _login_appState();
}

class _login_appState extends State<login_app> {
  void initState() {
    // TODO: implement initState
    super.initState();
    _height = 0;
    _width = 0;
    recordarcredenciales();
    // startRepeatingAction();
    // _checkPermissions();
    // _checkPermissionsfiles();
  }

  Future<void> recordarcredenciales() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('recover'));
    _checkrecord = true;
    if (prefs.getString('recover') == 'true') {
      setState(() {
        _checkrecord = true;
      });

      _usuario.text = prefs.getString('user')!;
      _password.text = prefs.getString('password')!;
    } else {
      setState(() {
        _checkrecord = false;
      });
      _usuario.text = '';
      _password.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: azulp,
        body: Container(
            child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.80,
            // height: MediaQuery.of(context).size.height * 0.40,
            child: Card(
              elevation: 10,
              shadowColor: gris,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      new Image.asset(
                        'assets/images/asablanco.jpg',
                        height: 100.0,
                        fit: BoxFit.contain,
                      ),
                      Container(
                        child: TextField(
                          controller: _usuario,
                          style:
                              GoogleFonts.sulphurPoint(textStyle: TextStyle()),
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Usuario',
                            fillColor: Colors.white,
                            hintStyle: TextStyle(color: gris),
                            icon: Icon(
                              Icons.person,
                              color: gris,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: TextField(
                          controller: _password,
                          obscureText: true,
                          style:
                              GoogleFonts.sulphurPoint(textStyle: TextStyle()),
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Contraseña',
                            fillColor: Colors.white,
                            hintStyle: TextStyle(color: gris),
                            icon: Icon(
                              Icons.password,
                              color: gris,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(primary: rojo),
                                onPressed: () {
                                  login();
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => Home_app()));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Entrar',
                                    style: GoogleFonts.itim(
                                        textStyle: TextStyle(color: blanco)),
                                  ),
                                ))),
                      ),
                      Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            Checkbox(
                              value: _checkrecord,
                              activeColor: azuls,
                              onChanged: (value) {
                                setState(() {
                                  _checkrecord = value!;
                                });
                              },
                            ),
                            Text(
                              'Recordar usuario',
                              style: GoogleFonts.itim(
                                  textStyle: TextStyle(color: azuls)),
                            )
                          ])),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          version,
                          style: GoogleFonts.sulphurPoint(
                              textStyle: TextStyle(color: gris)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )));
  }

  Future login() async {
    var data = {
      'usuario': _usuario.text,
      'contrasena': _password.text,
    };
    var response = await http.post(urllogin, body: json.encode(data));
    // print(data);
    // print(urllogin);
    print(response.body);

    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      _error = (jsondata["Error"]);
      if (_error == 'ok') {
        print('entro usuario');
        setState(() {
          _width = 0;
          _height = 0;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user', _usuario.text);
        prefs.setString('password', _password.text);
        prefs.setString('recover', _checkrecord.toString());
        usuario = (jsondata["Usuario"]).toString();
        nombre = (jsondata["nombre"]).toString();
        idusuario = (jsondata["id"]).toString();
        perfil = (jsondata["perfil"]).toString();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home_app()));
        final snackBar = SnackBar(
          content: Text(
            'Bienvenido:  ' + (jsondata["nombre"]).toString().toUpperCase(),
            style:
                GoogleFonts.sulphurPoint(textStyle: TextStyle(color: blanco)),
          ),
          backgroundColor: (gris),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (_error == 'Activar') {
        setState(() {
          _width = MediaQuery.of(context).size.width * 0.9;
          _height = 80;
        });
      } else {
        final snackBar = SnackBar(
          content: Text(
            'Usuario y/o contraseña son incorrectos.',
            style:
                GoogleFonts.sulphurPoint(textStyle: TextStyle(color: blanco)),
          ),
          backgroundColor: (Colors.red),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          _mensaje = (jsondata["Mensaje"] == null ? '' : (jsondata["Mensaje"]));
        });
      }

      // print('====aqui =');
      //print(response.body);
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }
}
