import 'package:Asamexico/app/variables/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class detalleusuarios_configuracion extends StatelessWidget {
  final String? _id;
  final String? _email;
  final String? _nombre;
  final String? _perfil;
  final String? _status;
  const detalleusuarios_configuracion(
      this._id, this._email, this._nombre, this._perfil, this._status);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: azulp,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.lock_open))],
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
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_nombre.toString(),
                  style: GoogleFonts.sulphurPoint(
                    textStyle: TextStyle(color: azulp),
                  )),
            ),
            Center(
                child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                "assets/images/profile.png",
              ),
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_perfil.toString(),
                  style: GoogleFonts.sulphurPoint(
                    textStyle: TextStyle(color: azulp),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_email.toString(),
                  style: GoogleFonts.sulphurPoint(
                    textStyle: TextStyle(color: azuls),
                  )),
            ),
            TextButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                label: Text('4.86 Evaluación'))
          ],
        ),
      ),
    );
  }
}
