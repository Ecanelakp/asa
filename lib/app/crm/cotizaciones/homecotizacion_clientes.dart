import 'package:Asamexico/app/crm/cotizaciones/altacotizacion_clientes.dart';
import 'package:Asamexico/app/crm/cotizaciones/chartcotizacion_clientes.dart';
import 'package:Asamexico/app/crm/cotizaciones/pdfcotizacreada_clientes.dart';
import 'package:Asamexico/app/variables/colors.dart';
import 'package:Asamexico/app/variables/servicesurl.dart';

import 'package:Asamexico/models/proyectos_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

String _status = '4';
Color _color = azulp;
double _total = 0;
bool _todas = true;

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
      'tipo': _status == '' ? 'lista_cab_ventas' : 'lista_cab_ventas_status',
      'status': _status
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

      setState(() {
        _total = 0.00;

        for (var p in studentList) {
          _total += (double.parse(p.total.toString()));
        }
      });
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
        child: Column(
          children: [
            Expanded(
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
                                          flex: 2,
                                          child: ListTile(
                                            onTap: (() {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          pdfcotizacioncreada_clientes(
                                                              data.id,
                                                              data
                                                                  .nombreCliente,
                                                              data.fecha
                                                                  .toString(),
                                                              data.referencia,
                                                              data
                                                                  .condicionesPago,
                                                              data.comentarios,
                                                              double.tryParse(data
                                                                  .total
                                                                  .toString())!)));
                                            }),
                                            leading: Text(data.referencia,
                                                style: GoogleFonts.itim(
                                                    textStyle: TextStyle(
                                                        color: gris))),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(data.comentarios,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.itim(
                                                        textStyle:
                                                            TextStyle())),
                                                Text(
                                                    DateFormat('dd/MM')
                                                        .format(data.fecha),
                                                    style: GoogleFonts.itim(
                                                        textStyle:
                                                            TextStyle())),
                                              ],
                                            ),
                                            title: Text(data.nombreCliente,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.itim(
                                                    textStyle: TextStyle(
                                                        color: azulp))),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Card(
                                                  elevation: 10,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                          NumberFormat
                                                                  .simpleCurrency()
                                                              .format(double
                                                                  .tryParse(data
                                                                      .total
                                                                      .toString())),
                                                          style: GoogleFonts.itim(
                                                              textStyle: TextStyle(
                                                                  color:
                                                                      azulp))),
                                                    ),
                                                  )),
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      status(data.id, '2');
                                                    },
                                                    child: Card(
                                                        elevation: 10,
                                                        color:
                                                            data.status == '2'
                                                                ? rojo
                                                                : blanco,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text('C',
                                                              style: GoogleFonts.itim(
                                                                  textStyle: TextStyle(
                                                                      color: data.status ==
                                                                              '2'
                                                                          ? blanco
                                                                          : rojo))),
                                                        )),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      status(data.id, '1');
                                                    },
                                                    child: Card(
                                                        elevation: 10,
                                                        color:
                                                            data.status == '1'
                                                                ? gris
                                                                : blanco,
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text('R',
                                                                style: GoogleFonts.itim(
                                                                    textStyle: TextStyle(
                                                                        color: data.status ==
                                                                                '1'
                                                                            ? blanco
                                                                            : gris))))),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      status(data.id, '3');
                                                    },
                                                    child: Card(
                                                        elevation: 10,
                                                        color:
                                                            data.status == '3'
                                                                ? azuls
                                                                : blanco,
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text('P',
                                                                style: GoogleFonts.itim(
                                                                    textStyle: TextStyle(
                                                                        color: data.status ==
                                                                                '3'
                                                                            ? blanco
                                                                            : azuls))))),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      status(data.id, '4');
                                                    },
                                                    child: Card(
                                                        elevation: 10,
                                                        color:
                                                            data.status == '4'
                                                                ? azulp
                                                                : blanco,
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text('A',
                                                                style: GoogleFonts.itim(
                                                                    textStyle: TextStyle(
                                                                        color: data.status ==
                                                                                '4'
                                                                            ? blanco
                                                                            : azulp))))),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ))
                            .toList());
                  }),
            ),
            Container(
              color: azulp,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _todas = true;
                        _status = '';
                      });
                    },
                    child: Card(
                        elevation: 10,
                        color: gris,
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.list,
                              color: blanco,
                            ))),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _status = '2';
                        _color = rojo;
                      });
                    },
                    child: Card(
                        elevation: 10,
                        color: _status == '2' ? rojo : blanco,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('C',
                              style: GoogleFonts.itim(
                                  textStyle: TextStyle(
                                      color: _status == '2' ? blanco : rojo))),
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _status = '1';
                        _color = gris;
                      });
                    },
                    child: Card(
                        elevation: 10,
                        color: _status == '1' ? gris : blanco,
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('R',
                                style: GoogleFonts.itim(
                                    textStyle: TextStyle(
                                        color:
                                            _status == '1' ? blanco : gris))))),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _status = '3';
                        _color = azuls;
                      });
                    },
                    child: Card(
                        elevation: 10,
                        color: _status == '3' ? azuls : blanco,
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('P',
                                style: GoogleFonts.itim(
                                    textStyle: TextStyle(
                                        color: _status == '3'
                                            ? blanco
                                            : azuls))))),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _status = '4';
                        _color = azulp;
                      });
                    },
                    child: Card(
                        elevation: 10,
                        color: _status == '4' ? azulp : blanco,
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('A',
                                style: GoogleFonts.itim(
                                    textStyle: TextStyle(
                                        color: _status == '4'
                                            ? blanco
                                            : azulp))))),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(NumberFormat.simpleCurrency().format(_total),
                      style: GoogleFonts.itim(
                        textStyle: TextStyle(color: blanco),
                      )),
                ],
              ),
            ),
          ],
        ),
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

  Future status(String _id, String _status) async {
    var data = {
      'tipo': 'cabecera_status',
      'status': _status,
      'id': _id,
    };
    print(data);

    var res = await http.post(urlventas,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    print(res.body);
    setState(() {
      listacoti();
    });
  }
}
