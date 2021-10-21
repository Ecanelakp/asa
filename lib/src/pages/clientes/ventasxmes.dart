import 'package:asa_mexico/src/Provider/meselect.dart';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Mesesc {
  dynamic mes;
  dynamic nmes;
  dynamic total;

  Mesesc({
    this.mes,
    this.nmes,
    this.total,
  });

  factory Mesesc.fromJson(Map<String, dynamic> json) {
    return Mesesc(nmes: json['nmes'], mes: json['mes'], total: json['total']);
  }
}

class MesesListView extends StatefulWidget {
  MesesListView(BuildContext context);

  MesesListViewState createState() => MesesListViewState();
}

class MesesListViewState extends State {
  final apiurl = Uri.parse(
    'https://asamexico.com.mx/php/controller/ventasmesames.php',
  );

  //String user = this.usuario;
  Future<List<Mesesc>> mesesc() async {
    var response = await http.get(apiurl);

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      //print(this.usuario);
      List<Mesesc> studentList = items.map<Mesesc>((json) {
        return Mesesc.fromJson(json);
      }).toList();

      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final wmes = Provider.of<Meses>(context);
    return FutureBuilder<List<Mesesc>>(
      future: mesesc(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return ListView(
          scrollDirection: Axis.horizontal,
          children: snapshot.data
              .map(
                (data) => Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    //Centramos con el Widget <a href="https://zimbronapps.com/flutter/center/">Center</a>
                    child: ListTile(
                        leading: Icon(Icons.monetization_on_outlined,
                            color: Colors.white),
                        title: Text(
                            NumberFormat.currency(locale: 'es-mx')
                                .format(data.total),
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          wmes.mes = data.nmes;
                          setState(() {});
                          //print(data.nmes);
                        },
                        subtitle: Text(data.mes,
                            style: TextStyle(color: Colors.white60)
                            //le damos estilo a cada texto
                            ))),
              )
              .toList(),
        );
      },
    );
  }
}
