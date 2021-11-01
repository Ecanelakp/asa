import 'package:asa_mexico/src/pages/clientes/logsclientes.dart';
//import 'package:asa_mexico/src/pages/clientes/lastlogscliente.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Listaclientes extends StatelessWidget {
  final String usuario;
  @override
  const Listaclientes(this.usuario, {Key? key}) : super(key: key);
  Widget build(BuildContext context) {
    return Center(
      child: MainListView(context),
    );
  }
}

class Studentdata {
  dynamic id;
  dynamic referencia;
  String? cliente;
  String? contacto;
  String? puesto;

  Studentdata(
      {this.id, this.referencia, this.cliente, this.contacto, this.puesto});

  factory Studentdata.fromJson(Map<String, dynamic> json) {
    return Studentdata(
        id: json['id'],
        referencia: json['Referencia'],
        cliente: json['Nombre'],
        contacto: json['Contacto'],
        puesto: json['Puesto']);
  }
}

class MainListView extends StatefulWidget {
  MainListView(BuildContext context);

  MainListViewState createState() => MainListViewState();
}

class MainListViewState extends State {
  final apiurl = Uri.parse(
    'https://asamexico.com.mx/php/controller/clientes.php?op=GetClientes',
  );

  //String user = this.usuario;
  Future<List<Studentdata>?> fetchStudents() async {
    var response = await http.get(apiurl);

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      //print(this.usuario);
      List<Studentdata>? studentList = items.map<Studentdata>((json) {
        return Studentdata.fromJson(json);
      }).toList();

      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Studentdata>?>(
      future: fetchStudents(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return ListView(
          children: snapshot.data!
              .map((data) => Card(
                    color: Colors.white,
                    child: ListTile(
                        leading: Icon(Icons.account_circle_sharp,
                            size: 30.0,
                            color: Color.fromRGBO(35, 56, 120, 1.0)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 8,
                            ),
                            Text("Referencia: " + data.referencia.toString(),
                                style: TextStyle(color: Colors.black54)),
                            Text("Contacto: " + data.contacto!,
                                style: TextStyle(color: Colors.black54)),
                            SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                        onTap: () {
                          print(data.id);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CclientesState(data.id)));
                        },
                        trailing: Icon(Icons.arrow_forward_ios,
                            size: 30.0, color: Colors.redAccent),
                        //Agregamos el nombre con un Widget Text
                        title: Text(data.cliente!,
                            style: TextStyle(
                                color: Color.fromRGBO(35, 56, 120, 1.0),
                                fontSize: 14.0)
                            //le damos estilo a cada texto
                            )),
                  ))
              .toList(),
        );
      },
    );
  }
}
