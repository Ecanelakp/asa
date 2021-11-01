import 'package:asa_mexico/src/models/models_personal.dart';
import 'package:asa_mexico/src/models/models_sistemas.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

TextEditingController _fechainicio = new TextEditingController();
TextEditingController _cantidad = new TextEditingController();
final _format = DateFormat("dd-MM-yyyy");

final url =
    Uri.parse('https://asamexico.com.mx/php/controller/listasistemas.php');

final urlp =
    Uri.parse('https://asamexico.com.mx/php/controller/listapersonalp.php');

String? unidad = '';
String? _sistema;
String? _sistemareferencia;
String? _personal;
String estado = "";
bool? error, sending, success;
String? msg;

class Sistemasproyecto extends StatefulWidget {
  final String idHolder;
  final String? referencia;

  Sistemasproyecto(this.idHolder, this.referencia);

  @override
  _SistemasproyectoState createState() => _SistemasproyectoState();
}

class _SistemasproyectoState extends State<Sistemasproyecto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alta de sistemas'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 20),
              ListTile(
                subtitle: Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Listasistemas()),
                title: Text(
                  'Selecciona un sistema',
                  style: (TextStyle(
                    color: Color.fromRGBO(35, 56, 120, 1.0),
                  )),
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                subtitle: TextField(
                  controller: _cantidad,
                  keyboardType: TextInputType.number,
                ),
                title: Text(
                  'Cantidad',
                  style: (TextStyle(
                    color: Color.fromRGBO(35, 56, 120, 1.0),
                  )),
                ),
                leading: Icon(
                  Icons.edit,
                  color: Color.fromRGBO(35, 56, 120, 1.0),
                  size: 20,
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                  subtitle: Container(
                      height: MediaQuery.of(context).size.height * 0.09,
                      child: Listapersona()),
                  title: Text(
                    'Selecciona un responsable',
                    style: (TextStyle(
                      color: Color.fromRGBO(35, 56, 120, 1.0),
                    )),
                  )),
              SizedBox(height: 20),
              ListTile(
                subtitle: new DateTimeField(
                  controller: _fechainicio,
                  format: _format,
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                  },
                  keyboardType: TextInputType.datetime,
                  decoration: new InputDecoration(),
                ),
                title: Text(
                  'Selecciona fecha inicio',
                  style: (TextStyle(
                    color: Color.fromRGBO(35, 56, 120, 1.0),
                  )),
                ),
                leading: Icon(
                  Icons.calendar_today_rounded,
                  color: Color.fromRGBO(35, 56, 120, 1.0),
                  size: 20,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color.fromRGBO(35, 56, 120, 1.0),
                ),
                child: TextButton.icon(
                    onPressed: () {
                      guardar(
                          _sistema,
                          unidad,
                          _personal,
                          _fechainicio.text,
                          widget.idHolder,
                          widget.referencia,
                          _cantidad.text,
                          _sistemareferencia);
                    },
                    icon: Icon(Icons.save_sharp, size: 30, color: Colors.white),
                    label: Text(
                      '      Guardar      ',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  void guardar(sistema, unidad, personal, fechainicio, id, referencia, cantidad,
      sistemareferencia) async {
    print(
        '$sistema==== $unidad ==== $personal =====$fechainicio====$id=====$referencia======$cantidad');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usuario = prefs.getString('nuser');

    var resi = await http.post(
        Uri.parse(
            "https://asamexico.com.mx/php/controller/altasistemaproyecto.php"),
        body: {
          "No": id,
          "Referencia": referencia,
          "id_sistema": sistema,
          'Referencia_sistema': sistemareferencia,
          'Usuarioalta': usuario,
          'Cantidad': cantidad,
          'Responsable': personal,
          'Fecha_inicio': fechainicio,
          'Unidad': unidad,
          'Avance': '0'
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
          estado = "Error al guardar====";
        });
      } else {
        estado = "Se ha actualizado";
        print("$estado");
        Navigator.pop(context);
        setState(() {
          sending = false;
          success = true;
        });
      }
    } else {
      //there is error
      setState(() {
        error = true;
        msg = "Error during sendign data.";
        sending = false;
      });
    }
  }
}

class Listasistemas extends StatefulWidget {
  //String user = this.usuario;
  @override
  _ListasistemasState createState() => _ListasistemasState();
}

class _ListasistemasState extends State<Listasistemas> {
  Future<List<Sistemas>?> jsonsistemas() async {
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      //print(items);
      List<Sistemas>? sistemasList = items.map<Sistemas>((json) {
        return Sistemas.fromJson(json);
      }).toList();

      return sistemasList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    jsonsistemas();
    return FutureBuilder<List<Sistemas>?>(
        future: jsonsistemas(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return ListView(
              scrollDirection: Axis.horizontal,
              children: snapshot.data!
                  .map((data) => Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Card(
                          color: _sistema == data.id.toString()
                              ? Colors.lime
                              : Colors.white,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _sistema = data.id.toString();
                                _sistemareferencia = data.referencia;
                                unidad = data.unidad;

                                print(_sistema);
                              });
                            },
                            child: ExpansionTile(
                              // onTap: () {
                              //   setState(() {
                              //     _sistema = data.id.toString();
                              //     _sistemareferencia = data.referencia;
                              //     unidad = data.unidad;

                              //     //print(_sistema);
                              //   });
                              // },
                              children: [
                                Text(
                                  data.descripcion!,
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.030),
                                )
                              ],
                              title: Text(
                                data.referencia!,
                              ),
                              // subtitle: Text(
                              //   data.descripcion,
                              //   style: TextStyle(
                              //       fontSize:
                              //           MediaQuery.of(context).size.width *
                              //               0.035),
                              //)
                            ),
                          ))))
                  .toList());
        });
  }
}

class Listapersona extends StatefulWidget {
  @override
  _ListapersonaState createState() => _ListapersonaState();
}

class _ListapersonaState extends State<Listapersona> {
  Future<List<PersonallistP>?> jsonpersonal() async {
    var response = await http.get(urlp);

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      //print(items);
      List<PersonallistP>? personalList = items.map<PersonallistP>((json) {
        return PersonallistP.fromJson(json);
      }).toList();

      return personalList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    jsonpersonal();
    return FutureBuilder<List<PersonallistP>?>(
        future: jsonpersonal(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return ListView(
              scrollDirection: Axis.horizontal,
              children: snapshot.data!
                  .map((data) => Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Card(
                          color: _personal == data.nombrecorto
                              ? Colors.lime
                              : Colors.white,
                          child: ListTile(
                              onTap: () {
                                setState(() {
                                  _personal = data.nombrecorto;
                                  //print(_personal);
                                });
                              },
                              leading: Icon(
                                Icons.account_circle_rounded,
                                color: Color.fromRGBO(35, 56, 120, 1.0),
                                size: 20,
                              ),
                              title: Text(data.fullname!),
                              subtitle: Text(
                                data.puesto!,
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035),
                              )))))
                  .toList());
        });
  }
}
