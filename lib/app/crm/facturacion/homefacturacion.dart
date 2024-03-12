import 'package:Asamexico/app/variables/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class homefacturacion extends StatelessWidget {
  const homefacturacion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Facturación',
            style: GoogleFonts.itim(
              textStyle: TextStyle(color: blanco),
            )),
        backgroundColor: azulp,
      ),
      backgroundColor: blanco,
      body: Container(
        child: Column(
          children: [
            cabecera(),
            ExpansionTile(title: Text('Lineas')),
            ExpansionTile(title: Text('Pie')),
          ],
        ),
      ),
    );
  }

  ExpansionTile cabecera() {
    return ExpansionTile(
      title: Text('Cabecera'),
      collapsedBackgroundColor: blanco,
      children: [
        ListTile(
          subtitle: Text('Selecciona cliente'),
        )
      ],
    );
  }
}
