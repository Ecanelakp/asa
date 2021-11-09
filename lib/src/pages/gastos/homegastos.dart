//import 'package:asa_mexico/src/pages/gastos/listagastos.dart';

import 'dart:developer';

import 'package:asa_mexico/src/Provider/meselectg.dart';

import 'package:asa_mexico/src/pages/gastos/detagastos.dart';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

String _nmes = '';

class Homegastos extends StatelessWidget {
  final String usuario;
  @override
  const Homegastos(this.usuario, {Key? key}) : super(key: key);
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Gastos'),
          backgroundColor: Color.fromRGBO(35, 56, 120, 1.0),
        ),
        body: Container(
          constraints: new BoxConstraints.expand(),
          child: ChangeNotifierProvider(
            create: (_) => Mesesg(),
            child: Stack(children: [
              Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: double.infinity,
                  color: Color.fromRGBO(35, 56, 120, 1.0),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 50),
                        const SizedBox(height: 20),
                        const Text(
                          'Gastos del Mes',
                          style: TextStyle(
                            color: Color(0xff827daa),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Pagina(),
                      ],
                    ),
                  )),
              Positioned(
                left: MediaQuery.of(context).size.width * 0.05,
                top: 150.0,
                child: Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MesesListView(context),
                  )),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.redAccent,
                  ),
                ),
              ),
              Positioned(
                left: 20.0,
                top: 250.0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: MainListView(context),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                  ),
                ),
              ),
            ]),
          ),
        ));
  }
}

class Studentdata {
  int? idrecepcion;
  dynamic rfcemisor;
  dynamic nemisor;
  dynamic folio;
  dynamic uuid;
  dynamic total;
  String? metodop;
  dynamic fecha;
  String? departamento;
  String? categoria;
  String? concepto;
  int? pagada;
  dynamic fechapago;
  String? referenciacliente;
  String? moneda;
  dynamic tipocambio;

  Studentdata(
      {this.idrecepcion,
      this.rfcemisor,
      this.nemisor,
      this.folio,
      this.uuid,
      this.total,
      this.metodop,
      this.fecha,
      this.departamento,
      this.categoria,
      this.concepto,
      this.pagada,
      this.fechapago,
      this.referenciacliente,
      this.moneda,
      this.tipocambio});

  factory Studentdata.fromJson(Map<String, dynamic> json) {
    return Studentdata(
        idrecepcion: json['id_recepcion'],
        rfcemisor: json['rfc_emisor'],
        nemisor: json['nombre_emisor'],
        folio: json['folio'],
        uuid: json['uuid'],
        total: json['total'],
        metodop: json['metodop'],
        fecha: json['fecha'],
        departamento: json['Departamento'],
        categoria: json['Categoria'],
        concepto: json['Concepto'],
        pagada: json['Pagada'],
        fechapago: json['Fechapago'],
        referenciacliente: json['Referencia_cliente'],
        moneda: json['Moneda'],
        tipocambio: json['TipoCambio']);
  }
}

class MainListView extends StatefulWidget {
  MainListView(BuildContext context);

  MainListViewState createState() => MainListViewState();
}

class MainListViewState extends State {
  final apiurl = Uri.parse(
    'https://asamexico.com.mx/php/controller/gastosxmes.php',
  );

