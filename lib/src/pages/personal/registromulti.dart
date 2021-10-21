import 'package:asa_mexico/src/models/models_personal.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'maps_personal.dart';

class Multiregistro extends StatefulWidget {
  const Multiregistro({
    Key key,
  }) : super(key: key);

  @override
  _MultiregistroState createState() => _MultiregistroState();
}

class _MultiregistroState extends State<Multiregistro> {
  @override
  void initState() {
    _getLocation().then((value) {
      setState(() {
        userLocation = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            child: userLocation == null
                ? CircularProgressIndicator()
                : Text(
                    "Location:" +
                        userLocation.latitude.toString() +
                        " " +
                        userLocation.longitude.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(child: Container(child: Multiregister())),
        ],
      ),
    );
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
}

Position userLocation;
String _tipo = 'entrada';
bool sending;
bool error;
bool success;
String msg; //error message from server
String estado;
String _acceso;
Geolocator geolocator = Geolocator();

class Multiregister extends StatefulWidget {
  @override
  _MultiregisterState createState() => _MultiregisterState();
}

final apiurl = Uri.parse(
  'https://asamexico.com.mx/php/controller/listapersonal.php',
);

Future<List<Personallist>> listaregistro() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  _acceso = prefs.getString('acceso');
  var response = await http.get(apiurl);
  //print('====aqui =====$nmes===========aqui');
  if (response.statusCode == 200) {
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    //print(response.body);
    List<Personallist> personallist = items.map<Personallist>((json) {
      return Personallist.fromJson(json);
    }).toList();

    return personallist;
  } else {
    throw Exception('Failed to load data from Server.');
  }
}

class _MultiregisterState extends State<Multiregister> {
  @override
  Widget build(BuildContext context) {
    listaregistro();
    return FutureBuilder<List<Personallist>>(
        future: listaregistro(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return ListView(
              children: snapshot.data
                  .map((data) => Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      //Centramos con el Widget <a href="https://zimbronapps.com/flutter/center/">Center</a>
                      child: Card(
                        color: Colors.white,
                        child: ListTile(
                          leading: Icon(Icons.account_circle,
                              size: 30.0,
                              color: Color.fromRGBO(35, 56, 120, 1.0)),
                          title: Text(data.fullname),
                          subtitle: Text(data.puesto),
                          trailing: Icon(Icons.access_alarm,
                              size: 30,
                              color: data.tipo == 'entrada'
                                  ? Colors.red
                                  : Colors.green),
                          onTap: () {
                            registromulti(
                                data.nombrecorto, data.fullname, data.tipo);
                          },
                          onLongPress: () {
                            print(_acceso);
                            _acceso == 'full'
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Mapersonal(
                                            data.fullname,
                                            data.tipo,
                                            data.latitude,
                                            data.longitude,
                                            data.fechareg)))
                                : print('sin acceso');
                          },
                        ),
                      )))
                  .toList());
        });
  }

  Future<void> registromulti(
      String nombrecorto, String fullname, String tipo) async {
    var resi = await http.post(
        Uri.parse(
            "https://asamexico.com.mx/php/controller/asistenciapersonal.php"),
        body: {
          "usuario": nombrecorto,
          "nombre": fullname,
          "tipo": tipo == 'entrada' ? 'salida' : 'entrada',
          "fechareg": '0',
          "latitude": userLocation.latitude.toString(),
          "longitude": userLocation.longitude.toString(),
        }); //sending post request with header data
    print(nombrecorto);
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
          listaregistro();
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
