import 'package:asa_mexico/src/pages/presupuestos/avances_proyectos.dart';
import 'package:asa_mexico/src/pages/presupuestos/gastos_proyectos.dart';
import 'package:asa_mexico/src/pages/presupuestos/proyecto_mate.dart';
import 'package:asa_mexico/src/pages/presupuestos/proyectoscomentarios.dart';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Datainsert extends StatelessWidget {
  final String usuario;
  @override
  const Datainsert(this.usuario, {Key? key}) : super(key: key);
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MainListView(context),
    );
  }
}

class Studentdata {
  int? id;
  dynamic referencia;
  String? proyecto;
  String? responsable;
  String? observaciones;
  String? nocliente;
  double? avance;

  Studentdata(
      {this.id,
      this.referencia,
      this.proyecto,
      this.responsable,
      this.observaciones,
      this.nocliente,
      this.avance});

  factory Studentdata.fromJson(Map<String, dynamic> json) {
    return Studentdata(
        id: json['id'],
        referencia: json['Referencia'],
        proyecto: json['Proyecto'],
        responsable: json['Responsable'],
        observaciones: json['Observaciones'],
        nocliente: json['NoCliente'],
        avance: json["avance"].toDouble());
  }
}

class Logstareas {
  int? id;
  dynamic referenciaproyecto;

  String? usuarioalta;
  String? comentarios;
  String? fechaalta;

  Logstareas(
      {this.id,
      this.referenciaproyecto,
      this.usuarioalta,
      this.comentarios,
      this.fechaalta});

  factory Logstareas.fromJson(Map<String, dynamic> json) {
    return Logstareas(
        id: json['id'],
        referenciaproyecto: json['Referencia_proyecto'],
        usuarioalta: json['Usuario_Alta'],
        comentarios: json['Comentarios'],
        fechaalta: json['Fecha_Alta']);
  }
}

class MainListView extends StatefulWidget {
  MainListView(BuildContext context);

  MainListViewState createState() => MainListViewState();
}

