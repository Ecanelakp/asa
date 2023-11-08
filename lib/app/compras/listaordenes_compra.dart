import 'package:asamexico/app/compras/crearorden_compras.dart';
import 'package:asamexico/app/compras/pdforden_compra.dart';
import 'package:asamexico/app/compras/previewordenpdf_compras.dart';
import 'package:asamexico/app/variables/colors.dart';
import 'package:asamexico/app/variables/servicesurl.dart';
import 'package:asamexico/models/compras_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class listaordenes_compra extends StatefulWidget {
  const listaordenes_compra({super.key});

  @override
  State<listaordenes_compra> createState() => _listaordenes_compraState();
}

class _listaordenes_compraState extends State<listaordenes_compra> {
  @override
  void initState() {
    super.initState();
    listaproveedoes();
  }

  Future<List<Modellisordenes>> listaproveedoes() async {
    //print('======$notmes======');
    var data = {
      'tipo': 'lista_cab_com',
    };
    // print(data);
    final response = await http.post(urlcompras,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      // print(response.body);

      List<Modellisordenes> studentList = items.map<Modellisordenes>((json) {
        return Modellisordenes.fromJson(json);
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
        title: Text('Lista ordenes de compra',
            style: GoogleFonts.itim(
              textStyle: TextStyle(),
            )),
        backgroundColor: azulp,
      ),
      backgroundColor: blanco,
      body: FutureBuilder<List<Modellisordenes>>(
          future: listaproveedoes(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Container(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                ),
              );

            return ListView(
                children: snapshot.data!
                    .map((data) => Container(
                          child: Card(
                            elevation: 10,
                            child: Row(
                              children: [
                                Flexible(
                                  child: ListTile(
                                    leading: Text(data.id,
                                        style: GoogleFonts.itim(
                                          textStyle: TextStyle(),
                                        )),
                                    title: Text(data.nombre,
                                        style: GoogleFonts.itim(
                                          textStyle: TextStyle(color: azulp),
                                        )),
                                    subtitle: Text(data.comentarios,
                                        style: GoogleFonts.itim(
                                          textStyle: TextStyle(),
                                        )),
                                    trailing: Text(
                                        NumberFormat.simpleCurrency().format(
                                            double.tryParse(
                                                data.total.toString())),
                                        style: GoogleFonts.itim(
                                          textStyle: TextStyle(color: azuls),
                                        )),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    pdforden_compra(
                                                        data.id,
                                                        data.nombre,
                                                        data.fechaRequerida
                                                            .toString(),
                                                        data.referencia,
                                                        data.condicionesPago,
                                                        data.comentarios,
                                                        double.tryParse(
                                                            data.total)!)));
                                      });
                                    },
                                    icon: Icon(
                                      Icons.print,
                                      color: gris,
                                    ))
                              ],
                            ),
                          ),
                        ))
                    .toList());
          }),
    );
  }
}
