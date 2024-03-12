import 'package:Asamexico/app/compras/catalogoprov_compras.dart';
import 'package:Asamexico/app/compras/crearorden_compras.dart';
import 'package:Asamexico/app/compras/listaordenes_compra.dart';
import 'package:Asamexico/app/variables/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class home_compras extends StatelessWidget {
  const home_compras({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ordenes de compra',
            style: GoogleFonts.itim(
              textStyle: TextStyle(),
            )),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => catalogoprov_compras()));
              },
              icon: Icon(
                Icons.person,
                color: blanco,
              ))
        ],
        backgroundColor: azulp,
      ),
      backgroundColor: blanco,
      body: listaordenes_compra(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: rojo,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => crearorden_compra()));
        },
        child: Icon(
          Icons.add,
          color: blanco,
        ),
      ),
    );
  }
}
