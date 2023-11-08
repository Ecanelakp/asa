import 'package:asamexico/app/compras/catalogoprov_compras.dart';
import 'package:asamexico/app/compras/crearorden_compras.dart';
import 'package:asamexico/app/compras/listaordenes_compra.dart';
import 'package:asamexico/app/variables/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class home_compras extends StatelessWidget {
  const home_compras({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Compras',
            style: GoogleFonts.itim(
              textStyle: TextStyle(),
            )),
        backgroundColor: azulp,
      ),
      backgroundColor: blanco,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
              elevation: 10,
              color: azuls,
              child: ListTile(
                title: Text('Catálogo de proveedores ',
                    style: GoogleFonts.itim(
                      textStyle: TextStyle(color: blanco),
                    )),
                leading: Icon(
                  Icons.person,
                  color: blanco,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => catalogoprov_compras()));
                },
              )),
          Card(
              elevation: 10,
              color: rojo,
              child: ListTile(
                title: Text('Crear orden de compra',
                    style: GoogleFonts.itim(
                      textStyle: TextStyle(color: blanco),
                    )),
                leading: Icon(
                  Icons.shopping_cart_outlined,
                  color: blanco,
                ),
                trailing: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => listaordenes_compra()));
                    },
                    icon: Icon(
                      Icons.list,
                      color: blanco,
                    )),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => crearorden_compra()));
                },
              )),
        ],
      ),
    );
  }
}
