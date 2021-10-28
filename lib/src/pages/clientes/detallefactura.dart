import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
//import 'package:shared_preferences/shared_preferences.dart';

class Detallesfactura extends StatefulWidget {
  final String? uuid;
  Detallesfactura(this.uuid);

  @override
  _DetallesfacturaState createState() => _DetallesfacturaState(uuid);
}

@override
void initState() {}

TextEditingController vencimientoctl = new TextEditingController();
TextEditingController emailctl = new TextEditingController();
TextEditingController notasctl = new TextEditingController();
TextEditingController contactoctl = new TextEditingController();

clearTextInput() {
  notasctl.clear();
  vencimientoctl.clear();
  emailctl.clear();
  contactoctl.clear();
}

String? _folio;
String? _nombrereceptor;
String? _total = '0.0';
String? _pagada;
String? _fecha;
String? _fechavigencia;
String? _email;
String? _contacto;
String? _notas;
String estado = "";
bool? error, sending, success;
String? msg;

final apiurl1 = Uri.parse(
  'https://asamexico.com.mx/php/controller/cfdiemitida.php',
);

class _DetallesfacturaState extends State<Detallesfactura> {
  final String? uuid;

  _DetallesfacturaState(this.uuid);

  // ignore: missing_return
  Future<String?> recibirString() async {
    var data = {'id': (this.uuid)};
    final respuesta = await http.post(apiurl1, body: json.encode(data));
    if (respuesta.statusCode == 200) {
      print('===$data====');
      setState(() {
        var parsedJson = json.decode(respuesta.body);
        _folio = parsedJson["folio"];
        _nombrereceptor = parsedJson["nombrereceptor"];
        _total = parsedJson["total"];
        _pagada = parsedJson["pagada"];
        _fecha = parsedJson["fechafactura"];
        _fechavigencia = parsedJson["fechavigencia"];
        _email = parsedJson["email"];
        _contacto = parsedJson["contacto"];
        _notas = parsedJson["notas"];
      });
    } else {
      throw Exception("Fallo");
    }
  }

