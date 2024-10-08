import 'package:Asamexico/app/Productos/home_productos.dart';
import 'package:Asamexico/app/configuracion/home_configuracion.dart';
import 'package:Asamexico/app/crm/cotizaciones/homecotizacion_clientes.dart';
import 'package:Asamexico/app/crm/clientes/home_clientes.dart';
import 'package:Asamexico/app/compras/home_compras.dart';
import 'package:Asamexico/app/crm/facturacion/Altafactura_facturacion.dart';
import 'package:Asamexico/app/crm/facturacion/home_facturacion.dart';
import 'package:Asamexico/app/home/home_app.dart';
import 'package:Asamexico/app/personal/home_personal.dart';
import 'package:Asamexico/app/proyectos/home_proyectos.dart';
import 'package:Asamexico/app/variables/colors.dart';
import 'package:Asamexico/app/variables/variables.dart';
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
                child: Card(
                  color: Colors.black38,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: azulp,
                      child: Icon(
                        Icons.person,
                        color: blanco,
                      ),
                    ),
                    subtitle: Text(
                      perfil.toUpperCase(),
                      style:
                          GoogleFonts.itim(textStyle: TextStyle(color: rojo)),
                    ),
                    title: Text(
                      nombre,
                      style:
                          GoogleFonts.itim(textStyle: TextStyle(color: blanco)),
                    ),
                  ),
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: azulp,
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                  Color.fromARGB(200, 245, 245, 245).withOpacity(0.4),
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
            child: ExpansionTile(
              leading: Icon(
                Icons.dashboard_customize,
                color: rojo,
              ),
              title: Text('CRM',
                  style: GoogleFonts.itim(
                    textStyle: TextStyle(),
                  )),
              children: [
                Card(
                  elevation: 10,
                  child: ListTile(
                    leading: Icon(
                      Icons.person,
                      color: azulp,
                    ),
                    title: Text('Clientes',
                        style: GoogleFonts.itim(
                          textStyle: TextStyle(),
                        )),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => home_clientes()));
                    },
                  ),
                ),
                Card(
                  elevation: 10,
                  child: ListTile(
                    leading: Icon(
                      Icons.request_quote,
                      color: azulp,
                    ),
                    title: Text('Cotizaciones',
                        style: GoogleFonts.itim(
                          textStyle: TextStyle(),
                        )),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => homecotizacion_clientes()));
                    },
                  ),
                ),
                Card(
                  elevation: 10,
                  child: ListTile(
                    leading: Icon(
                      Icons.request_quote_outlined,
                      color: azulp,
                    ),
                    title: Text('Facturación',
                        style: GoogleFonts.itim(
                          textStyle: TextStyle(),
                        )),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => homefacturacion()));
                    },
                  ),
                ),
              ],
            ),
          ),
          Card(
            elevation: 10,
            child: ListTile(
                leading: Icon(
                  Icons.shopping_cart,
                  color: azuls,
                ),
                title: Text('Compras',
                    style: GoogleFonts.itim(
                      textStyle: TextStyle(),
                    )),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => home_compras()));
                  //Navigator.pop(context);
                }),
          ),
          Card(
            elevation: 10,
            child: ListTile(
                leading: Icon(
                  Icons.person_4,
                  color: azuls,
                ),
                title: Text('Personal',
                    style: GoogleFonts.itim(
                      textStyle: TextStyle(),
                    )),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => home_personal()));
                  //Navigator.pop(context);
                }),
          ),
          SizedBox(
            height: 30,
          ),
          Card(
            elevation: 10,
            child: ListTile(
                leading: Icon(
                  Icons.settings,
                  color: gris,
                ),
                title: Text('Configuración',
                    style: GoogleFonts.itim(
                      textStyle: TextStyle(),
                    )),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => home_configuracion()));
                  //Navigator.pop(context);
                }),
          ),
          SizedBox(
            height: 30,
          ),
          ListTile(
            title: Text('Cerrar session',
                style: GoogleFonts.itim(
                  textStyle: TextStyle(color: rojo),
                )),
            leading: Icon(
              Icons.exit_to_app,
              color: rojo,
            ),
            onTap: () {
              // // Actualiza el estado de la aplicación
              // ...
              // Luego cierra el drawer
              Navigator.of(context).popUntil((route) => route.isFirst);
              // Navigator.pop(context);
            },
          ),
          SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(version,
                  style: GoogleFonts.itim(
                    textStyle: TextStyle(color: gris, fontSize: 8),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
