import 'dart:async';
import 'package:asa_mexico/src/pages/personal/listado_personal.dart';
import 'package:asa_mexico/src/pages/personal/registromulti.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

String tipo = 'salida';

class Homepersonal extends StatefulWidget {
  final String acceso;

  const Homepersonal({this.acceso});
  @override
  HomepersonalState createState() => HomepersonalState();
}

class HomepersonalState extends State<Homepersonal> {
  String _timeString = '';
  String _nombre = '';
  bool sending;
  bool error;
  bool success;
  String msg; //error message from server
  String estado;
  String _usuario;
  Geolocator geolocator = Geolocator();

  Position userLocation;
  @override
  void initState() {
    _timeString =
        "${DateTime.now().hour} : ${DateTime.now().minute} :${DateTime.now().second}";
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());
    _getLocation().then((value) {
      setState(() {
        userLocation = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              title: Text('Registro'),
              bottom: const TabBar(
                tabs: <Widget>[
                  Tab(
                    icon: Icon(Icons.account_circle_outlined),
                  ),
                  Tab(
                    icon: Icon(Icons.supervisor_account),
                  ),
                  Tab(
                    icon: Icon(Icons.list),
                  ),
                ],
              ),
            ),
            body: TabBarView(children: <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(child: Movtipo()),
                    SizedBox(
                      height: 20,
                    ),
                    Text(_nombre,
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromRGBO(35, 56, 120, 1.0),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    userLocation == null
                        ? CircularProgressIndicator()
                        : Text(
                            "Location:" +
                                userLocation.latitude.toString() +
                                " " +
                                userLocation.longitude.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                    Text(
                      _timeString,
                      style: TextStyle(fontSize: 30),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      color: tipo == 'entrada' ? Colors.red : Colors.green,
                      child: FlatButton.icon(
                          onPressed: () {
                            _getLocation().then((value) {
                              setState(() {
                                userLocation = value;
                              });
                            });
                            registro();
                          },
                          icon: Icon(
                            Icons.timer,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Registro",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )),
                    )
                  ],
                ),
              ),
              Center(
                child: Multiregistro(),
              ),
              Center(
                child: widget.acceso == 'full'
                    ? Listapersonalregistro()
                    : Container(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('No tienes acceso'),
                          SizedBox(
                            height: 20,
                          ),
                          Icon(
                            Icons.cancel_outlined,
                            size: 50,
                            color: Colors.orangeAccent,
                          ),
                        ],
                      )),
              ),
            ])));
  }

  Future<void> _getCurrentTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _nombre = prefs.getString('nombre');
    setState(() {
      _timeString =
          "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";
    });
  }

  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  Future<void> registro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _usuario = prefs.getString('nuser');

    String _tipo = tipo == 'entrada' ? 'salida' : 'entrada';
    //print(_timeString);

    var resi = await http.post(
        Uri.parse(
            "https://asamexico.com.mx/php/controller/asistenciapersonal.php"),
        body: {
          "usuario": _usuario,
          "nombre": _nombre,
          "tipo": _tipo,
          "fechareg": _timeString,
          "latitude": userLocation.latitude.toString(),
          "longitude": userLocation.longitude.toString(),
        }); //sending post request with header data

    if (resi.statusCode == 200) {
      // print(resi.body); //print raw response on console
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

class Movtipo extends StatefulWidget {
  @override
  _MovtipoState createState() => _MovtipoState();
}

String _usuario = "";
final apiurl1 = Uri.parse(
  'https://asamexico.com.mx/php/controller/ultmovregistro.php',
);

class _MovtipoState extends State<Movtipo> {
  Future<String> recibirString() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _usuario = prefs.getString('nuser');
    String _tipo1;
    var data = {'usuario': _usuario};
    final respuesta = await http.post(apiurl1, body: json.encode(data));
    if (respuesta.statusCode == 200) {
      //log(respuesta.body.toString());
      setState(() {
        _tipo1 = respuesta.body.toString();
        if (_tipo1 == '') {
          tipo = 'salida';
        } else {
          tipo = _tipo1;
        }

        print("=========$tipo========");
      });
    } else {
      throw Exception("Fallo");
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(latitude.toString());
    recibirString();

    if (tipo == null) {
      return Text("Bienvenido", style: TextStyle(fontSize: 20));
    } else if (tipo == 'entrada') {
      return Text('Hasta luego', style: TextStyle(fontSize: 20));
    } else if (tipo == 'salida') {
      return Text('Bienvenido', style: TextStyle(fontSize: 20));
    }
  }
}
