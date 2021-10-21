import 'package:asa_mexico/src/pages/presupuestos/gasto_proyectos_list.dart';
import 'package:asa_mexico/src/pages/presupuestos/gastosproyectos_check.dart';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Gastosproyectos extends StatefulWidget {
  final String idholder;
  final String referencia;
  const Gastosproyectos(
    this.idholder,
    this.referencia, {
    Key key,
  }) : super(key: key);

  @override
  _GastosproyectosState createState() =>
      _GastosproyectosState(idholder, referencia);
}

class _GastosproyectosState extends State<Gastosproyectos> {
  final String idholder;
  final String referencia;
  String estado = "";
  bool error, sending, success;
  String msg;
  TextEditingController cantidadctl = new TextEditingController();
  TextEditingController comentariosctl = new TextEditingController();
  int selectedSpinnerItem;
  String select;
  List data = List();
  Future myFuture;

  final apiurl = Uri.parse(
    'https://asamexico.com.mx/php/controller/listaconceptogastos.php',
  );

  _GastosproyectosState(this.idholder, this.referencia);

  Future<String> fetchData() async {
    var response = await http.get(apiurl);

    if (response.statusCode == 200) {
      var res = await http.get(apiurl, headers: {"Accept": "application/json"});

      var resBody = json.decode(res.body);

      setState(() {
        data = resBody;
      });

      print('Loaded Successfully');

      return "Loaded Successfully";
    } else {
      throw Exception('Failed to load data.');
    }
  }

  @override
  void initState() {
    myFuture = fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: myFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return DefaultTabController(
            initialIndex: 0,
            length: 3,
            child: Scaffold(
                appBar: AppBar(
                  title: Text("Gasto proyectos"),
                  bottom: const TabBar(
                    tabs: <Widget>[
                      Tab(icon: Icon(Icons.edit_rounded)),
                      Tab(
                        icon: Icon(Icons.check),
                      ),
                      Tab(
                        icon: Icon(Icons.list),
                      ),
                    ],
                  ),
                ),
                body: TabBarView(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      SizedBox(height: 10),
                      Container(
                        child: DropdownButton(
                            items: data.map((item) {
                              return DropdownMenuItem(
                                child: Text(item['Categoria']),
                                //value: item['n'],
                                value: (item['Categoria'].toString()),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                select = newVal;
                                print(select);
                                //selectedSpinnerItem = newVal;
                              });
                            },
                            value: select),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: TextField(
                            controller: comentariosctl,
                            decoration:
                                InputDecoration(hintText: 'Comentarios'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Table(children: [
                          TableRow(children: [
                            Icon(
                              Icons.attach_money_sharp,
                              size: 20,
                              color: Color.fromRGBO(35, 56, 120, 1.0),
                            ),
                            TextField(
                              controller: cantidadctl,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(hintText: '0.0'),
                            ),
                            SizedBox(
                              width: 100,
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.add_circle_outlined,
                                  size: 35,
                                  color: Color.fromRGBO(35, 56, 120, 1.0),
                                ),
                                onPressed: () {
                                  altagasto(context);
                                }),
                          ]),
                        ]),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        child: Text(
                          "Solicitud de gastos",
                          style: TextStyle(
                              color: Color.fromRGBO(35, 56, 120, 1.0),
                              fontSize: 15),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color.fromRGBO(35, 56, 120, 1.0)),
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                            ),
                            height: MediaQuery.of(context).size.height * 0.7,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Cargamateriales(id: idholder)),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Color.fromRGBO(35, 56, 120, 1.0),
                        ),
                        child: TextButton.icon(
                            onPressed: () {
                              //print(idholder);
                              registrar(context);
                            },
                            icon: Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                            label: Text("Registrar",
                                style: TextStyle(color: Colors.white))),
                      )
                    ]),
                  ),
                  Checkgastos(idholder),
                  Gastosproyectoslist(idholder),
                ])),
          );
        });
  }

  Future<void> registrar(BuildContext context) async {
    //String id = idproducto.toString();
    // final urlinsert = Uri.parse(
    //   'https://asamexico.com.mx/php/controller/categoria.php?op=Insert');

    //print('===$idproducto======');
    final apiurl = Uri.parse(
      'https://asamexico.com.mx/php/controller/updategastoproyecto.php',
    );

    var data = {"idp": idholder};
    var resi = await http.post(apiurl, body: data);
    setState(() {
      sending = false;
      success = true;
      myFuture = fetchData();
      super.initState();
    });
    if (resi.statusCode == 200) {
      print(resi);
      print(resi.body); //print raw response on console
      var data = json.decode(resi.body);

      setState(() {
        sending = false;
        success = true;
        myFuture = fetchData();
        super.initState();
      }); //decoding json to array
      if (data["error"]) {
        //refresh the UI when error is recieved from server
        setState(() {
          //refresh the UI when error is recieved from server
          sending = false;
          error = true;
          msg = data["message"]; //error message from server
          estado = "Error al guardar";
        });
      } else {
        //print(usuario);
        //after write success, make fields empty
        // ignore: unused_element
        estado = "Se ha programado aqui";
        print("$estado");
        //print(usuario);
        //after write success, make fields empty

        cantidadctl.clear();

        setState(() {
          sending = false;
          success = true;

          //showAlertDialog(context);

          //DetallesfacturaState(this.uuid);
          //Navigator.pop(context, false);
          //mark success and refresh UI with setState
        });
      }
    } else {
      //there is error
      setState(() {
        error = true;
        msg = "Error during sendign data.";
        sending = false;
        //mark error and refresh UI with setState
      });
    }
  }

  Future<void> altagasto(BuildContext context) async {
    String usuario;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    usuario = prefs.getString('nuser');
    //String idps = "$idp";
    print(idholder);
    print(referencia);
    print(select);
    print(cantidadctl.text);
    print(usuario);
    print(comentariosctl.text);

    var resi = await http.post(
        Uri.parse(
            "https://asamexico.com.mx/php/controller/altagastosolpro.php"),
        body: {
          "id": idholder,
          "referencia": referencia,
          "gasto": select,
          "monto": cantidadctl.text,
          "usuario": usuario,
          "comentario": comentariosctl.text,
        }); //sending post request with header data

    if (resi.statusCode == 200) {
      print(resi.body); //print raw response on console
      var data = json.decode(resi.body); //decoding json to array
      if (data["error"]) {
        setState(() {
          //refresh the UI when error is recieved from server
          sending = false;
          error = true;
          msg = data["message"]; //error message from server
          estado = "Error al guardar";
        });
      } else {
        //comentariosctl.text = "";
        //proyectoctl.text = "";
        //observacionesctl.text = "";
        //responsablectl.text = "";
        //print(data.id.toString());
        estado = "Se ha programado";
        print("$estado");
        //print(usuario);
        //after write success, make fields empty

        cantidadctl.clear();

        setState(() {
          sending = false;
          success = true;

          //showAlertDialog(context);

          //DetallesfacturaState(this.uuid);
          //Navigator.pop(context, false);
          //mark success and refresh UI with setState
        });
      }
    } else {
      //there is error
      setState(() {
        error = true;
        msg = "Error during sendign data.";
        sending = false;
        //mark error and refresh UI with setState
      });
    }
  }
}