  @override
  void initState() {
    recibirString();
    super.initState();
    // emailctl = new TextEditingController(text: "");
    // notasctl = new TextEditingController(text: "");
    // contactoctl = new TextEditingController(text: "");
    // vencimientoctl = new TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    dynamic totalf = double.parse(_total!);
    DateTime fecha1 = DateTime.parse(_fecha!);
    String fecha = DateFormat("dd-MM-yyyy").format(fecha1);

    final format = DateFormat("dd-MM-yyyy");
    print(widget.uuid);
    print(_pagada.toString());
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle Cliente')),
      body: SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            Container(
              height: 70,
              width: MediaQuery.of(context).size.width * 1,
              color: Color.fromRGBO(35, 56, 120, 1.0),
              child: Center(
                child: Text(
                  'Detalles de factura',
                  style: TextStyle(
                    color: Color(0xff827daa),
                  ),
                  textAlign: TextAlign.center,
                ),
                // Text("hola"),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 60,
              width: 350,
              child: Center(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        NumberFormat.currency(locale: 'es-mx').format(totalf),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2),
                        textAlign: TextAlign.center,
                      ))),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0), color: color()),
            ),
            SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: new Column(children: <Widget>[
                  new ListTile(
                    leading: const Icon(Icons.account_circle_rounded),
                    title: Text(_nombrereceptor!),
                    subtitle: const Text('Nombre Cliente'),
                  ),
                  new ListTile(
                    leading: const Icon(Icons.file_copy),
                    title: Text(_folio!),
                    subtitle: const Text('No. de Factura'),
                  ),
                  new ListTile(
                    leading: const Icon(Icons.label),
                    title: Text(widget.uuid!),
                    subtitle: const Text('UUID Factura'),
                  ),
                  new ListTile(
                      leading: const Icon(Icons.today),
                      title: Text(
                        fecha,
                      ),
                      subtitle: const Text('Fecha Factura')),
                  new ListTile(
                      leading: const Icon(Icons.today),
                      title: new DateTimeField(
                        controller: vencimientoctl,
                        format: format,
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2100));
                        },
                        keyboardType: TextInputType.datetime,
                        decoration: new InputDecoration(
                          hintText: _fechavigencia,
                        ),
                      ),
                      subtitle: const Text('Fecha vencimiento')),
                  new ListTile(
                    leading: const Icon(Icons.email),
                    title: new TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailctl,
                        decoration: new InputDecoration(
                          hintText: _email,
                        )),
                    subtitle:
                        const Text('correo@empresa.com; correo2@empresa.com'),
                  ),
                  new ListTile(
                    leading: const Icon(Icons.group),
                    title: new TextField(
                        controller: contactoctl,
                        decoration: new InputDecoration(
                          hintText: _contacto,
                        )),
                    subtitle: const Text('Contacto Principal'),
                  ),
                  new ListTile(
                    leading: const Icon(Icons.note_add),
                    title: new TextField(
                        keyboardType: TextInputType.multiline,
                        controller: notasctl,
                        decoration: new InputDecoration(
                          hintText: _notas,
                        )),
                    subtitle: const Text('Comentarios adicionales'),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () => savecancelada(context, uuid),
                        color: Colors.white,
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          // Replace with a Row for horizontal icon + text
                          children: <Widget>[
                            Icon(
                              Icons.close,
                              color: Colors.redAccent,
                            ),
                            Text("Cancelada",
                                style: TextStyle(color: Colors.redAccent))
                          ],
                        ),
                      ),
                      FlatButton(
                        onPressed: () => savedata(context, uuid),
                        color: Colors.white,
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          // Replace with a Row for horizontal icon + text
                          children: <Widget>[
                            Icon(
                              Icons.today,
                              color: Colors.orangeAccent,
                            ),
                            Text("Programar recordatorio",
                                style: TextStyle(color: Colors.orange))
                          ],
                        ),
                      ),
                      FlatButton(
                        onPressed: () => {
                          print(emailctl.text),
                          print(vencimientoctl.text),
                          print(contactoctl.text),
                          print(notasctl.text),
                          savedatapago(context, uuid)
                        },
                        color: Colors.white,
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          // Replace with a Row for horizontal icon + text
                          children: <Widget>[
                            Icon(Icons.check, color: Colors.green),
                            Text("Pagada",
                                style: TextStyle(color: Colors.green))
                          ],
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> savedata(BuildContext context, uuid) async {
    String user = "";
    String idp = "";

    //SharedPreferences prefs = await SharedPreferences.getInstance();
    //user = prefs.getString('nuser');
    // final urlinsert = Uri.parse(
    //   'https://asamexico.com.mx/php/controller/categoria.php?op=Insert');
    idp = uuid.toString();
    print("===========id====$user=========id==========");
    print("===========id====$idp=========id==========");
    //String idps = "$idp";
    var resi = await http.post(
        Uri.parse("https://asamexico.com.mx/php/controller/uprecordatorio.php"),
        body: {
          "uuid": idp,
          "vencimiento": vencimientoctl.text,
          "email": emailctl.text,
          "contacto": contactoctl.text,
          "notas": notasctl.text
        }); //sending post request with header data

    if (resi.statusCode == 200) {
      print(resi);
      print(emailctl.text);
      print(vencimientoctl.text);
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
        print("===========id====$idp=========id==========");
        setState(() {
          sending = false;
          success = true;
          showAlertDialog(context);

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

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
        child: Text("OK"),
        onPressed: () {
          setState(() {
            recibirString();
          });
          clearTextInput();
          Navigator.pop(context);
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Estado"),
      content: Text(
          "Se ha marcado como pendiente de pago, y se enviaran notificaciones de cobranza el destinatario indicado, apartir de la fecha de vencimiento indicada."),
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

  Future<void> savedatapago(BuildContext context, uuid) async {
    //String user = "";
    String idp = "";

    //SharedPreferences prefs = await SharedPreferences.getInstance();
    //user = prefs.getString('nuser');
    // final urlinsert = Uri.parse(
    //   'https://asamexico.com.mx/php/controller/categoria.php?op=Insert');
    idp = uuid.toString();
    print("===========id====$idp=========id==========");
    print(emailctl.text);
    print(vencimientoctl.text);
    print(contactoctl.text);
    print(notasctl.text);
    print("===========id====$idp=========id==========");

    //String idps = "$idp";
    var resi = await http.post(
        Uri.parse("https://asamexico.com.mx/php/controller/uppagada.php"),
        body: {
          "uuid": idp,
          "vencimiento": vencimientoctl.text,
          "email": emailctl.text,
          "contacto": contactoctl.text,
          "notas": notasctl.text,
        }); //sending post request with header data

    if (resi.statusCode == 200) {
      print(resi);
      print(emailctl.text);
      print(vencimientoctl.text);
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
        print("===========id====$idp=========id==========");
        setState(() {
          sending = false;
          success = true;
          showAlertDialogP(context);
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

  showAlertDialogP(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
        child: Text("OK"),
        onPressed: () {
          setState(() {
            recibirString();
          });
          clearTextInput();
          Navigator.pop(context);
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Estado"),
      content: Text(
          "Se ha marcado como pagada, ya no se enviaran notificaciones de cobro."),
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

  Future<void> savecancelada(BuildContext context, uuid) async {
    //String user = "";
    String idp = "";

    //SharedPreferences prefs = await SharedPreferences.getInstance();
    //user = prefs.getString('nuser');
    // final urlinsert = Uri.parse(
    //   'https://asamexico.com.mx/php/controller/categoria.php?op=Insert');
    idp = uuid.toString();
    print("===========id====$idp=========id==========");
    print(emailctl.text);
    print(vencimientoctl.text);
    print(contactoctl.text);
    print(notasctl.text);
    print("===========id====$idp=========id==========");

    //String idps = "$idp";
    var resi = await http.post(
        Uri.parse("https://asamexico.com.mx/php/controller/upcancelada.php"),
        body: {
          "uuid": idp,
          "vencimiento": vencimientoctl.text,
          "email": emailctl.text,
          "contacto": contactoctl.text,
          "notas": notasctl.text,
        }); //sending post request with header data

    if (resi.statusCode == 200) {
      print(resi);
      print(emailctl.text);
      print(vencimientoctl.text);
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
        print("===========id====$idp=========id==========");
        setState(() {
          sending = false;
          success = true;
          showAlertDialogC(context);
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

  showAlertDialogC(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
        child: Text("OK"),
        onPressed: () {
          setState(() {
            recibirString();
          });
          clearTextInput();
          Navigator.pop(context);
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Estado"),
      content: Text(
          "Se ha marcado como cancelada, no contara en la estadistica de ventas."),
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

  color() {
    if (_pagada == '1') {
      // ignore: unnecessary_statements
      return Colors.green;
    } else if (_pagada == '3') {
      // ignore: unnecessary_statements
      return Colors.red;
    } else
      // ignore: unnecessary_statements
      return Colors.orange;
  }
}
