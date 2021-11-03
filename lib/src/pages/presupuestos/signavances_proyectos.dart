import 'package:asa_mexico/src/pages/pruebas/pruebas2.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

String estado = "";
bool error = false, sending = false, success = false;
String msg = "";

class SignAvance extends StatefulWidget {
  final String cantidad;
  final String fecha;
  final String sistemas;
  const SignAvance(this.cantidad, this.fecha, this.sistemas);
  @override
  State<SignAvance> createState() => _SignAvanceState();
}

final SignatureController _controller = SignatureController(
  penStrokeWidth: 1,
  penColor: Colors.black,
  exportBackgroundColor: Colors.white,
);

class _SignAvanceState extends State<SignAvance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generar acuse de Avance'),
        backgroundColor: Color.fromRGBO(35, 56, 120, 1.0),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Icon(
                Icons.assignment_outlined,
                color: Colors.orange,
                size: 40,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  margin: EdgeInsets.all(10),
                  child: Table(
                    border: TableBorder.all(
                      color: Color.fromRGBO(35, 56, 120, 1.0),
                    ),
                    children: [
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Dia: '),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.fecha,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Cantidad: '),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.cantidad,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Sistema: '),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.sistemas,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ]),
                    ],
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Color.fromRGBO(35, 56, 120, 1.0),
                )),
                child: Signature(
                  controller: _controller,
                  height: 300,
                  backgroundColor: Colors.white,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text('Favor de firmar el acuse de avance'),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(35, 56, 120, 1.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    //SHOW EXPORTED IMAGE IN NEW ROUTE
                    IconButton(
                      icon: const Icon(Icons.check),
                      color: Colors.white,
                      onPressed: () {
                        log('hola');
                        print(widget.sistemas);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => MyApp1()));
                      },
                      // onPressed: () async {
                      //   if (_controller.isNotEmpty) {
                      //     final data = await _controller.toPngBytes();
                      //     if (data != null) {
                      //       data != null ? registrar() : Container();
                      //     }
                      //   }
                      // },
                    ),
                    //CLEAR CANVAS
                    IconButton(
                      icon: const Icon(Icons.clear),
                      color: Colors.white,
                      onPressed: () {
                        setState(() => _controller.clear());
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void guardar(String sistemas) async {
    print('=======$sistemas========');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    //String usuario = prefs.getString('nuser');

    var resi = await http.post(
        Uri.parse(
            "https://asamexico.com.mx/php/controller/altasistemaproyec.php"),
        body: {}); //sending post request with header data

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
