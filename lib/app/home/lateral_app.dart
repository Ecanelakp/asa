import 'package:asamexico/app/Productos/home_productos.dart';
import 'package:asamexico/app/clientes/home_clientes.dart';
import 'package:asamexico/app/home/home_app.dart';
import 'package:asamexico/app/proyectos/home_proyectos.dart';
import 'package:asamexico/app/variables/colors.dart';
import 'package:asamexico/app/variables/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class menulateral extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      //backgroundColor: azulp,
      // Agrega un ListView al drawer. Esto asegura que el usuario pueda desplazarse
      // a través de las opciones en el Drawer si no hay suficiente espacio vertical
      // para adaptarse a todo.
      child: ListView(
        // Importante: elimina cualquier padding del ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Container(
              child: Center(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: azuls,
                    child: Icon(
                      Icons.person,
                      color: blanco,
                    ),
                  ),
                  subtitle: Text(
                    perfil.toUpperCase(),
                    style: GoogleFonts.itim(textStyle: TextStyle(color: rojo)),
                  ),
                  title: Text(
                    nombre,
                    style:
                        GoogleFonts.itim(textStyle: TextStyle(color: blanco)),
                  ),
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: azulp,
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                  Color.fromARGB(200, 245, 245, 245).withOpacity(0.2),
                  BlendMode.modulate,
                ),
                image: AssetImage('assets/images/asaazul.jpg'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Card(
            elevation: 10,
            child: ListTile(
                leading: Icon(
                  Icons.home,
                  color: azuls,
                ),
                title: Text('Inicio',
                    style: GoogleFonts.itim(
                      textStyle: TextStyle(),
                    )),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Home_app()));
                  //Navigator.pop(context);
                }),
          ),
          Card(
            elevation: 10,
            child: ListTile(
                leading: Icon(
                  Icons.whatshot,
                  color: azuls,
                ),
                title: Text('Proyectos',
                    style: GoogleFonts.itim(
                      textStyle: TextStyle(),
                    )),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => home_proyectos()));
                  //Navigator.pop(context);
                }),
          ),
          Card(
            elevation: 10,
            child: ListTile(
              leading: Icon(
                Icons.abc,
                color: azuls,
              ),
              title: Text('Productos',
                  style: GoogleFonts.itim(
                    textStyle: TextStyle(),
                  )),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => home_productos()));
                //  Navigator.pop(context);
              },
            ),
          ),
          Card(
            elevation: 10,
            child: ListTile(
              leading: Icon(
                Icons.person,
                color: azuls,
              ),
              title: Text('Clientes',
                  style: GoogleFonts.itim(
                    textStyle: TextStyle(),
                  )),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => home_clientes()));
              },
            ),
          ),
          ListTile(
            title: Text('Cerrar session',
                style: GoogleFonts.itim(
                  textStyle: TextStyle(color: Colors.redAccent),
                )),
            onTap: () {
              // // Actualiza el estado de la aplicación
              // ...
              // Luego cierra el drawer
              Navigator.of(context).popUntil((route) => route.isFirst);
              // Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
