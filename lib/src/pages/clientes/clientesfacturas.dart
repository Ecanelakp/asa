//import 'package:asa_mexico/src/pages/gastos/listagastos.dart';

import 'package:asa_mexico/src/Provider/meselect.dart';
import 'package:provider/provider.dart';

import 'package:asa_mexico/src/pages/clientes/facturasxmes.dart';
import 'package:asa_mexico/src/pages/clientes/totalmes.dart';
import 'package:asa_mexico/src/pages/clientes/ventasxmes.dart';
import 'package:flutter/material.dart';

class Homefacturas extends StatefulWidget {
  final String usuario;

  @override
  const Homefacturas(this.usuario, {Key key}) : super(key: key);

  @override
  _HomefacturasState createState() => _HomefacturasState();
}

class _HomefacturasState extends State<Homefacturas> {
  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: new BoxConstraints.expand(),
        child: ChangeNotifierProvider(
          create: (_) => Meses(),
          child: Stack(children: [
            Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: double.infinity,
                color: Color.fromRGBO(35, 56, 120, 1.0),
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      const SizedBox(height: 20),
                      const Text(
                        'Facturacion del Mes',
                        style: TextStyle(
                          color: Color(0xff827daa),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Pagina(),
                    ],
                  ),
                )),
            Positioned(
              left: 20,
              top: 150.0,
              child: Container(
                height: 80,
                width: 350,
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MesesListView(context),
                )),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.redAccent,
                ),
              ),
            ),
            Positioned(
              left: 20.0,
              top: 250.0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.45,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: MainListView(context),
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white,
                ),
              ),
            ),
          ]),
        ));
  }
}
