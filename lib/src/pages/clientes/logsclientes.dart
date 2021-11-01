import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CclientesState extends StatefulWidget {
  final String? idcliente;
  //final String usuario;
  //final String usuario;
  CclientesState(
    this.idcliente,
  );
  @override
  State<StatefulWidget> createState() {
    return Cclientes(this.idcliente);
  }
}

class Studentdata {
  int? id;
  dynamic referencia;
  String? nombre;
  String? contacto;
  String? puesto;
  String? direccion;

  Studentdata(
      {this.id,
      this.referencia,
      this.nombre,
      this.contacto,
      this.puesto,
      this.direccion});

  factory Studentdata.fromJson(Map<String, dynamic> json) {
    return Studentdata(
        id: json['id'],
        referencia: json['Referencia'],
        nombre: json['Nombre'],
        contacto: json['Contacto'],
        puesto: json['Puesto'],
        direccion: json['Direccion']);
  }
}

class Logstareas {
  int? id;
  dynamic referenciacliente;

  String? usuarioalta;
  String? comentarios;
  String? fechaalta;

  Logstareas(
      {this.id,
      this.referenciacliente,
      this.usuarioalta,
      this.comentarios,
      this.fechaalta});

  factory Logstareas.fromJson(Map<String, dynamic> json) {
    return Logstareas(
        id: json['id'],
        referenciacliente: json['Referencia_cliente'],
        usuarioalta: json['Usuario_Alta'],
        comentarios: json['Comentarios'],
        fechaalta: json['Fecha_Alta']);
  }
}

class Cclientes extends State<CclientesState> {
  //final String usuario;
  final String? idcliente;
  TextEditingController comentariosctl = TextEditingController();
  TextEditingController idctl = TextEditingController();
  Cclientes(this.idcliente);
  //SecondScreen(this.idHolder, this.usuario);
  //String usuariot = usuario;
  String estado = "";
  bool? error, sending, success;
  String? msg;

  // API URL
  final url = Uri.parse(
    'https://asamexico.com.mx/php/controller/clientesid.php',
  );

  Future<List<Studentdata>?> fetchStudent() async {
    var data = {'id': int.parse(idcliente!)};

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
        title: const Text('Log de cliente'),
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
                        Card(
                          color: Color.fromRGBO(35, 56, 120, 0.95),
                          child: GestureDetector(
                            onTap: () {
                              print(data.id);
                            },
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                              color: Colors.white))),
                                  Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 0, 0, 10),
                                      child: Text('Cliente: ' + data.nombre!,
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.white))),
                                  Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 0, 0, 10),
                                      child: Text('Contacto: ' + data.contacto!,
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.white))),
                                  Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 0, 0, 10),
                                      child: Text('Puesto: ' + data.puesto!,
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.white))),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ]),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Text("Eventos Registrados",
                              style:
                                  TextStyle(fontSize: 14.0, color: Colors.red)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            height: 400,
                            width: double.infinity,
                            //color: Colors.black12,
                            child: LogtareasState(widget.idcliente)),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          // width: double.infinity,
                          // height: 60,
                          // color: Colors.black12,
                          child: FloatingActionButton(
                            backgroundColor:
                                const Color.fromRGBO(35, 56, 120, 1.0),
                            foregroundColor: Colors.white,
                            onPressed: () {
                              openPopup(context, data);
                              // Respond to button press
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
    int? idp = (data.id);
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
            Text(estado, style: TextStyle(fontSize: 14.0, color: Colors.red)),
          ],
        ),
        buttons: [
          DialogButton(
            color: const Color.fromRGBO(35, 56, 120, 1.0),
            onPressed: () {
              savedata(context, data);
              Navigator.pop(context);
              //estado = "Se ha guardado con exito";
            },
            child: Text(
              "Registrar",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ]).show();
  }

  Future<void> savedata(BuildContext context, Studentdata data) async {
    String? user = "";
    String idp = "";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = prefs.getString('nuser');
    // final urlinsert = Uri.parse(
    //   'https://asamexico.com.mx/php/controller/categoria.php?op=Insert');
    idp = data.id.toString();
    print("===========id====$user=========id==========");
    print("===========id====$idp=========id==========");
    //String idps = "$idp";
    var resi = await http.post(
        Uri.parse(
            "https://asamexico.com.mx/php/controller/crearlogcliente.php"),
        body: {
          "referencia_cliente": idp,
          "usuario_alta": user,
          "id_cliente": idp,
          "comentarios": comentariosctl.text
        }); //sending post request with header data

    if (resi.statusCode == 200) {
      print(resi);

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

        print("$estado");
        //print(usuario);
        //after write success, make fields empty
        print("===========id====$idp=========id==========");
        setState(() {
          sending = false;
          success = true;
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

class LogtareasState extends StatefulWidget {
  final String? idcliente;
  //final String usuario;
  LogtareasState(this.idcliente);

  @override
  State<StatefulWidget> createState() {
    return Logtareas(this.idcliente);
  }
}

class Logtareas extends State<LogtareasState> {
  final String? idcliente;
  //final String usuario;
  //TextEditingController comentariosctl = TextEditingController();
  //TextEditingController idctl = TextEditingController();
  Logtareas(
    this.idcliente,
  );

  String estado = "";
  bool? error, sending, success;
  String? msg;
  String? user = "";
  // API URL
  final url = Uri.parse(
    'https://asamexico.com.mx/php/controller/logclientes.php',
  );

  Future<List<Logstareas>?> flistlogs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = prefs.getString('nuser');

    var data = {'id': ("$idcliente")};

    var response = await http.post(url, body: json.encode(data));
    print(data);
    if (response.statusCode == 200) {
      print(response.statusCode);
      //print("==========aqui=====$user==========aqui==========");
      //print("===============$idcliente====================");
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      print(response.body);

      List<Logstareas>? logstarasList = items.map<Logstareas>((json) {
        return Logstareas.fromJson(json);
      }).toList();

      return logstarasList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Logstareas>?>(
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
