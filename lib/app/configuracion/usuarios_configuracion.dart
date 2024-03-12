import 'package:Asamexico/app/variables/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class usuarios_configuracion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: gris,
        title: Text('Control de usuarios',
            style: GoogleFonts.sulphurPoint(
              textStyle: TextStyle(color: blanco),
            )),
      ),
      backgroundColor: blanco,
      body: Container(
        child: Center(child: Text('Aqui veras la lista de usuarios ')),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: azuls,
        onPressed: () {
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => alta_productos()));
        },
        child: Icon(
          Icons.add,
          color: blanco,
        ),
      ),
    );
  }
}