class MainListViewState extends State {
  final apiurl = Uri.parse(
    'https://asamexico.com.mx/php/controller/proyectos.php',
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

  navigateToNextActivity(BuildContext context, int? dataHolder) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SecondScreenState(dataHolder.toString())));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Studentdata>?>(
      future: fetchStudents(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Lista de proyectos activos ',
                textAlign: TextAlign.center,
                style: (TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.03,
                    color: Color.fromRGBO(35, 56, 120, 1.0)))),
            SizedBox(
              height: 20,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width * 0.95,
              child: ListView(
                children: snapshot.data!
                    .map(
                      (data) => Card(
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: Icon(
                                Icons.construction,
                                color: data.avance! > 60
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              onTap: () {
                                navigateToNextActivity(context, data.id);
                              },
                              title: Text(
                                  data.referencia + '  ' + data.proyecto,
                                  textAlign: TextAlign.left,
                                  style: (TextStyle(
                                      color:
                                          Color.fromRGBO(35, 56, 120, 1.0)))),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Descripcion: ' + data.observaciones!,
                                    textAlign: TextAlign.left,
                                  ),
                                  Text('Responsable: ' + data.responsable!,
                                      textAlign: TextAlign.left),
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    data.avance.toString() + '%',
                                    textAlign: TextAlign.left,
                                    style: (TextStyle(
                                      color: data.avance! > 50
                                          ? Colors.green
                                          : Colors.red,
                                    )),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Avance',
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class SecondScreenState extends StatefulWidget {
  final String idHolder;
  //final String usuario;
  //final String usuario;

  SecondScreenState(
    this.idHolder,
  );
  @override
  State<StatefulWidget> createState() {
    return SecondScreen(this.idHolder);
  }
}

class SecondScreen extends State<SecondScreenState> {
  //final String usuario;
  final String idHolder;
  TextEditingController comentariosctl = TextEditingController();
  TextEditingController idctl = TextEditingController();
  SecondScreen(this.idHolder);
  //SecondScreen(this.idHolder, this.usuario);
  //String usuariot = usuario;
  String estado = "";
  bool? error, sending, success;
  String? msg;

  // API URL
  final url = Uri.parse(
    'https://asamexico.com.mx/php/controller/proyectosid.php',
  );

  Future<List<Studentdata>?> fetchStudent() async {
    var data = {'id': int.parse(idHolder)};

    var response = await http.post(url, body: json.encode(data));

    if (response.statusCode == 200) {
      print(response.statusCode);
      //print(usuario);
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      print(response.body);

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
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(35, 56, 120, 1.0),
        title: const Text('Ver proyecto'),
      ),
      body: FutureBuilder<List<Studentdata>?>(
        future: fetchStudent(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return ListView(
            children: snapshot.data!
                .map((data) => Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        /* FadeInImage(
                          placeholder:
                              AssetImage('assets/images/asablanco.jpg'),
                          image: AssetImage('assets/images/asablanco.jpg'),
                          height: 200,
                          fit: BoxFit.contain,
                        ), */
                        Card(
                          margin: new EdgeInsets.symmetric(horizontal: 20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              print(data.id);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                // border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(20.0),
                                image: DecorationImage(
                                    colorFilter: ColorFilter.mode(
                                        Colors.black.withOpacity(0.2),
                                        BlendMode.dstATop),
                                    image: AssetImage(
                                      'assets/images/asablanco.jpg',
                                    ),
                                    fit: BoxFit.cover),
                              ),
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 0, 0, 10),
                                        child: Text(
                                            'Referencia: ' +
                                                data.referencia.toString(),
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black))),
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 0, 0, 10),
                                        child: Text(
                                            'Proyecto: ' + data.proyecto!,
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black))),
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 0, 0, 10),
                                        child: Text(
                                            'Responsable: ' + data.responsable!,
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black))),
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 0, 0, 10),
                                        child: Text(
                                            'Descripcion: ' +
                                                data.observaciones!,
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black))),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 15,
                          child: Text("Avance del proyecto"),
                        ),
                        Sliderbarpro(
                            id: widget.idHolder,
                            referencia: data.referencia,
                            avance: data.avance),
                        Container(
                            margin: new EdgeInsets.symmetric(horizontal: 20.0),
                            height: 450,
                            width: double.infinity,
                            child: Column(
                              children: [
                                Card(
                                  //color: Color.fromRGBO(35, 56, 120, 1.0),
                                  margin: EdgeInsets.only(top: 30.0),
                                  child: ListTile(
                                      trailing: Icon(Icons.arrow_forward_ios,
                                          color:
                                              Color.fromRGBO(35, 56, 120, 1.0)),
                                      leading: const Icon(Icons.comment_sharp,
                                          color:
                                              Color.fromRGBO(35, 56, 120, 1.0)),
                                      title: const Text("Comentarios",
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Color.fromRGBO(
                                                  35, 56, 120, 1.0))),
                                      subtitle: const Text(
                                          'Ve o agrega un comentario al proyecto'),
                                      onTap: () {
                                        print(idHolder.toString());
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Comentariosproyectos(
                                                        widget.idHolder,
                                                        data.referencia)));
                                      }),
                                ),
                                Card(
                                  //color: Color.fromRGBO(35, 56, 120, 1.0),
                                  margin: EdgeInsets.only(top: 30.0),
                                  child: ListTile(
                                      trailing: Icon(Icons.arrow_forward_ios,
                                          color:
                                              Color.fromRGBO(35, 56, 120, 1.0)),
                                      leading: const Icon(
                                          Icons.sync_alt_outlined,
                                          color:
                                              Color.fromRGBO(35, 56, 120, 1.0)),
                                      title: const Text("Gastos",
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Color.fromRGBO(
                                                  35, 56, 120, 1.0))),
                                      subtitle: const Text(
                                          'Procesa tus solicitudes de gasto'),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Gastosproyectos(
                                                        widget.idHolder,
                                                        data.referencia)));
                                      }),
                                ),
                                Card(
                                  //color: Color.fromRGBO(35, 56, 120, 1.0),
                                  margin: EdgeInsets.only(top: 30.0),
                                  child: ListTile(
                                      trailing: Icon(Icons.arrow_forward_ios,
                                          color:
                                              Color.fromRGBO(35, 56, 120, 1.0)),
                                      leading: const Icon(Icons.build_circle,
                                          color:
                                              Color.fromRGBO(35, 56, 120, 1.0)),
                                      title: const Text("Materiales",
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Color.fromRGBO(
                                                  35, 56, 120, 1.0))),
                                      subtitle: const Text(
                                          'Registra materiales o insumos para el proyecto'),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Promate(
                                                    widget.idHolder,
                                                    data.referencia)));
                                      }),
                                ),
                                Card(
                                    //color: Color.fromRGBO(35, 56, 120, 1.0),
                                    margin: EdgeInsets.only(top: 30.0),
                                    child: ListTile(
                                        trailing: Icon(Icons.arrow_forward_ios,
                                            color: Color.fromRGBO(
                                                35, 56, 120, 1.0)),
                                        leading: const Icon(
                                            Icons.track_changes_sharp,
                                            color: Color.fromRGBO(
                                                35, 56, 120, 1.0)),
                                        title: const Text("Avances",
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Color.fromRGBO(
                                                    35, 56, 120, 1.0))),
                                        subtitle: const Text(
                                            'Registra los avances por dia'),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Avancesproyectoshm(
                                                          widget.idHolder,
                                                          data.referencia)));
                                        }))
                              ],
                            )),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ))
                .toList(),
          );
        },
      ),
    ));
  }
}

