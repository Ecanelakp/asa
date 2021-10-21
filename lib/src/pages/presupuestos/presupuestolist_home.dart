import 'dart:convert';

import 'package:asa_mexico/src/pages/presupuestos/viewpresupuesto2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListProyectos extends StatefulWidget {
  //const ListProyectos({Key key}) : super(key: key);

  @override
  _ListProyectosState createState() => _ListProyectosState();
}

class _ListProyectosState extends State<ListProyectos> {
  List data;
  Future myFuture;
  final url = Uri.parse(
    'https://asamexico.com.mx/php/controller/clientes.php?op=GetProyectos',
  );
  Future<String> getData() async {
    var response = await http.get(url);

    this.setState(() {
      data = json.decode(response.body);
    });

    print(data[1]["id"]);

    return "Success!";
  }

  @override
  void initState() {
    myFuture = getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: myFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return new ListView.builder(
            itemCount: data == null ? 0 : data.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: new Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          //print(data[index]["id"]);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Viewpresupuestos(data[index]["id"])));
                        },
                        leading: Icon(Icons.construction,
                            color: Color.fromRGBO(35, 56, 120, 1.0)),
                        title: Text(data[index]["Proyecto"],
                            style: TextStyle(
                                color: Color.fromRGBO(35, 56, 120, 1.0))),
                        subtitle: Text(data[index]["Referencia"]),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        // tileColor: Color.fromRGBO(35, 56, 120, 1.0),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Responsable: ",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Color.fromRGBO(35, 56, 120, 1.0))),
                            Text(data[index]["Responsable"]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}
