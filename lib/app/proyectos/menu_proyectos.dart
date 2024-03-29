import 'package:Asamexico/app/proyectos/blog_proyectos.dart';
import 'package:Asamexico/app/proyectos/entregado_proyectos.dart';
import 'package:Asamexico/app/proyectos/envioprods_proyectos.dart';
import 'package:Asamexico/app/proyectos/personal/personal_proyectos.dart';
import 'package:Asamexico/app/proyectos/productos/productosproyec_home.dart';
import 'package:Asamexico/app/proyectos/retorno_proyectos.dart';
import 'package:Asamexico/app/variables/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class menu_proyectos extends StatelessWidget {
  final String _id;
  final String _nombre;
  final String _observaciones;
  final String _idCliente;
  final DateTime _fecha;
  const menu_proyectos(this._id, this._nombre, this._observaciones,
      this._idCliente, this._fecha);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: azulp,
        // bottom: TabBar(
        //   tabs: [
        // Tab(
        //   icon: Icon(Icons.ios_share),
        //   text:
        //       MediaQuery.of(context).size.width >= 600 ? "Enviado" : "",
        // ),
        // Tab(
        //     icon: Icon(Icons.screen_share),
        //     text: MediaQuery.of(context).size.width >= 600
        //         ? "Entregado"
        //         : ""),
        // Tab(
        //     icon: Icon(Icons.reply),
        //     text: MediaQuery.of(context).size.width >= 600
        //         ? "Retorno"
        //         : ""),
        // Tab(
        //     icon: Icon(Icons.keyboard_return),
        //     text: MediaQuery.of(context).size.width >= 600
        //         ? "Recibido"
        //         : ""),
        //   ],
        // ),
        title: Text('Proyecto: ' + _observaciones,
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
            Card(
              elevation: 10,
              child: ListTile(
                title: Text('Productos',
                    style: GoogleFonts.sulphurPoint(
                      textStyle: TextStyle(color: azulp),
                    )),
                subtitle: Text('Control, asignación y manejo de materiales',
                    style: GoogleFonts.sulphurPoint(
                      textStyle: TextStyle(color: gris),
                    )),
                onTap: (() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => productosproyectos_home(
                              _id, _nombre, _observaciones)));
                }),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: gris,
                ),
              ),
            ),
            Card(
              elevation: 10,
              child: ListTile(
                title: Text('Personal',
                    style: GoogleFonts.sulphurPoint(
                      textStyle: TextStyle(color: azulp),
                    )),
                subtitle: Text('Control, y asignación de personal',
                    style: GoogleFonts.sulphurPoint(
                      textStyle: TextStyle(color: gris),
                    )),
                onTap: (() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => personal_proyectos()));
                }),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: gris,
                ),
              ),
            ),
            Card(
              elevation: 10,
              child: ListTile(
                title: Text('Avances',
                    style: GoogleFonts.sulphurPoint(
                      textStyle: TextStyle(color: azulp),
                    )),
                subtitle: Text('Control de avances por proyecto',
                    style: GoogleFonts.sulphurPoint(
                      textStyle: TextStyle(color: gris),
                    )),
                onTap: (() {}),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: gris,
                ),
              ),
            ),
            // envioprods_proyectos(_id, _nombre, _observaciones),
            // entregado_proyectos(_id),
            // retorno_proyectos(_id),
            // Text('1'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: rojo,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => blog_proyectos(_id)));
        },
        child: Icon(
          Icons.comment,
          color: blanco,
        ),
      ),
    );
  }
}