class Sliderbarpro extends StatefulWidget {
  final String? id;
  final String? referencia;
  final double? avance;
  const Sliderbarpro({this.id, this.referencia, this.avance});
  @override
  _SliderbarproState createState() => _SliderbarproState();
}

class _SliderbarproState extends State<Sliderbarpro> {
  double? _currentSliderValue = 0;
  @override
  void initState() {
    _currentSliderValue = widget.avance;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: _currentSliderValue!,
          min: 0,
          max: 100,
          divisions: 5,
          activeColor:
              _currentSliderValue! < 50 ? Colors.redAccent : Colors.green,
          label: _currentSliderValue!.round().toString(),
          onChanged: (double value) {
            setState(() {
              //print(widget.referencia);
              //print(widget.id);
              _currentSliderValue = value;
              actualizaravance();
            });
          },
        ),
        _currentSliderValue == 100
            ? Container(
                child: Container(
                    decoration: BoxDecoration(
                      // border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(20.0),
                      color: Color.fromRGBO(35, 56, 120, 1.0),
                    ),
                    child: TextButton.icon(
                        onPressed: () {
                          cerrarproyecto();
                          _showAlertDialog();
                        },
                        icon:
                            Icon(Icons.arrow_forward_ios, color: Colors.white),
                        label: Text(
                          "Cerrar Proyecto",
                          style: TextStyle(fontSize: 14.0, color: Colors.white),
                        ))),
              )
            : Container(height: 53),
      ],
    );
  }

  Future<void> actualizaravance({int? ids, String? comentarios}) async {
    // final urlinsert = Uri.parse(
    //   'https://asamexico.com.mx/php/controller/categoria.php?op=Insert');

    final apiurl = Uri.parse(
      'https://asamexico.com.mx/php/controller/actualizaravenceproyecto.php',
    );

    var data = {"id": widget.id, "avance": _currentSliderValue.toString()};
    var resi = await http.post(apiurl, body: data);

    if (resi.statusCode == 200) {
      print(resi);
      print(resi.body); //print raw response on console
      var data = json.decode(resi.body);

      setState(() {
        actualizaravance();
      }); //decoding json to array
      if (data["error"]) {
        //refresh the UI when error is recieved from server
        setState(() {});
      } else {
        //print(usuario);
        //after write success, make fields empty
        // ignore: unused_element
        setState(() {});
        //mark success and refresh UI with setState

      }
    } else {
      //there is error
      setState(() {});
      //mark error and refresh UI with setState

    }
  }

  Future<void> cerrarproyecto({int? ids, String? comentarios}) async {
    // final urlinsert = Uri.parse(
    //   'https://asamexico.com.mx/php/controller/categoria.php?op=Insert');

    final apiurl = Uri.parse(
      'https://asamexico.com.mx/php/controller/cerrarproyecto.php',
    );

    var data = {"id": widget.id};
    var resi = await http.post(apiurl, body: data);

    if (resi.statusCode == 200) {
      print(resi);
      print(resi.body); //print raw response on console
      var data = json.decode(resi.body);
      _showAlertDialog();
      setState(() {
        _showAlertDialog();
      }); //decoding json to array
      if (data["error"]) {
        //refresh the UI when error is recieved from server
        setState(() {
          _showAlertDialog();
        });
      } else {
        //print(usuario);
        //after write success, make fields empty
        // ignore: unused_element
        setState(() {
          _showAlertDialog();
        });
        //mark success and refresh UI with setState

      }
    } else {
      //there is error
      setState(() {
        _showAlertDialog();
      });
      //mark error and refresh UI with setState

    }
  }

  void _showAlertDialog() {
    showDialog(
        context: context,
        builder: (buildcontext) {
          return AlertDialog(
            title: Text("Guardado"),
            content: Text(
                "Se ha cerrado correctamente el proyecto, felicidades!!!!"),
            actions: <Widget>[
              RaisedButton(
                color: Colors.green,
                child: Text(
                  "Cerrar",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}

// navigatetoTareas(BuildContext context, int dataHolder) {
//   Navigator.of(context).push(MaterialPageRoute(
//       builder: (context) => LogtareasState(dataHolder.toString())));
// }
