import 'package:asa_mexico/src/pages/presupuestos/proyectoscomentarios.dart';
import 'package:flutter/material.dart';

import 'package:signature/signature.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

String estado = "";
bool error = false, sending = false, success = false;
String msg = "";

//String _toname = 'Agustin Perez';
// String _encargado = 'Edgardo Shancez';
// String _puesto = 'Encargado de frezzers';
// String _cantidad = '2.02';

String _titulo = 'Avance por dia';

String _firma = '';
String _usuario = '';

TextEditingController _toname = new TextEditingController();
TextEditingController _encargado = new TextEditingController();
TextEditingController _puesto = new TextEditingController();
TextEditingController _correo = new TextEditingController();
TextEditingController _comentarios = new TextEditingController();

class SignAvance extends StatefulWidget {
  final String cantidad;
  final String fecha;
  final String sistemas;
  final String correon;

  const SignAvance(this.cantidad, this.fecha, this.sistemas, this.correon);
  @override
  State<SignAvance> createState() => _SignAvanceState();
}

final SignatureController _firmacontroller = SignatureController(
  penStrokeWidth: 1,
  penColor: Colors.black,
  exportBackgroundColor: Colors.white,
);

dispose() {
  _firma = '';
  _firmacontroller.clear();
  _comentarios.clear();
  _correo.clear();
  _encargado.clear();
  _toname.clear();
  _puesto.clear();

  _firma = '';
}

class _SignAvanceState extends State<SignAvance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Generar acuse de Avance'),
        backgroundColor: Color.fromRGBO(35, 56, 120, 1.0),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: Color.fromRGBO(35, 56, 120, 1.0),
                  //                   <--- border color
                ),
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.1), BlendMode.dstATop),
                    image: AssetImage(
                      'assets/images/asablanco.jpg',
                    ),
                    fit: BoxFit.cover),
              ),
              height: MediaQuery.of(context).size.height * 0.85,
              width: MediaQuery.of(context).size.width * 1,
              child: Column(
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Fecha:      ',
                            style: TextStyle(
                              color: Color.fromRGBO(35, 56, 120, 1.0),
                            ),
                          ),
                          Text(widget.fecha),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Cantidad:    ',
                            style: TextStyle(
                              color: Color.fromRGBO(35, 56, 120, 1.0),
                            ),
                          ),
                          Text(widget.cantidad),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '    Sistemas usados:     ',
                            style: TextStyle(
                              color: Color.fromRGBO(35, 56, 120, 1.0),
                            ),
                          ),
                          Flexible(child: Text(widget.sistemas))
                        ],
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(5),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Entregado a:",
                        ),
                        controller: _toname,
                      )),
                  Container(
                      padding: EdgeInsets.all(5),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "correo:",
                        ),
                        controller: _correo,
                        keyboardType: TextInputType.emailAddress,
                      )),
                  Container(
                      padding: EdgeInsets.all(5),
                      child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Puesto:",
                          ),
                          controller: _puesto)),
                  Container(
                      padding: EdgeInsets.all(5),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Comentarios:",
                        ),
                        controller: _comentarios,
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Color.fromRGBO(35, 56, 120, 1.0),
                      )),
                      child: Signature(
                        controller: _firmacontroller,
                        height: 200,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Favor de firmar el acuse de avance'),
                  SizedBox(
                    height: 10,
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
                          // onPressed: () {
                          //   log('hola');
                          //   print(widget.sistemas);
                          //   base64Image= base64Encode(_controller.toPngBytes())
                          //   Navigator.push(context,
                          //       MaterialPageRoute(builder: (context) => MyApp1()));
                          // },
                          onPressed: () async {
                            if (_firmacontroller.isNotEmpty) {
                              final data = await _firmacontroller.toPngBytes();
                              final Uint8List bytes =
                                  data!.buffer.asUint8List();
                              final pngBytes =
                                  await FlutterImageCompress.compressWithList(
                                      bytes,
                                      quality: 40,
                                      format: CompressFormat.jpeg);
                              if (pngBytes != null) {
                                setState(() {
                                  _firma = base64Encode(pngBytes);

                                  sendmail();
                                });
                              }
                            }
                          },
                        ),
                        //CLEAR CANVAS
                        IconButton(
                          icon: const Icon(Icons.clear),
                          color: Colors.white,
                          onPressed: () {
                            setState(() => _firmacontroller.clear());
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future sendmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _usuario = prefs.getString('nuser')!;
    log(_firma);
    log(widget.correon);
    final url = Uri.parse(
        'https://asamexico.com.mx/php/controller/notificacionavancesmail.php');
    final reponse = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'titiulo': _titulo,
          'to_name': _toname.text,
          'fecha': widget.fecha,
          'quatity': widget.cantidad,
          'system': widget.sistemas,
          'user': _usuario,
          'nameencargado': _encargado.text,
          'puesto': _puesto.text,
          'para': widget.correon,
          'cc': _correo.text,
          'comentarios': comentariosctl.text,
          'firma': _firma
        }));

    log(reponse.body);
    if (reponse.body == 'Correo enviado correctamente.') {
      dispose();
      _firmacontroller.clear();
      _firma = '';
      Navigator.of(context).pop();
    }
    dispose();
    _firma = '';
    _firmacontroller.clear();
  }
}
