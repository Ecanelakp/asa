import 'package:asa_mexico/src/models/models_sistemas.dart';
import 'package:asa_mexico/src/pages/presupuestos/signavances_proyectos.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Avancexdia extends StatelessWidget {
  final String idHolder;
  final String referencia;
  const Avancexdia(this.idHolder, this.referencia);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Avance por dia'),
        backgroundColor: Color.fromRGBO(35, 56, 120, 1.0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('Avance por dia'),
            Expanded(
                flex: 5,
                child: Container(
                    child: Avances(idHolder.toString(), referencia.toString())))
          ],
        ),
      ),
    );
  }
}

class Avances extends StatelessWidget {
  final String idHolder;
  final String referencia;

  const Avances(this.idHolder, this.referencia);

  Future<List<Avancesistemasxd>> jsonsistemasavances() async {
    print(idHolder);
    print(referencia);
    var data = {'idp': idHolder};
    var response = await http.post(
        Uri.parse(
            'https://asamexico.com.mx/php/controller/avancesxdiaproyectos.php'),
        body: json.encode(data));
    print(response);
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      print(items);
      List<Avancesistemasxd> sistemasList = items.map<Avancesistemasxd>((json) {
        return Avancesistemasxd.fromJson(json);
      }).toList();

      return sistemasList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    jsonsistemasavances();
    return FutureBuilder<List<Avancesistemasxd>>(
        future: jsonsistemasavances(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return ListView(
              children: snapshot.data
                  .map((data) => Container(
                          child: Card(
                        child: ListTile(
                          title: Text(data.fecha.toString(),
                              style: (TextStyle(
                                  fontSize: 25,
                                  color: Color.fromRGBO(35, 56, 120, 1.0)))),
                          trailing: Icon(
                            Icons.assignment_outlined,
                            color: Colors.orange,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignAvance()));
                          },
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                data.cantidad.toString(),
                                style: (TextStyle(
                                    fontSize: 30,
                                    color: Color.fromRGBO(35, 56, 120, 1.0))),
                              ),
                              Text("Cantidad",
                                  style: (TextStyle(
                                    fontSize: 10,
                                  )))
                            ],
                          ),
                        ),
                      )))
                  .toList());
        });
  }
}
