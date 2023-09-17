import 'package:asamexico/app/home/lateral_app.dart';
import 'package:asamexico/app/variables/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home_app extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido',
            style: GoogleFonts.itim(
              textStyle: TextStyle(color: blanco),
            )),
        backgroundColor: azulp,
      ),
      drawer: menulateral(),
      backgroundColor: blanco,
      body: Container(
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //       begin: FractionalOffset(0.0, 0.3),
        //       end: FractionalOffset(0.0, 0.8),
        //       colors: [
        //         blanco,
        //         blanco,
        //       ]),
        //   image: DecorationImage(
        //     colorFilter: ColorFilter.mode(
        //       Color.fromARGB(200, 245, 245, 245).withOpacity(0.3),
        //       BlendMode.modulate,
        //     ),
        //     image: AssetImage('assets/images/asaazul.jpg'),
        //     fit: BoxFit.contain,
        //   ),
        // ),
        child: Center(
            child: Text('Aqui veras las notificaciones mas relevantes del dia',
                style: GoogleFonts.itim(
                  textStyle: TextStyle(color: gris),
                ))),
      ),
    );
  }
}
