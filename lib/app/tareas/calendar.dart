import 'package:Asamexico/app/variables/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class calendar extends StatelessWidget {
  const calendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario',
            style: GoogleFonts.itim(
              textStyle: TextStyle(color: blanco),
            )),
        backgroundColor: azulp,
      ),
      body: Center(
        child: Container(
          child: Text('Calendario',
              style: GoogleFonts.itim(
                textStyle: TextStyle(color: blanco),
              )),
        ),
      ),
    );
  }
}
