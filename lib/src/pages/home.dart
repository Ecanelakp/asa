// import 'package:asa_mexico/src/pages/presupuestos/presupuestos_home.dart';
import 'package:asa_mexico/src/pages/gastos/homegastos.dart';
import 'package:asa_mexico/src/pages/materiales/homemateriales.dart';
import 'package:asa_mexico/src/pages/personal/homepersonal.dart';
import 'package:asa_mexico/src/pages/presupuestos/presupuestos_home.dart';
import 'package:asa_mexico/src/pages/pruebas/pruebas.dart';

//import 'package:asa_mexico/src/pages/presupuestos/presupuestos_home2.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';

import 'clientes/viewclientes.dart';

class Homepage extends StatelessWidget {
  final String usuario;
  final String acceso;
  const Homepage(this.usuario, this.acceso, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            _fondoApp(),
            SingleChildScrollView(
              child: _botonesRedondeados(context, usuario, acceso),
            ),
          ],
        ),
        //bottomNavigationBar: _bottomNavigatoBar(context),
      ),
    );
  }
}

Widget _fondoApp() {
  final gradiente = Container(
    width: double.infinity,
    height: double.infinity,
    decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: FractionalOffset(0.0, 0.6),
            end: FractionalOffset(0.0, 1.0),
            colors: [
          Color.fromRGBO(35, 56, 120, 1.0),
          Color.fromRGBO(35, 37, 57, 1.0)
        ])),
  );

  final cajaRosa = Transform.rotate(
    angle: -pi / 10.0,
    child: Container(
      height: 230.0,
      width: 230.0,
      child: Image(
          image: AssetImage('assets/images/asaazul.jpg'), fit: BoxFit.cover),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80.0),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(235, 73, 52, 1.0),
            Color.fromRGBO(35, 56, 120, 1.0)
          ])),
    ),
  );

  final cajaRosa1 = Transform.rotate(
    angle: -pi / 10.0,
    child: Container(
      height: 230.0,
      width: 230.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80.0),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(235, 73, 52, 1.0),
            Color.fromRGBO(35, 56, 120, 1.0)
          ])),
    ),
  );

  return Stack(
    children: [
      gradiente,
      Positioned(top: -50.0, left: 80, child: cajaRosa),
      Positioned(top: 600.0, left: 200, child: cajaRosa1),
      Positioned(top: 300.0, left: 0, child: cajaRosa1)
    ],
  );
}

Widget _botonesRedondeados(context, usuario, acceso) {
  return Table(children: [
    TableRow(children: [
      SizedBox(
        height: 120,
      ),
      SizedBox(
        height: 120,
      ),
    ]),
    TableRow(children: [
      GestureDetector(
        onTap: () => {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Presupuestos2(usuario))),
        },
        child: _crearBotonRedondeado(Color.fromRGBO(255, 255, 255, 1.0),
            Icons.construction, 'Proyectos'),
      ),
      GestureDetector(
        onTap: () => {
          print(acceso),
          if (acceso == 'full')
            {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Homegastos(usuario)))
            }
          else
            {print(acceso)}
        },
        child: _crearBotonRedondeado(Color.fromRGBO(255, 255, 255, 1.0),
            Icons.account_balance_rounded, 'Gastos'),
      )
    ]),
    TableRow(children: [
      GestureDetector(
        onTap: () => {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Materialespage()))
        },
        child: _crearBotonRedondeado(Color.fromRGBO(255, 255, 255, 1.0),
            Icons.blur_circular_rounded, 'Materiales'),
      ),
      GestureDetector(
        onTap: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Clienteview(usuario, acceso))),
        },
        child: _crearBotonRedondeado(Color.fromRGBO(255, 255, 255, 1.0),
            Icons.radio_button_checked_outlined, 'Clientes'),
      ),
    ]),
    TableRow(
      children: [
        GestureDetector(
            onTap: () => {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => MyApp())),
                },
            child: _crearBotonRedondeado(Color.fromRGBO(255, 255, 255, 1.0),
                Icons.assignment, 'Sistemas')),
        GestureDetector(
            onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Homepersonal(acceso: acceso))),
                },
            child: _crearBotonRedondeado(Color.fromRGBO(255, 255, 255, 1.0),
                Icons.account_circle, 'Personal')),
      ],
    )
  ]);
}

Widget _crearBotonRedondeado(Color color, IconData icon, String texto) {
  return BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 0.1, sigmaY: 0.1),
    child: Container(
      height: 180.0,
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 0.1),
          borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(height: 5.0),
          CircleAvatar(
            backgroundColor: color,
            radius: 35.0,
            child:
                Icon(icon, color: Color.fromRGBO(235, 73, 52, 1.0), size: 40.0),
          ),
          Text(
            texto,
            style: TextStyle(color: color),
          ),
          SizedBox(
            height: 5.0,
          )
        ],
      ),
    ),
  );
}
