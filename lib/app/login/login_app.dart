import 'package:asamexico/app/home/home_app.dart';
import 'package:asamexico/app/variables/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextEditingController _usuario = TextEditingController();
TextEditingController _password = TextEditingController();

class login_app extends StatefulWidget {
  @override
  State<login_app> createState() => _login_appState();
}

class _login_appState extends State<login_app> {
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
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Home_app()));
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Version: 1.5.6',
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
}
