import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Gastosproyectoslist extends StatefulWidget {
  final String id;
  Gastosproyectoslist(this.id);

  @override
  _GastosproyectoslistState createState() => _GastosproyectoslistState();
}

class _GastosproyectoslistState extends State<Gastosproyectoslist> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              "Lista de gastos",
              style: (TextStyle(
                  fontSize: 18, color: Color.fromRGBO(35, 56, 120, 1.0))),
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
  int? nogasto;
  int? idproyecto;

  //int idproducto;

  Listamaterial(
      {this.gasto, this.comentario, this.monto, this.nogasto, this.idproyecto});
  factory Listamaterial.fromJson(Map<String, dynamic> json) {
    return Listamaterial(
        gasto: json['Gasto'],
        comentario: json['Comentario'],
        monto: json['Monto'].toDouble(),
        //idproducto: json['id'],
        nogasto: json['id'],
        idproyecto: json['Proyecto_id']);
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
  String estado = "";
  bool? error, sending, success;
  String? msg;
  TextEditingController cantidadctl = new TextEditingController();
  String? mensaje;

  @override
  void initState() {
    mensaje = "";
    super.initState();
  }

  final apiurl = Uri.parse(
    'https://asamexico.com.mx/php/controller/gastosautproyecto.php',
  );

  Future<List<Listamaterial>?> fetchStudents() async {
    var data = {'id': ("${widget.id}")};
    print('========$data=======');

    var response = await http.post(apiurl, body: json.encode(data));

    //var response = await http.get(apiurl);

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      //print(this.usuario);
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
                        child: ListTile(
                          leading: Icon(Icons.attach_money_sharp,
                              color: Color.fromRGBO(35, 56, 120, 1.0)),

                          subtitle: Text(data.comentario!,
                              style: TextStyle(color: Colors.black)
                              //le damos estilo a cada texto
                              ),
                          //trailing:
                          //Agregamos el nombre con un Widget Text
                          title: Text(data.gasto!,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14.0)
                              //le damos estilo a cada texto
                              ),
                          trailing: Text(data.monto.toString(),
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

  Future<void> retornoprod(BuildContext context, int noproducto, int referencia,
      String nombre) async {
    String? usuario;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    usuario = prefs.getString('nuser');
    //String idps = "$idp";
    print(usuario);
    var resi = await http.post(
        Uri.parse(
            "https://asamexico.com.mx/php/controller/retomateproyecto.php"),
        body: {
          "no": noproducto.toString(),
          "cantidad": cantidadctl.text,
          "referencia": referencia.toString(),
          "usuario": usuario,
          "nombremate": nombre
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

  void _showAlertDialog() {
    showDialog(
        context: context,
        builder: (buildcontext) {
          return AlertDialog(
            title: Text("Error"),
            content:
                Text("No se puede regresar mas material de que se esta usando"),
            actions: <Widget>[
              RaisedButton(
                color: Colors.redAccent,
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
