import 'package:asamexico/app/clientes/alta_clientes.dart';
import 'package:asamexico/app/clientes/lista_clientes.dart';
import 'package:asamexico/app/home/lateral_app.dart';
import 'package:asamexico/app/variables/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class home_clientes extends StatelessWidget {
  const home_clientes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Clientes',
          style: GoogleFonts.itim(textStyle: TextStyle(color: blanco)),
        ),
        backgroundColor: azulp,
      ),
      drawer: menulateral(),
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
        child: lista_clientes(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: rojo,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => alta_clientes()));
        },
        child: Icon(
          Icons.add,
          color: blanco,
        ),
      ),
    );
  }
}
