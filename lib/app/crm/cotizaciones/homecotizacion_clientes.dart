import 'package:asamexico/app/crm/cotizaciones/altacotizacion_clientes.dart';
import 'package:asamexico/app/crm/cotizaciones/chartcotizacion_clientes.dart';
import 'package:asamexico/app/crm/cotizaciones/pdfcotizacreada_clientes.dart';
import 'package:asamexico/app/variables/colors.dart';
import 'package:asamexico/app/variables/servicesurl.dart';

import 'package:asamexico/models/proyectos_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class homecotizacion_clientes extends StatefulWidget {
  const homecotizacion_clientes({super.key});

  @override
  State<homecotizacion_clientes> createState() =>
      _homecotizacion_clientesState();
}

class _homecotizacion_clientesState extends State<homecotizacion_clientes> {
  @override
  void initState() {
    super.initState();
    listacoti();
  }

  Future<List<Modelliscoti>> listacoti() async {
    //print('======$notmes======');
    var data = {
      'tipo': 'lista_cab_ventas',
    };
    // print(data);
    final response = await http.post(urlventas,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      //print(response.body);

      List<Modelliscoti> studentList = items.map<Modelliscoti>((json) {
        return Modelliscoti.fromJson(json);
      }).toList();
      setState(() {});
      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cotizaciones',
            style: GoogleFonts.itim(textStyle: TextStyle(color: blanco))),
        backgroundColor: azulp,
        actions: [
          Card(
              color: rojo,
              elevation: 10,
              child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => chartcotizacion_clientes()));
                  },
                  icon: Icon(Icons.ssid_chart)))
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: FractionalOffset(0.0, 0.3),
              end: FractionalOffset(0.0, 0.8),
              colors: [
                blanco,
                blanco,
              ]),
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
              BlendMode.modulate,
            ),
            image: AssetImage('assets/images/asablanco.jpg'),
            fit: BoxFit.contain,
          ),
        ),
        child: FutureBuilder<List<Modelliscoti>>(
            future: listacoti(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                  ),
                );

              return ListView(
                  children: snapshot.data!
                      .map((data) => Card(
                            elevation: 10,
                            child: Container(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: ListTile(
                                      onTap: (() {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    pdfcotizacioncreada_clientes(
                                                        data.id,
                                                        data.nombreCliente,
                                                        data.fecha.toString(),
                                                        data.referencia,
                                                        data.condicionesPago,
                                                        data.comentarios,
                                                        double.tryParse(data
                                                            .total
                                                            .toString())!)));
                                      }),
                                      leading: Text(data.referencia,
                                          style: GoogleFonts.itim(
                                              textStyle:
                                                  TextStyle(color: gris))),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(data.comentarios,
                                              style: GoogleFonts.itim(
                                                  textStyle: TextStyle())),
                                          Text(
                                              DateFormat('dd/MM')
                                                  .format(data.fecha),
                                              style: GoogleFonts.itim(
                                                  textStyle: TextStyle())),
                                        ],
                                      ),
                                      title: Text(data.nombreCliente,
                                          style: GoogleFonts.itim(
                                              textStyle:
                                                  TextStyle(color: azulp))),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Card(
                                          elevation: 10,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                  NumberFormat.simpleCurrency()
                                                      .format(double.tryParse(
                                                          data.total
                                                              .toString())),
                                                  style: GoogleFonts.itim(
                                                      textStyle: TextStyle(
                                                          color: azulp))),
                                            ),
                                          )),
                                      Row(
                                        children: [
                                          Card(
                                              elevation: 10,
                                              color: gris,
                                              child: TextButton(
                                                  onPressed: () {},
                                                  child: Text('R',
                                                      style: GoogleFonts.itim(
                                                          textStyle: TextStyle(
                                                              color:
                                                                  blanco))))),
                                          Card(
                                              elevation: 10,
                                              color: rojo,
                                              child: TextButton(
                                                  onPressed: () {},
                                                  child: Text('C',
                                                      style: GoogleFonts.itim(
                                                          textStyle: TextStyle(
                                                              color:
                                                                  blanco))))),
                                          Card(
                                              elevation: 10,
                                              color: azuls,
                                              child: TextButton(
                                                  onPressed: () {},
                                                  child: Text('P',
                                                      style: GoogleFonts.itim(
                                                          textStyle: TextStyle(
                                                              color:
                                                                  blanco))))),
                                          Card(
                                              elevation: 10,
                                              color: azulp,
                                              child: TextButton(
                                                  onPressed: () {},
                                                  child: Text('A',
                                                      style: GoogleFonts.itim(
                                                          textStyle: TextStyle(
                                                              color:
                                                                  blanco))))),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ))
                      .toList());
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: rojo,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => altacotizacion_clientes()));
        },
        child: Icon(
          Icons.add,
          color: blanco,
        ),
      ),
    );
  }
}
