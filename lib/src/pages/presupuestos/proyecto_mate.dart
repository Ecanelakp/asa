import 'package:asa_mexico/src/pages/presupuestos/presupuestomate_check.dart';
import 'package:asa_mexico/src/pages/presupuestos/presupuestomate_list.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Promate extends StatefulWidget {
  final String idholder;
  final String referencia;
  const Promate(
    this.idholder,
    this.referencia, {
    Key key,
  }) : super(key: key);

  @override
  _PromateState createState() => _PromateState(idholder, referencia);
}

class _PromateState extends State<Promate> {
  final String idholder;
  final String referencia;
  String estado = "";
  bool error, sending, success;
  String msg;
  TextEditingController cantidadctl = new TextEditingController();
  int selectedSpinnerItem;
  List data = List();
  Future myFuture;

  final apiurl = Uri.parse(
    'https://asamexico.com.mx/php/controller/listamaterialesproyecto.php',
  );

  _PromateState(this.idholder, this.referencia);

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
                  title: Text("Materiales proyectos"),
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
                              child: Text(item['Nombre']),
                              value: item['id'.toString()],
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            setState(() {
                              selectedSpinnerItem = newVal;
                            });
                          },
                          value: selectedSpinnerItem,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Table(children: [
                          TableRow(children: [
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
                                  print(selectedSpinnerItem.toString());

                                  print(cantidadctl.text);
                                  print(referencia);
                                  print(idholder);

                                  altamovprod(context);
                                }),
                          ]),
                        ]),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        child: Text(
                          "Materiales para enviar a proyecto",
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
                  Checkmate(idholder),
                  Mateproyectos(idholder),
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
      'https://asamexico.com.mx/php/controller/updatemateproyecto.php',
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

  Future<void> altamovprod(BuildContext context) async {
    String usuario;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    usuario = prefs.getString('nuser');
    //String idps = "$idp";
    print(usuario);
    var resi = await http.post(
        Uri.parse(
            "https://asamexico.com.mx/php/controller/movmateproyecto.php"),
        body: {
          "no": selectedSpinnerItem.toString(),
          "cantidad": cantidadctl.text,
          "referencia": idholder,
          "usuario": usuario
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
  String nombre;
  String unidad;

  double cantidad;
  int idproducto;

  Listamaterial({this.nombre, this.cantidad, this.idproducto, this.unidad});
  factory Listamaterial.fromJson(Map<String, dynamic> json) {
    return Listamaterial(
        nombre: json['Nombre'],
        unidad: json['Unidad'],
        cantidad: json['Cantidad'].toDouble(),
        idproducto: json['id']);
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
    'https://asamexico.com.mx/php/controller/listasalidaproyecto.php',
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
                          leading: Text(
                              data.cantidad.toString() + "  " + data.unidad,
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
                                print(data.idproducto);
                                elimianarmate(data.idproducto);
                                setState(() {
                                  Cargamateriales();
                                });
                              }),
                          //Agregamos el nombre con un Widget Text
                          title: Text(data.nombre,
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

  Future<void> elimianarmate([int idproducto]) async {
    String id = idproducto.toString();
    // final urlinsert = Uri.parse(
    //   'https://asamexico.com.mx/php/controller/categoria.php?op=Insert');
    print('===$idproducto======');
    final apiurl = Uri.parse(
      'https://asamexico.com.mx/php/controller/elimiarmateproyecto.php',
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
