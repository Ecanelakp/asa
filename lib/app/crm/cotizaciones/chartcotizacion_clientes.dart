import 'package:asamexico/app/variables/colors.dart';
import 'package:asamexico/app/variables/servicesurl.dart';
import 'package:asamexico/models/proyectos_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

List<Modelliscoti> chartData = [];

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
      print(response.body);

      List<Modelliscoti> studentList = items.map<Modelliscoti>((json) {
        return Modelliscoti.fromJson(json);
      }).toList();
      setState(() {});
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
        child: FutureBuilder(
            future: listacoti(),
            builder: (context, snapShot) {
              if (snapShot.hasData) {
                return SfCartesianChart(
                    enableAxisAnimation: true,
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(
                        title: AxisTitle(
                          text: 'Ventas MN',
                        ),
                        numberFormat: NumberFormat(),
                        isVisible: MediaQuery.of(context).size.width >= 600
                            ? true
                            : false),
                    //isVisible: false),

                    //primaryXAxis: NumericAxis(isInversed: true),
                    // Chart title
                    title: ChartTitle(text: 'Cotizaciones'),
                    //legend: Legend(isVisible: true),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    //enableSideBySideSeriesPlacement: false,
                    legend: Legend(
                        isVisible: true, position: LegendPosition.bottom),
                    series: <ChartSeries<Modelliscoti, String>>[
                      ColumnSeries<Modelliscoti, String>(
                        dataSource: chartData,

                        xValueMapper: (Modelliscoti sales, _) =>
                            DateFormat('dd/MM/yy').format(sales.fecha),
                        yValueMapper: (Modelliscoti sales, _) =>
                            double.parse(sales.total.toString()),
                        name: "Ventas",
                        color: azulp,
                        animationDuration: 2000,

                        // Enable data label
                        dataLabelSettings: DataLabelSettings(
                            isVisible: true, useSeriesColor: true),
                      )
                      // ColumnSeries<Modellistacabped, String>(
                      //     animationDuration: 4500,
                      //     dataSource: chartData,
                      //     color: cologris2,
                      //     xValueMapper: (Modellistacabped sales, _) => sales.mes,
                      //     yValueMapper: (Modellistacabped sales, _) => sales.utilidad,
                      //     name: "Utilidad",

                      //     // Enable data label
                      //     dataLabelSettings: MediaQuery.of(context).size.width >=
                      //             600
                      //         ? DataLabelSettings(isVisible: true, color: color6)
                      //         : DataLabelSettings(
                      //             isVisible: false,
                      //           ))
                    ]);
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    semanticsLabel: 'Espere por favor',
                    valueColor: AlwaysStoppedAnimation<Color>(gris),
                    backgroundColor: Colors.grey[300],
                  ),
                );
              }
            }),
      ),
    );
  }
}
