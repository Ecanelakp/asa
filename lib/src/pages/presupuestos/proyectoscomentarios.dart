import 'dart:io';

import 'package:asa_mexico/src/pages/presupuestos/subirfoto.dart';
import 'package:asa_mexico/src/pages/presupuestos/view_photo_pro.dart';
//import 'package:http_parser/http_parser.dart';
// import 'package:mime_type/mime_type.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

File? foto;
//String secure_url;
String? idtarea;

class Comentariosproyectos extends StatelessWidget {
  final String idholder;
  final String? referencia;

  const Comentariosproyectos(
    this.idholder,
    this.referencia, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comentarios"),
      ),
      body: Center(
        child: LogtareasState(idholder),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          //print("===hola===$referencia====hola===");
          openPopup(context, idholder, referencia);
        },
      ),
    );
  }
}

@override
void initState() {}
TextEditingController comentariosctl = TextEditingController();
TextEditingController idctl = TextEditingController();

String estado = "";
bool? error, sending, success;
String? msg;

class Logstareas {
  int? id;
  dynamic referenciaproyecto;

  String? usuarioalta;
  String? comentarios;
  String? fechaalta;
  String? urlimagen;

  Logstareas({
    this.id,
    this.referenciaproyecto,
    this.usuarioalta,
    this.comentarios,
    this.fechaalta,
    this.urlimagen,
  });

  factory Logstareas.fromJson(Map<String, dynamic> json) {
    return Logstareas(
        id: json['id'],
        referenciaproyecto: json['Referencia_proyecto'],
        usuarioalta: json['Usuario_Alta'],
        comentarios: json['Comentarios'],
        fechaalta: json['Fecha_Alta'],
        urlimagen: json['url_foto']);
  }
}

class LogtareasState extends StatefulWidget {
  final String idHolder;
  //final String usuario;
  LogtareasState(this.idHolder);

  @override
  State<StatefulWidget> createState() {
    return Logtareas(this.idHolder);
  }
}

class Logtareas extends State<LogtareasState> {
  final String idHolder;
  //final String usuario;
  //TextEditingController comentariosctl = TextEditingController();
  //TextEditingController idctl = TextEditingController();
  Logtareas(
    this.idHolder,
  );

  String estado = "";
  bool? error, sending, success;
  String? msg;
  String? user = "";
  // API URL
  final url = Uri.parse(
    'https://asamexico.com.mx/php/controller/tareasid.php',
  );

  Future<List<Logstareas>?> flistlogs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = prefs.getString('nuser');

    var data = {'id': ("$idHolder")};

    var response = await http.post(url, body: json.encode(data));
    //print(data);
    if (response.statusCode == 200) {
      //print(response.statusCode);
      //print("===============$user====================");
      //print("===============$idHolder====================");

      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      //print(response.body);

      List<Logstareas>? logstarasList = items.map<Logstareas>((json) {
        return Logstareas.fromJson(json);
      }).toList();

      return logstarasList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  Future<void> _refreshProducts(BuildContext context) async {
    return setState(() {
      LogtareasState(idHolder);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: FutureBuilder<List<Logstareas>?>(
            future: flistlogs(),
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
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(
                                      color: Color.fromRGBO(35, 56, 120, 0.8)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ExpansionTile(
                                    leading: Text(
                                      data.usuarioalta!,
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(35, 56, 120, 0.8)),
                                    ),

                                    //trailing:
                                    //Agregamos el nombre con un Widget Text
                                    subtitle: Text(data.comentarios!,
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          color: Colors.black,
                                        )
                                        //le damos estilo a cada texto
                                        ),
                                    title: Text('Fecha: ' + data.fechaalta!,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Color.fromRGBO(
                                                35, 56, 120, 0.8))),
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                              child: data.urlimagen != ''
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      Photoproview(
                                                                          data.urlimagen)));
                                                        },
                                                        child: Image.network(
                                                            data.urlimagen!,
                                                            height: 200,
                                                            fit: BoxFit.cover),
                                                      ),
                                                    )
                                                  : Subirfoto(
                                                      data.id.toString())),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              );
            }));
  }
}

openPopup(BuildContext context, idholder, referencia) {
  String idp = (idholder);
  //print("$idp");
  Alert(
      context: context,
      title: "Registrar Eventos",
      content: Column(
        children: <Widget>[
          TextField(
            controller: comentariosctl,
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            decoration: InputDecoration(
              icon: Icon(Icons.comment_bank_outlined),
              labelText: 'Comentarios',
            ),
          ),
        ],
      ),
      buttons: [
        DialogButton(
          color: const Color.fromRGBO(35, 56, 120, 1.0),
          onPressed: () {
            savedata(context, idholder, referencia);
            Navigator.pop(context);
          },
          child: Text(
            "Registrar",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ]).show();
}

Future<void> savedata(BuildContext context, idholder, referencia) async {
  String? user;

  SharedPreferences prefs = await SharedPreferences.getInstance();
  user = prefs.getString('nuser');
  // final urlinsert = Uri.parse(
  //   'https://asamexico.com.mx/php/controller/categoria.php?op=Insert');
  String idp = (idholder);
  //print(idholder);
  //print(referencia);
  //String idps = "$idp";
  var resi = await http.post(
      Uri.parse("https://asamexico.com.mx/php/controller/creartarea.php"),
      body: {
        "referencia_proyecto": referencia,
        "usuario_alta": user,
        "id_proyecto": "$idp",
        "comentarios": comentariosctl.text
      }); //sending post request with header data

  if (resi.statusCode == 200) {
    //print(resi);
    //print("===============$user===================");
    //print(resi.body); //print raw response on console
    var data = json.decode(resi.body); //decoding json to array
    if (data["error"]) {
      //refresh the UI when error is recieved from server
      sending = false;
      error = true;
      msg = data["message"]; //error message from server
      estado = "Error al guardar";
    } else {
      comentariosctl.text = "";
      //proyectoctl.text = "";
      //observacionesctl.text = "";
      //responsablectl.text = "";
      //print(data.id.toString());

      //print(usuario);
      //after write success, make fields empty

      showAlertDialog(context);
      estado = "Se ha guardado con exito";
      print("$estado");
    }
  } else {
    //there is error

    error = true;
    msg = "Error during sendign data.";
    sending = false;
    //mark error and refresh UI with setState

  }
}

showAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        initState();
        LogtareasState(idctl.text);
        Navigator.of(context).pop();
      });

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Estado"),
    content: Text(
        "Se ha cargado correctamente la informacion tus comentarios, Gracias refresca por favor."),
    actions: [
      okButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}




//void setState(Null Function() param0) {}