class Listamaterial {
  int id;
  String gasto;
  String comentario;

  double monto;

  Listamaterial({
    this.id,
    this.gasto,
    this.comentario,
    this.monto,
  });
  factory Listamaterial.fromJson(Map<String, dynamic> json) {
    return Listamaterial(
        id: json['id'],
        gasto: json['Gasto'],
        comentario: json['Comentario'],
        monto: json['Monto'].toDouble());
  }
}

class Cargamateriales extends StatefulWidget {
  final String id;
  @override
  Cargamateriales({Key key, this.id}) : super(key: key);

  @override
  _CargamaterialesState createState() => _CargamaterialesState();
}

class _CargamaterialesState extends State<Cargamateriales> {
  final apiurl = Uri.parse(
    'https://asamexico.com.mx/php/controller/listagastosolicitados.php',
  );

  Future<List<Listamaterial>> fetchStudents() async {
    var data = {'id': ("${widget.id}")};
    print('========$data=======');

    var response = await http.post(apiurl, body: json.encode(data));

    //var response = await http.get(apiurl);

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      //print(this.usuario);
      List<Listamaterial> studentList = items.map<Listamaterial>((json) {
        return Listamaterial.fromJson(json);
      }).toList();

      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  void initState() {
    fetchStudents();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Listamaterial>>(
        future: fetchStudents(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return ListView(
              children: snapshot.data
                  .map(
                    (data) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          leading: Text(data.monto.toString(),
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14.0,
                                  color: Colors.blueAccent)),

                          onTap: () {},
                          trailing: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                setState(() {
                                  elimianarmate(data.id);
                                  Cargamateriales();
                                });
                              }),
                          //Agregamos el nombre con un Widget Text
                          title: Text(data.gasto,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14.0)
                              //le damos estilo a cada texto
                              ),
                          subtitle: Text(data.comentario,
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 14.0)
                              //le damos estilo a cada texto
                              ),
                        ),
                      ),
                    ),
                  )
                  .toList());
        });
  }

  Future<void> elimianarmate([int idproducto]) async {
    String id = idproducto.toString();
    // final urlinsert = Uri.parse(
    //   'https://asamexico.com.mx/php/controller/categoria.php?op=Insert');
    print('===$idproducto======');
    final apiurl = Uri.parse(
      'https://asamexico.com.mx/php/controller/eliminargastosolicitud.php',
    );

    var data = {"id": id};
    var resi = await http.post(apiurl, body: data);
    if (resi.statusCode == 200) {
      print(resi);
      print(resi.body); //print raw response on console
      var data = json.decode(resi.body);
      setState(() {
        Cargamateriales();
      }); //decoding json to array
      if (data["error"]) {
        //refresh the UI when error is recieved from server
        setState(() {
          Cargamateriales();
        });
      } else {
        //print(usuario);
        //after write success, make fields empty
        // ignore: unused_element
        setState(() {
          Cargamateriales();
        });
        //mark success and refresh UI with setState

      }
    } else {
      //there is error
      setState(() {
        Cargamateriales();
      });
      //mark error and refresh UI with setState

    }
  }
}