  //String user = this.usuario;
  Future<List<Studentdata>?> fetchStudents() async {
    var data = {'nmes': _nmes.toString()};
    var response = await http.post(apiurl, body: json.encode(data));
    //print('====aqui =====$nmes===========aqui');
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

  @override
  Widget build(BuildContext context) {
    final wmes = Provider.of<Mesesg>(context);
    _nmes = wmes.mesg;
    fetchStudents();
    return FutureBuilder<List<Studentdata>?>(
      future: fetchStudents(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return ListView(
          children: snapshot.data!
              .map((data) => Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    //Centramos con el Widget <a href="https://zimbronapps.com/flutter/center/">Center</a>
                    child: Dismissible(
                      key: UniqueKey(),
                      onDismissed: (DismissDirection direction) {
                        if (direction == DismissDirection.startToEnd) {
                          print("Add to favorite");
                          cancelada(data.uuid);
                        } else {
                          print('Remove item');
                          cancelada(data.uuid);
                        }

                        setState(() {});
                      },
                      child: Card(
                        color: Colors.white,
                        child: ListTile(
                            leading: Icon(Icons.monetization_on_outlined,
                                size: 30.0,
                                color: Color.fromRGBO(35, 56, 120, 1.0)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Fecha: " + data.fecha,
                                    style: TextStyle(
                                        color: Colors.black87, fontSize: 11.0)),
                                Text(
                                    data.moneda == 'USD'
                                        ? "Total: \u0024  " +
                                            NumberFormat.currency(
                                                    locale: 'en_US')
                                                .format(data.total)
                                        : "Total: \u0024 " +
                                            NumberFormat.currency(
                                                    locale: 'es_MX')
                                                .format(data.total),
                                    style: TextStyle(color: Colors.redAccent)),
                                Text(data.uuid.toString(),
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 11.0)),
                                Text(
                                    data.departamento! +
                                        ' || ' +
                                        data.categoria!,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 11.0)),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Detagastos(
                                          nemisor: data.nemisor,
                                          fecha: data.fecha,
                                          total: data.total.toString(),
                                          departamento: data.departamento,
                                          categoria: data.categoria,
                                          concepto: data.concepto,
                                          pagada: data.pagada,
                                          uuid: data.uuid,
                                          referencia: data.referenciacliente,
                                          tipocambio: data.moneda == 'USD'
                                              ? data.tipocambio
                                              : 1.00)));
                              print(data.departamento);
                              print(data.uuid);
                            },
                            trailing: data.pagada == 1
                                ? Icon(Icons.check_circle,
                                    size: 30.0, color: Colors.green)
                                : Icon(Icons.close_rounded,
                                    size: 30.0, color: Colors.red),
                            //Agregamos el nombre con un Widget Text
                            title: Text(data.nemisor,
                                style: TextStyle(
                                    color: Color.fromRGBO(35, 56, 120, 1.0),
                                    fontSize: 14.0)
                                //le damos estilo a cada texto
                                )),
                      ),
                      background: Container(
                        color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.white),
                              Text('Cancelar documento',
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      confirmDismiss: (DismissDirection direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Marcar como cancelada"),
                              content: const Text(
                                  "Desea cancelar el documento seleccionado?"),
                              actions: <Widget>[
                                FlatButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text("Si")),
                                FlatButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text("No"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ))
              .toList(),
        );
      },
    );
  }

  Future<void> cancelada(uuid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    usuario = prefs.getString('nuser');
    var resi = await http.post(
        Uri.parse(
            "https://asamexico.com.mx/php/controller/upgastocancelada.php"),
        body: {
          "usuario": usuario,
          "uuid": uuid
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
        estado = "Se ha actualizado";
        print("$estado");

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

class Pagina extends StatefulWidget {
  @override
  _PaginaState createState() => _PaginaState();
}

String _mensaje = "";
final apiurl1 = Uri.parse(
  'https://asamexico.com.mx/php/controller/gastossummes.php',
);

class _PaginaState extends State<Pagina> {
  // ignore: missing_return
  Future<String?> recibirString() async {
    var data = {'nmes': _nmes.toString()};
    final respuesta = await http.post(apiurl1, body: json.encode(data));
    if (respuesta.statusCode == 200) {
      //log(respuesta.body.toString());
      setState(() {
        _mensaje = respuesta.body.toString();
      });
    } else {
      throw Exception("Fallo");
    }
  }

  @override
  void initState() {
    recibirString();
    super.initState();
    _mensaje = '0';
  }

  @override
  Widget build(BuildContext context) {
    final wmes = Provider.of<Mesesg>(context);

    _nmes = wmes.mesg;
    recibirString();
    dynamic gasto = double.parse(_mensaje);

    return Text(
      NumberFormat.currency(locale: 'es-mx').format(gasto),
      style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 2),
      textAlign: TextAlign.center,
    );
  }
}

class Mesesc {
  dynamic mes;
  dynamic nmes;
  dynamic total;

  Mesesc({
    this.mes,
    this.nmes,
    this.total,
  });

  factory Mesesc.fromJson(Map<String, dynamic> json) {
    return Mesesc(nmes: json['nmes'], mes: json['mes'], total: json['total']);
  }
}

class MesesListView extends StatefulWidget {
  MesesListView(BuildContext context);

  MesesListViewState createState() => MesesListViewState();
}

class MesesListViewState extends State {
  final apiurl = Uri.parse(
    'https://asamexico.com.mx/php/controller/gastosmesames.php',
  );

  //String user = this.usuario;
  Future<List<Mesesc>?> mesesc() async {
    var response = await http.get(apiurl);

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      //print(this.usuario);
      List<Mesesc>? studentList = items.map<Mesesc>((json) {
        return Mesesc.fromJson(json);
      }).toList();

      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final wmes = Provider.of<Mesesg>(context);
    return FutureBuilder<List<Mesesc>?>(
      future: mesesc(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return ListView(
          scrollDirection: Axis.horizontal,
          children: snapshot.data!
              .map(
                (data) => Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    //Centramos con el Widget <a href="https://zimbronapps.com/flutter/center/">Center</a>
                    child: ListTile(
                        leading: Icon(Icons.monetization_on_outlined,
                            color: Colors.white),
                        title: Text(
                            NumberFormat.currency(locale: 'es-mx')
                                .format(data.total),
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          wmes.mesg = data.nmes.toString();
                          log(wmes.mesg);
                        },
                        subtitle: Text(data.mes,
                            style: TextStyle(color: Colors.white60)
                            //le damos estilo a cada texto
                            ))),
              )
              .toList(),
        );
      },
    );
  }
}
