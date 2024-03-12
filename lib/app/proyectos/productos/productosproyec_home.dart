import 'package:Asamexico/app/proyectos/entregado_proyectos.dart';
import 'package:Asamexico/app/proyectos/envioprods_proyectos.dart';
import 'package:Asamexico/app/proyectos/retorno_proyectos.dart';
import 'package:Asamexico/app/variables/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class productosproyectos_home extends StatelessWidget {
  final String _id;
  final String _nombre;
  final String _observaciones;
  productosproyectos_home(this._id, this._nombre, this._observaciones);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                tabs: [
                  Tab(
                    icon: Icon(Icons.ios_share),
                    text: MediaQuery.of(context).size.width >= 600
                        ? "Enviado"
                        : "",
                  ),
                  Tab(
                      icon: Icon(Icons.screen_share),
                      text: MediaQuery.of(context).size.width >= 600
                          ? "Entregado"
                          : ""),
                  Tab(
                      icon: Icon(Icons.reply),
                      text: MediaQuery.of(context).size.width >= 600
                          ? "Retorno"
                          : ""),
                  Tab(
                      icon: Icon(Icons.keyboard_return),
                      text: MediaQuery.of(context).size.width >= 600
                          ? "Recibido"
                          : ""),
                ],
              ),
              title: Text('Productos',
                  style: GoogleFonts.sulphurPoint(
                    textStyle: TextStyle(color: blanco),
                  )),
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
              child: TabBarView(
                children: [
                  envioprods_proyectos(_id, _nombre, _observaciones),
                  entregado_proyectos(_id),
                  retorno_proyectos(_id),
                  Text('1'),
                ],
              ),
            )));
  }
}
