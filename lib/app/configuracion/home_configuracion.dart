import 'package:Asamexico/app/configuracion/usuarios_configuracion.dart';
import 'package:Asamexico/app/variables/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class home_configuracion extends StatelessWidget {
  const home_configuracion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Configuración',
              style: GoogleFonts.sulphurPoint(
                textStyle: TextStyle(color: blanco),
              )),
          backgroundColor: gris,
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
          child: Column(children: [
            Card(
              elevation: 10,
              child: ListTile(
                title: Text('Usuarios',
                    style: GoogleFonts.sulphurPoint(
                      textStyle: TextStyle(color: azulp),
                    )),
                subtitle: Text('Control, asignación y manejo de usuarios',
                    style: GoogleFonts.sulphurPoint(
                      textStyle: TextStyle(color: gris),
                    )),
                onTap: (() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => usuarios_configuracion()));
                }),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: rojo,
                ),
              ),
            ),
            Card(
              elevation: 10,
              child: ListTile(
                title: Text('Permisos',
                    style: GoogleFonts.sulphurPoint(
                      textStyle: TextStyle(color: azulp),
                    )),
                subtitle: Text('Control, y asignación de permisos por area',
                    style: GoogleFonts.sulphurPoint(
                      textStyle: TextStyle(color: gris),
                    )),
                onTap: (() {}),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: rojo,
                ),
              ),
            ),
            Card(
              elevation: 10,
              child: ListTile(
                title: Text('Facturación',
                    style: GoogleFonts.sulphurPoint(
                      textStyle: TextStyle(color: azulp),
                    )),
                subtitle: Text('Configuraciones para facturación electrónica',
                    style: GoogleFonts.sulphurPoint(
                      textStyle: TextStyle(color: gris),
                    )),
                onTap: (() {}),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: rojo,
                ),
              ),
            ),
          ]),
        ));
  }
}
