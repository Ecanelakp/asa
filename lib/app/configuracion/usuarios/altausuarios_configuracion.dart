import 'package:Asamexico/app/variables/colors.dart';
import 'package:Asamexico/app/variables/servicesurl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


TextEditingController _nombrecompleto = TextEditingController();
TextEditingController _usuario = TextEditingController();
TextEditingController _contrasena = TextEditingController();
TextEditingController _confcontrasena = TextEditingController();
TextEditingController _perfil = TextEditingController();
bool _validador1=false;
bool _mismas=false;

class altausuarios_configuracion extends StatefulWidget {
  const altausuarios_configuracion({super.key});

  @override
  State<altausuarios_configuracion> createState() => _altausuarios_configuracionState();
}

class _altausuarios_configuracionState extends State<altausuarios_configuracion> {

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nombrecompleto.clear();
    _confcontrasena.clear();
    _contrasena.clear();
    _perfil.clear();
    _usuario.clear();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Alta de usuarios'),backgroundColor: azulp,),
      body: 
       Container(
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
            Spacer(),
          CircleAvatar( backgroundColor: azulp,   child: Icon(Icons.person_4, color: blanco,),),
           Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _nombrecompleto,
                      onChanged: (value) {
                        setState(() {
                          
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Nombre completo',
                        labelStyle: GoogleFonts.sulphurPoint(
                            textStyle: TextStyle(color: gris)),
                      ),
                    ),
                  ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _usuario,
                      onChanged: (value) {
                        setState(() {
                          
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Usuario o correo electronico',
                        labelStyle: GoogleFonts.sulphurPoint(
                            textStyle: TextStyle(color: gris)),
                      ),
                    ),
                  ),
              Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _contrasena,
                      onChanged: (value) {
                        setState(() {
                          
                        });
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                         
                        labelText: 'Contraseña',
                        labelStyle: GoogleFonts.sulphurPoint(
                            textStyle: TextStyle(color: gris)),
                      ),
                    ),
                  ),
              _contrasena.text.length< 5?Container():  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _confcontrasena,
                      obscureText: true,
                      onChanged: (value) {
                        setState(() {
                          
                        });
                      },

                      decoration: InputDecoration(
                        suffixIcon: _confcontrasena.text==_contrasena.text? 
                        Icon(Icons.check, color: Colors.green,):Icon(Icons.close, color: gris,),
                        labelText: 'Confirma contraseña',
                        labelStyle: GoogleFonts.sulphurPoint(
                            textStyle: TextStyle(color: gris)),
                      ),
                    ),
                  ),
             Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _perfil,
                      onChanged: (value) {
                        setState(() {
                          
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Perfil',
                        labelStyle: GoogleFonts.sulphurPoint(
                            textStyle: TextStyle(color: gris )),
                      ),
                    ),
                  ),

Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:   _confcontrasena.text!=_contrasena.text || _nombrecompleto.text=='' || _perfil.text=='' || _usuario.text=='' ?gris:rojo),
                        onPressed: () {
                          _confcontrasena.text!=_contrasena.text ||_nombrecompleto.text=='' || _perfil.text=='' || _usuario.text==''?
                      
                          print('nada'):guardar();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Guardar',
                                style: GoogleFonts.sulphurPoint(
                                    textStyle: TextStyle(color: blanco)),
                              ),
                              Icon((Icons.save)),
                            ],
                          ),
                        ))),
                        Spacer(),
          ],
               ),
       ),
    );



  }

  Future guardar() async {
    var data = {
      'tipo': 'alta',
      'email':_usuario.text,
      'contrasena':_confcontrasena.text,
      'nombre':_nombrecompleto.text,
      'perfil':_perfil.text,
    };
    print(data);

    var res = await http.post(urluser,
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
      _nombrecompleto.clear();
      _usuario.clear();
      _confcontrasena.clear();
      _contrasena.clear();
      _perfil.clear();
    });
    Navigator.of(context).pop();
  }
}