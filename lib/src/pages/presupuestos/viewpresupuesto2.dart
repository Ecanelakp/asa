import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
//import 'dart:convert';

class Viewpresupuestos extends StatefulWidget {
  final idp;
  const Viewpresupuestos(this.idp, {Key? key}) : super(key: key);

  @override
  _ViewpresupuestosState createState() => _ViewpresupuestosState();
}

class _ViewpresupuestosState extends State<Viewpresupuestos> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ver proyecto'),
          backgroundColor: Color.fromRGBO(35, 56, 120, 1.0),
        ),
        body: Proyectocaratula(idp: widget.idp),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromRGBO(35, 56, 120, 1.0),
          foregroundColor: Colors.white,
          onPressed: () {
            // Respond to button press
          },
          child: Icon(Icons.add),
        ),
        //bottomNavigationBar: _bottomNavigatoBar(context),
      ),
    );
  }
}

class Proyectocaratula extends StatelessWidget {
  const Proyectocaratula({
    Key? key,
    required this.idp,
  }) : super(key: key);

  final idp;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Viewproyecto(idp: idp),
            SizedBox(
              height: 10,
            ),
            Tareasproyectos(idp: idp),
          ],
        ),
      ),
    );
  }
}

class Tareasproyectos extends StatelessWidget {
  const Tareasproyectos({
    Key? key,
    required this.idp,
  }) : super(key: key);

  final idp;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            width: double.infinity,
            height: double.maxFinite,
            color: Colors.redAccent,
            child: Text("$idp")));
  }
}

class Viewproyecto extends StatelessWidget {
  const Viewproyecto({
    Key? key,
    required this.idp,
  }) : super(key: key);

  final idp;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            width: double.infinity,
            height: 200,
            color: Colors.black26,
            child: Text("$idp")));
  }
}
