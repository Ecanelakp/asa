import 'package:asa_mexico/src/Provider/meselect.dart';
import 'package:asa_mexico/src/pages/clientes/detallefactura.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Studentdata {
  int idrecepcion;
  dynamic rfcemisor;
  dynamic nemisor;
  dynamic folio;
  dynamic uuid;
  dynamic total;
  String metodop;
  int pagada;
  dynamic fecha;

  Studentdata({
    this.idrecepcion,
    this.rfcemisor,
    this.nemisor,
    this.folio,
    this.uuid,
    this.total,
    this.metodop,
    this.pagada,
    this.fecha,
  });

  factory Studentdata.fromJson(Map<String, dynamic> json) {
    return Studentdata(
        idrecepcion: json['id_recepcion'],
        rfcemisor: json['rfc_emisor'],
        nemisor: json['nombre_receptor'],
        folio: json['folio'],
        uuid: json['uuid'],
        total: json['total'],
        metodop: json['metodop'],
        pagada: json['Pagada'],
        fecha: json['fecha']);
  }
}

class MainListView extends StatefulWidget {
  MainListView(BuildContext context);

  MainListViewState createState() => MainListViewState();
}

int nmes;

class MainListViewState extends State {
  final apiurl = Uri.parse(
    'https://asamexico.com.mx/php/controller/ventasxmes.php',
  );

  //String user = this.usuario;
  Future<List<Studentdata>> fetchStudents() async {
    var data = {'nmes': nmes.toString()};
    var response = await http.post(apiurl, body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      //print(this.usuario);
      List<Studentdata> studentList = items.map<Studentdata>((json) {
        return Studentdata.fromJson(json);
      }).toList();

      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final wmes = Provider.of<Meses>(context);
    nmes = wmes.mes;
    fetchStudents();
    return FutureBuilder<List<Studentdata>>(
      future: fetchStudents(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return ListView(
          children: snapshot.data
              .map((data) => Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  //Centramos con el Widget <a href="https://zimbronapps.com/flutter/center/">Center</a>
                  child: Card(
                    color: Colors.white,
                    child: ListTile(
                        leading: Icon(Icons.monetization_on_outlined,
                            size: 30.0,
                            color: Color.fromRGBO(35, 56, 120, 1.0)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Factura:" + data.folio.toString(),
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 12.0)),
                            Text(
                                "Total: \u0024 " +
                                    NumberFormat.currency(locale: 'es-mx')
                                        .format(data.total),
                                style: TextStyle(color: Colors.redAccent)),
                            Text("Fecha: " + data.fecha,
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 11.0)),
                          ],
                        ),
                        onTap: () {
                          print(data.uuid);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Detallesfactura(data.uuid)));
                        },
                        trailing: iconcolor(data.pagada),

                        //Agregamos el nombre con un Widget Text
                        title: Text(data.nemisor,
                            style: TextStyle(
                                color: Color.fromRGBO(35, 56, 120, 1.0),
                                fontSize: 14.0)
                            //le damos estilo a cada texto
                            )),
                  )))
              .toList(),
        );
      },
    );
  }

  iconcolor(int pagada) {
    print(pagada.toString());
    if (pagada == 1) {
      return Icon(Icons.check_circle, size: 30.0, color: Colors.green);
    } else if (pagada == 3) {
      return Icon(Icons.close_rounded, size: 30.0, color: Colors.red);
    } else {
      return Icon(Icons.blur_circular, size: 30.0, color: Colors.orange);
    }
  }
}
