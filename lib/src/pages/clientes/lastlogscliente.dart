import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Loglastclientes extends StatelessWidget {
  const Loglastclientes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: 50,
            padding: const EdgeInsets.all(10.0),
            child: Text("Ultimos eventos",
                style: TextStyle(color: Colors.redAccent, fontSize: 14.0))),
        SizedBox(
          height: 5,
        ),
        Container(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Lastlogscliente(),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
            )),
      ],
    );
  }
}

class Lastlogscliente extends StatefulWidget {
  //final String usuario;
  Lastlogscliente();

  @override
  State<StatefulWidget> createState() {
    return Logtareas();
  }
}

class Logstareas {
  int? id;
  dynamic referenciacliente;

  String? usuarioalta;
  String? comentarios;
  String? fechaalta;
  String? nombrecliente;

  Logstareas(
      {this.id,
      this.referenciacliente,
      this.usuarioalta,
      this.comentarios,
      this.fechaalta,
      this.nombrecliente});

  factory Logstareas.fromJson(Map<String, dynamic> json) {
    return Logstareas(
        id: json['ID'],
        referenciacliente: json['Referencia_cliente'],
        usuarioalta: json['Usuario_Alta'],
        comentarios: json['Comentarios'],
        fechaalta: json['Fecha_Alta'],
        nombrecliente: json['Nombre']);
  }
}

class Logtareas extends State<Lastlogscliente> {
  //final String usuario;
  //TextEditingController comentariosctl = TextEditingController();
  //TextEditingController idctl = TextEditingController();
  Logtareas();

  String estado = "";
  bool? error, sending, success;
  String? msg;
  String user = "";
  // API URL
  final apiurl = Uri.parse(
    'https://asamexico.com.mx/php/controller/loglastclientes.php',
  );

  //String user = this.usuario;
  Future<List<Logstareas>?> fetchStudents() async {
    var response = await http.get(apiurl);

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      //print(this.usuario);
      List<Logstareas>? studentList = items.map<Logstareas>((json) {
        return Logstareas.fromJson(json);
      }).toList();

      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Logstareas>?>(
      future: fetchStudents(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return ListView(
          children: snapshot.data!
              .map((data) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Text(data.nombrecliente!,
                            style: TextStyle(
                                color: Color.fromRGBO(35, 56, 120, 1.0),
                                fontSize: 12.0)),
                        Card(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.redAccent),
                            ),
                            child: ListTile(
                              leading: Icon(Icons.comment_bank_outlined,
                                  size: 30.0, color: Colors.redAccent),

                              onTap: () {},
                              // trailing: Icon(Icons.arrow_forward_ios,
                              //     size: 30.0, color: Colors.blue),
                              //Agregamos el nombre con un Widget Text
                              title: Text(data.comentarios!,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14.0)
                                  //le damos estilo a cada texto
                                  ),
                              subtitle: Text(
                                  'Fecha: ' +
                                      data.fechaalta! +
                                      '  @' +
                                      data.usuarioalta!,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color.fromRGBO(35, 56, 120, 0.8))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        );
      },
    );
  }
}
