import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Datainsert extends StatelessWidget {
  final String usuario;
  @override
  const Datainsert(this.usuario, {Key key}) : super(key: key);
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MainListView(context),
      ),
    );
  }
}

class Studentdata {
  int id;
  dynamic referencia;
  String proyecto;
  String responsable;
  String observaciones;
  String nocliente;

  Studentdata(
      {this.id,
      this.referencia,
      this.proyecto,
      this.responsable,
      this.observaciones,
      this.nocliente});

  factory Studentdata.fromJson(Map<String, dynamic> json) {
    return Studentdata(
        id: json['id'],
        referencia: json['Referencia'],
        proyecto: json['Proyecto'],
        responsable: json['Responsable'],
        observaciones: json['Observaciones'],
        nocliente: json['NoCliente']);
  }
}

class Logstareas {
  int id;
  dynamic referenciaproyecto;

  String usuarioalta;
  String comentarios;
  String fechaalta;
  int avance;

  Logstareas(
      {this.id,
      this.referenciaproyecto,
      this.usuarioalta,
      this.comentarios,
      this.fechaalta,
      this.avance});

  factory Logstareas.fromJson(Map<String, dynamic> json) {
    return Logstareas(
        id: json['id'],
        referenciaproyecto: json['Referencia_proyecto'],
        usuarioalta: json['Usuario_Alta'],
        comentarios: json['Comentarios'],
        fechaalta: json['Fecha_Alta'],
        avance: json['avance']);
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
  Future<List<Studentdata>> fetchStudents() async {
    var response = await http.get(apiurl);

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      //print(this.usuario);
      List<Studentdata> studentList = items.map<Studentdata>((json) {
        return Studentdata.fromJson(json);
      }).toList();

      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  navigateToNextActivity(BuildContext context, int dataHolder) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SecondScreenState(dataHolder.toString())));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Studentdata>>(
      future: fetchStudents(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return ListView(
          children: snapshot.data
              .map((data) => Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          navigateToNextActivity(context, data.id);
                        },
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 20, 0, 5),
                                child: Icon(
                                  Icons.construction,
                                  color: Color.fromRGBO(35, 56, 120, 1.0),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Referencia: ",
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          color:
                                              Color.fromRGBO(35, 56, 120, 1.0)),
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text("Proyecto: ",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Color.fromRGBO(
                                                35, 56, 120, 1.0))),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text("Responsable: ",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Color.fromRGBO(
                                                35, 56, 120, 1.0))),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text("Cliente: ",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Color.fromRGBO(
                                                35, 56, 120, 1.0))),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text("Avance: ",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Color.fromRGBO(
                                                35, 56, 120, 1.0))),
                                  ],
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(data.referencia.toString(),
                                          textAlign: TextAlign.left),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(data.proyecto,
                                          textAlign: TextAlign.left),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(data.responsable,
                                          textAlign: TextAlign.left),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(data.nocliente,
                                          textAlign: TextAlign.left),
                                    ],
                                  )),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 20, 0, 5),
                                child: IconButton(
                                    icon: Icon(Icons.arrow_forward_ios),
                                    color: Color.fromRGBO(235, 73, 52, 1.0),
                                    onPressed: () {
                                      navigateToNextActivity(context, data.id);
                                    }),
                              ),
                            ]),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(color: Colors.black),
                    ],
                  ))
              .toList(),
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
  bool error, sending, success;
  String msg;

  // API URL
  final url = Uri.parse(
    'https://asamexico.com.mx/php/controller/proyectosid.php',
  );

  Future<List<Studentdata>> fetchStudent() async {
    var data = {'id': int.parse(idHolder)};

    var response = await http.post(url, body: json.encode(data));

    if (response.statusCode == 200) {
      print(response.statusCode);
      //print(usuario);
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      print(response.body);

      List<Studentdata> studentList = items.map<Studentdata>((json) {
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
        title: const Text('Ver proyecto'),
      ),
      body: FutureBuilder<List<Studentdata>>(
        future: fetchStudent(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return ListView(
            children: snapshot.data
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              print(data.id);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue),
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
                                            'Proyecto: ' + data.proyecto,
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black))),
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 0, 0, 10),
                                        child: Text(
                                            'Responsable: ' + data.responsable,
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black))),
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 0, 0, 10),
                                        child: Text(
                                            'Descripcion: ' +
                                                data.observaciones,
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
                          height: 10,
                        ),
                        Center(
                          child: Text("Eventos Registrados",
                              style:
                                  TextStyle(fontSize: 14.0, color: Colors.red)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                            height: 450,
                            width: double.infinity,
                            //color: Colors.black12,
                            child: LogtareasState(widget.idHolder)),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: new EdgeInsets.only(left: 3.0),
                          child: FloatingActionButton(
                            backgroundColor:
                                const Color.fromRGBO(35, 56, 120, 1.0),
                            foregroundColor: Colors.white,
                            onPressed: () {
                              openPopup(
                                  context, data); // Respond to button press
                            },
                            child: Icon(Icons.add),
                          ),
                        ),
                      ],
                    ))
                .toList(),
          );
        },
      ),
    ));
  }

  // navigatetoTareas(BuildContext context, int dataHolder) {
  //   Navigator.of(context).push(MaterialPageRoute(
  //       builder: (context) => LogtareasState(dataHolder.toString())));
  // }

  openPopup(BuildContext context, Studentdata data) {
    int idp = (data.id);
    print("$idp");
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
            // TextField(
            //   obscureText: true,
            //   decoration: InputDecoration(
            //     icon: Icon(Icons.calendar_today),
            //     labelText: 'Fecha',
            //   ),
            // ),
            //Text(data.id.toString())
          ],
        ),
        buttons: [
          DialogButton(
            color: const Color.fromRGBO(35, 56, 120, 1.0),
            onPressed: () {
              savedata(context, data);
              Navigator.pop(context);
            },
            child: Text(
              "Registrar",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ]).show();
  }

  Future<void> savedata(BuildContext context, Studentdata data) async {
    String user = "";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = prefs.getString('nuser');
    // final urlinsert = Uri.parse(
    //   'https://asamexico.com.mx/php/controller/categoria.php?op=Insert');
    int idp = (data.id);
    //String idps = "$idp";
    var resi = await http.post(
        Uri.parse("https://asamexico.com.mx/php/controller/creartarea.php"),
        body: {
          "referencia_proyecto": data.referencia,
          "usuario_alta": user,
          "id_proyecto": "$idp",
          "comentarios": comentariosctl.text
        }); //sending post request with header data

    if (resi.statusCode == 200) {
      print(resi);
      print("===============$user===================");
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
        comentariosctl.text = "";
        //proyectoctl.text = "";
        //observacionesctl.text = "";
        //responsablectl.text = "";
        //print(data.id.toString());
        estado = "Se ha guardado con exito";
        print("$estado");
        //print(usuario);
        //after write success, make fields empty

        setState(() {
          sending = false;
          success = true; //mark success and refresh UI with setState
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
  bool error, sending, success;
  String msg;
  String user = "";
  // API URL
  final url = Uri.parse(
    'https://asamexico.com.mx/php/controller/tareasid.php',
  );

  Future<List<Logstareas>> flistlogs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = prefs.getString('nuser');

    var data = {'id': ("$idHolder")};

    var response = await http.post(url, body: json.encode(data));
    print(data);
    if (response.statusCode == 200) {
      print(response.statusCode);
      print("===============$user====================");
      print("===============$idHolder====================");
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      print(response.body);

      List<Logstareas> logstarasList = items.map<Logstareas>((json) {
        return Logstareas.fromJson(json);
      }).toList();

      return logstarasList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Logstareas>>(
      future: flistlogs(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return ListView(
          children: snapshot.data
              .map((data) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
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
                              title: Text(data.comentarios,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14.0)
                                  //le damos estilo a cada texto
                                  ),
                              subtitle: Text(
                                  'Fecha: ' +
                                      data.fechaalta +
                                      '  @' +
                                      data.usuarioalta,
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
