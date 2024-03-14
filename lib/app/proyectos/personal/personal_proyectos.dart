import 'package:Asamexico/app/variables/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class personal_proyectos extends StatelessWidget {
  const personal_proyectos({super.key});

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
        child: Center(
          child: Text('Asigna personal al proyecto',
              style:
                  GoogleFonts.sulphurPoint(textStyle: TextStyle(color: azulp))),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: rojo,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Seleccion de personal",
                    style: GoogleFonts.sulphurPoint(
                      textStyle: TextStyle(color: gris),
                    )),
                content: Text(" Elige a tu equipo",
                    style: GoogleFonts.sulphurPoint(
                      textStyle: TextStyle(color: azulp),
                    )),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cerrar",
                        style: GoogleFonts.sulphurPoint(
                          textStyle: TextStyle(color: gris),
                        )),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Aceptar",
                      style: GoogleFonts.sulphurPoint(
                        textStyle: TextStyle(color: azulp),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          color: blanco,
        ),
      ),
    );
  }
}
