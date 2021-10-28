import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Checkgastos extends StatefulWidget {
  final String id;
  Checkgastos(this.id);

  @override
  _CheckgastosState createState() => _CheckgastosState();
}

class _CheckgastosState extends State<Checkgastos> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              "Confirma los gastos",
              style: (TextStyle(
                  fontSize: 14, color: Color.fromRGBO(35, 56, 120, 1.0))),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color.fromRGBO(35, 56, 120, 1.0)),
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
              ),
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width * 0.95,
              child: Cargamateriales(id: widget.id),
            ),
          ],
        ),
      ),
    );
  }
}

class Listamaterial {
  String? gasto;
  String? comentario;

  double? monto;
  int? id;

  Listamaterial({this.gasto, this.comentario, this.monto, this.id});
  factory Listamaterial.fromJson(Map<String, dynamic> json) {
    return Listamaterial(
        gasto: json['Gasto'],
        comentario: json['Comentario'],
        monto: json['Monto'].toDouble(),
        id: json['id']);
  }
}

class Cargamateriales extends StatefulWidget {
  final String? id;
  @override
  Cargamateriales({this.id});

  @override
  _CargamaterialesState createState() => _CargamaterialesState();
}

class _CargamaterialesState extends State<Cargamateriales> {
  TextEditingController comentarioctl = new TextEditingController();
  final apiurl = Uri.parse(
    'https://asamexico.com.mx/php/controller/checkgastosproyecto.php',
  );

  Future<List<Listamaterial>?> fetchStudents() async {
    var data = {'id': ("${widget.id}")};
    print('========$data=======');

    var response = await http.post(apiurl, body: json.encode(data));

    //var response = await http.get(apiurl);

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      print(response.body);
      List<Listamaterial>? studentList = items.map<Listamaterial>((json) {
        return Listamaterial.fromJson(json);
      }).toList();

      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Listamaterial>?>(
        future: fetchStudents(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return ListView(
              children: snapshot.data!
                  .map(
                    (data) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ExpansionTile(
                          leading: IconButton(
                              icon: Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                print(data.id);
                                aceptarmate(
                                    ids: data.id,
                                    comentarios: comentarioctl.text);
                                setState(() {
                                  Cargamateriales();
                                  comentarioctl.clear();
                                });
                              }),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 12.0,
                                      color: Colors.black),
                                  controller: comentarioctl,
                                  decoration: new InputDecoration(
                                    hintText: "Agrega comentarios",
                                  )),
                            ),
                          ],
                          subtitle: Text(data.comentario!,
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14.0,
                                  color: Colors.blueAccent)),
                          trailing: IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                print(data.id);
                                print(comentarioctl.text);
                                rechazarmate(
                                    ids: data.id,
                                    comentarios: comentarioctl.text);
                                setState(() {
                                  Cargamateriales();
                                  comentarioctl.clear();
                                });
                              }),
                          //Agregamos el nombre con un Widget Text
                          title: Text(
                              data.gasto! + ' Monto: ' + data.monto.toString(),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14.0)
                              //le damos estilo a cada texto
                              ),
                        ),
                      ),
                    ),
                  )
                  .toList());
        });
  }

  Future<void> rechazarmate({int? ids, String? comentarios}) async {
    String id = ids.toString();
    // final urlinsert = Uri.parse(
    //   'https://asamexico.com.mx/php/controller/categoria.php?op=Insert');
    print('===$id======');
    print('===$comentarios======');
    final apiurl = Uri.parse(
      'https://asamexico.com.mx/php/controller/rechazargastoproyecto.php',
    );

    var data = {"id": id, "comentarios": comentarios};
    var resi = await http.post(apiurl, body: data);
    fetchStudents();
    if (resi.statusCode == 200) {
      print(resi);
      print(resi.body); //print raw response on console
      var data = json.decode(resi.body);

      setState(() {
        fetchStudents();
      }); //decoding json to array
      if (data["error"]) {
        //refresh the UI when error is recieved from server
        setState(() {
          fetchStudents();
          comentarioctl.clear();
        });
      } else {
        //print(usuario);
        //after write success, make fields empty
        // ignore: unused_element
        setState(() {
          fetchStudents();
          comentarioctl.clear();
        });
        //mark success and refresh UI with setState

      }
    } else {
      //there is error
      setState(() {
        fetchStudents();
        comentarioctl.clear();
      });
      //mark error and refresh UI with setState

    }
  }

  Future<void> aceptarmate({int? ids, String? comentarios}) async {
    String id = ids.toString();
    // final urlinsert = Uri.parse(
    //   'https://asamexico.com.mx/php/controller/categoria.php?op=Insert');
    print('===$id======');
    final apiurl = Uri.parse(
      'https://asamexico.com.mx/php/controller/aceptargastoproyecto.php',
    );

    var data = {"id": id, "comentarios": comentarios};
    var resi = await http.post(apiurl, body: data);
    fetchStudents();
    if (resi.statusCode == 200) {
      print(resi);
      print(resi.body); //print raw response on console
      var data = json.decode(resi.body);

      setState(() {
        fetchStudents();
      }); //decoding json to array
      if (data["error"]) {
        //refresh the UI when error is recieved from server
        setState(() {
          fetchStudents();
        });
      } else {
        //print(usuario);
        //after write success, make fields empty
        // ignore: unused_element
        setState(() {
          fetchStudents();
        });
        //mark success and refresh UI with setState

      }
    } else {
      //there is error
      setState(() {
        fetchStudents();
      });
      //mark error and refresh UI with setState

    }
  }
}
