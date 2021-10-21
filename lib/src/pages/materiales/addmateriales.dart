import 'package:asa_mexico/src/pages/materiales/homemateriales.dart';

import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

TextEditingController fcompractl = new TextEditingController();
TextEditingController referenciactl = new TextEditingController();
TextEditingController cantidadctl = new TextEditingController();
TextEditingController preciounitarioctl = new TextEditingController();

@override
void initState() {
  Addmaterial();
}

String estado = "";
bool error, sending, success;
String msg;

class Addmaterial extends StatelessWidget {
  final int idproducto;
  final String nombre;
  final String descripcion;
  final String unidad;
  final String tipo;
  final double cantidad;

  const Addmaterial(
      {this.idproducto,
      this.nombre,
      this.descripcion,
      this.unidad,
      this.tipo,
      this.cantidad,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final format = DateFormat("dd-MM-yyyy");
    return Scaffold(
        appBar: AppBar(
          title: Text("Cargar inventario"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Text(nombre,
                  style: TextStyle(
                      color: Color.fromRGBO(35, 56, 120, 1.0),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: 5,
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Descripcion: ",
                                style: (TextStyle(
                                    color: Color.fromRGBO(35, 56, 120, 1.0),
                                    fontSize: 18)),
                              ),
                              Flexible(
                                child: Text(
                                  descripcion,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                      fontSize: 16.0,
                                      fontStyle: FontStyle.italic),
                                  maxLines: 3,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Tipo: ",
                                style: (TextStyle(
                                    color: Color.fromRGBO(35, 56, 120, 1.0),
                                    fontSize: 18)),
                              ),
                              Flexible(
                                child: Text(
                                  tipo,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                      fontSize: 16.0,
                                      fontStyle: FontStyle.italic),
                                  maxLines: 3,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Cantidad Actual: ",
                                style: (TextStyle(
                                    color: Color.fromRGBO(35, 56, 120, 1.0),
                                    fontSize: 18)),
                              ),
                              Flexible(
                                child: Text(
                                  cantidad.toString() + " " + unidad,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                      fontSize: 16.0,
                                      fontStyle: FontStyle.italic),
                                  maxLines: 3,
                                ),
                              ),
                            ],
                          ),
                          Text("Ultima compra: ",
                              style: (TextStyle(
                                  color: Color.fromRGBO(35, 56, 120, 1.0),
                                  fontSize: 18))),
                        ],
                      ))),
              SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromRGBO(35, 56, 120, 1.0),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text("Ingreso de materiales",
                            style: (TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold))),
                        Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                ListTile(
                                  trailing: Icon(Icons.file_present,
                                      color: Colors.white),
                                  leading: Icon(Icons.arrow_right,
                                      color: Colors.white),
                                  title: TextField(
                                    controller: referenciactl,
                                    style: (TextStyle(color: Colors.white)),
                                  ),
                                  subtitle: Text(
                                    "Factura relacionada",
                                    style: (TextStyle(color: Colors.white)),
                                  ),
                                  onTap: () {},
                                ),
                                ListTile(
                                  trailing: Icon(Icons.line_weight_rounded,
                                      color: Colors.white),
                                  leading: Icon(Icons.arrow_right,
                                      color: Colors.white),
                                  title: TextField(
                                    controller: cantidadctl,
                                    keyboardType: TextInputType.number,
                                    style: (TextStyle(color: Colors.white)),
                                  ),
                                  subtitle: Text(
                                    "Cantidad",
                                    style: (TextStyle(color: Colors.white)),
                                  ),
                                  onTap: () {},
                                ),
                                ListTile(
                                  trailing: Icon(Icons.attach_money,
                                      color: Colors.white),
                                  leading: Icon(Icons.arrow_right,
                                      color: Colors.white),
                                  title: TextField(
                                    controller: preciounitarioctl,
                                    keyboardType: TextInputType.number,
                                    style: (TextStyle(color: Colors.white)),
                                  ),
                                  subtitle: Text(
                                    "Precio Unitario",
                                    style: (TextStyle(color: Colors.white)),
                                  ),
                                  onTap: () {},
                                ),
                                ListTile(
                                  trailing: Icon(Icons.calendar_today,
                                      color: Colors.white),
                                  leading: Icon(Icons.arrow_right,
                                      color: Colors.white),
                                  title: DateTimeField(
                                    controller: fcompractl,
                                    format: format,
                                    onShowPicker: (context, currentValue) {
                                      return showDatePicker(
                                          context: context,
                                          firstDate: DateTime(1900),
                                          initialDate:
                                              currentValue ?? DateTime.now(),
                                          lastDate: DateTime(2100));
                                    },
                                    keyboardType: TextInputType.datetime,
                                    style: TextStyle(color: Colors.white),
                                    decoration: new InputDecoration(),
                                  ),
                                  subtitle: Text(
                                    "Fecha Compra",
                                    style: (TextStyle(color: Colors.white)),
                                  ),
                                  onTap: () {},
                                ),
                              ],
                            )),
                        SizedBox(height: 30)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // No  NombreMate  Movimiento  Fecha_reg  Cantidad  Precio_unitario   Referencia  Fecha_referencia`
            print(idproducto.toString());
            print(nombre);
            print(cantidadctl.text);
            print(preciounitarioctl.text);
            print(referenciactl.text);
            print(fcompractl.text);
            altamovprod(context, idproducto, nombre);
          },
          child: Icon(Icons.add),
        ));
  }
}

Future<void> altamovprod(BuildContext context, idproducto, nombre) async {
  String usuario;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  usuario = prefs.getString('nuser');
  //String idps = "$idp";
  var resi = await http.post(
      Uri.parse("https://asamexico.com.mx/php/controller/movmatecompra.php"),
      body: {
        "no": idproducto.toString(),
        "nombre": nombre,
        "cantidad": cantidadctl.text,
        "preciounitario": preciounitarioctl.text,
        "referencia": referenciactl.text,
        "fechareferencia": fcompractl.text,
        "usuario": usuario
      }); //sending post request with header data

  if (resi.statusCode == 200) {
    print(resi.body); //print raw response on console
    var data = json.decode(resi.body); //decoding json to array
    if (data["error"]) {
      //refresh the UI when error is recieved from server
      sending = false;
      error = true;
      msg = data["message"]; //error message from server
      estado = "Error al guardar";
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
      Addmaterial();
      referenciactl.clear();
      cantidadctl.clear();
      preciounitarioctl.clear();
      fcompractl.clear();
      showAlertDialog(context);
      clearTextInput();

      sending = false;
      success = true;
      Addmaterial();
      //showAlertDialog(context);

      //DetallesfacturaState(this.uuid);
      //Navigator.pop(context, false);
      //mark success and refresh UI with setState

    }
  } else {
    //there is error

    error = true;
    msg = "Error during sendign data.";
    sending = false;
    //mark error and refresh UI with setState

  }
}

showAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Addmaterial();

        clearTextInput();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Materialespage()));
      });

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Estado"),
    content: Text(
        "Se ha cargado correctamente la informacion, por favor revisa el inventario actual."),
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

clearTextInput() {
  referenciactl.clear();
  cantidadctl.clear();
  preciounitarioctl.clear();
  fcompractl.clear();
}
