import 'package:Asamexico/app/variables/colors.dart';
import 'package:Asamexico/app/variables/servicesurl.dart';
import 'package:Asamexico/models/proyectos_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

List<Modelliscoti> chartData = [];
String _status = '4';
Color _color = azulp;
double _total = 0;
bool _todas = true;

class chartcotizacion_clientes extends StatefulWidget {
  const chartcotizacion_clientes({super.key});

  @override
  State<chartcotizacion_clientes> createState() =>
      _chartcotizacion_clientesState();
}

class _chartcotizacion_clientesState extends State<chartcotizacion_clientes> {
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
      // print(response.body);

      List<Modelliscoti> studentList = items.map<Modelliscoti>((json) {
        return Modelliscoti.fromJson(json);
      }).toList();
      setState(() {
        _total = 0.00;

        for (var p in studentList) {
          _total += (double.parse(p.total.toString()));
        }
      });
      // setState(() {});
      chartData = items.map<Modelliscoti>((json) {
        return Modelliscoti.fromJson(json);
      }).toList();
      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Graficos',
            style: GoogleFonts.itim(textStyle: TextStyle(color: blanco))),
        backgroundColor: azulp,
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
            // Expanded(
            //   child: FutureBuilder(
            //       future: listacoti(),
            //       builder: (context, snapShot) {
            //         if (snapShot.hasData) {
            //           return SfCartesianChart(
            //               enableAxisAnimation: true,
            //               primaryXAxis: CategoryAxis(),
            //               primaryYAxis: NumericAxis(
            //                   title: AxisTitle(
            //                     text: 'Ventas MN',
            //                   ),
            //                   numberFormat: NumberFormat(),
            //                   isVisible:
            //                       MediaQuery.of(context).size.width >= 600
            //                           ? true
            //                           : false),
            //               //isVisible: false),

            //               //primaryXAxis: NumericAxis(isInversed: true),
            //               // Chart title
            //               title: ChartTitle(text: 'Cotizaciones'),
            //               //legend: Legend(isVisible: true),
            //               tooltipBehavior: TooltipBehavior(enable: true),
            //               //enableSideBySideSeriesPlacement: false,
            //               legend: Legend(
            //                   isVisible: true, position: LegendPosition.bottom),
            //               series: <ChartSeries<Modelliscoti, String>>[
            //                 StackedColumnSeries<Modelliscoti, String>(
            //                   dataSource: chartData,

            //                   xValueMapper: (Modelliscoti sales, _) =>
            //                       DateFormat('dd/MM').format(sales.fecha),
            //                   yValueMapper: (Modelliscoti sales, _) =>
            //                       double.parse(sales.total.toString()),
            //                   name: "Cotizaciones",
            //                   color: _color,
            //                   animationDuration: 2000,

            //                   // Enable data label
            //                   dataLabelSettings: DataLabelSettings(
            //                       isVisible: true, useSeriesColor: true),
            //                 )
            //                 // ColumnSeries<Modellistacabped, String>(
            //                 //     animationDuration: 4500,
            //                 //     dataSource: chartData,
            //                 //     color: cologris2,
            //                 //     xValueMapper: (Modellistacabped sales, _) => sales.mes,
            //                 //     yValueMapper: (Modellistacabped sales, _) => sales.utilidad,
            //                 //     name: "Utilidad",

            //                 //     // Enable data label
            //                 //     dataLabelSettings: MediaQuery.of(context).size.width >=
            //                 //             600
            //                 //         ? DataLabelSettings(isVisible: true, color: color6)
            //                 //         : DataLabelSettings(
            //                 //             isVisible: false,
            //                 //           ))
            //               ]);
            //         } else {
            //           return Center(
            //             child: CircularProgressIndicator(
            //               semanticsLabel: 'Espere por favor',
            //               valueColor: AlwaysStoppedAnimation<Color>(gris),
            //               backgroundColor: Colors.grey[300],
            //             ),
            //           );
            //         }
            //       }),
            // ),
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
                        _color = azulp;
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
    );
  }
}
