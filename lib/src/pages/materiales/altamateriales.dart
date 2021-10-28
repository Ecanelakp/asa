import 'package:asa_mexico/src/pages/materiales/listamateriales.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

String? _tipoController;
String? _unidadController;
TextEditingController _nombrectl = TextEditingController();
TextEditingController _descripcionctl = TextEditingController();

String estado = "";
bool sending = false;
String? msg;

initState() {
  msg = "";
  estado = "";
}

Center altamateriales() {
  return Center(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Alta de materiales",
              style: TextStyle(
                fontSize: 18,
                color: Colors.red,
              )),
          ListTile(
            leading: Icon(Icons.add_box_outlined),
            title: TextField(
              controller: _nombrectl,
            ),
            subtitle: Text("Nombre Producto"),
          ),
          ListTile(
            leading: Icon(Icons.add_box_outlined),
            title: TextField(
              controller: _descripcionctl,
            ),
            subtitle: Text("Descripcion de Producto"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: DropdownButtonFormField<String>(
              value: _tipoController,
              items: ["Consumible", "Producto", "Herramienta"]
                  .map((label) => DropdownMenuItem(
                        child: Text(label.toString()),
                        value: label,
                      ))
                  .toList(),
              hint: Text('Tipo'),
              onChanged: (value) {
                _tipoController = value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: DropdownButtonFormField<String>(
              value: _unidadController,
              items: ["pza", "kg", "lt", "gal"]
                  .map((label) => DropdownMenuItem(
                        child: Text(label.toString()),
                        value: label,
                      ))
                  .toList(),
              hint: Text('Unidad'),
              onChanged: (value) {
                _unidadController = value;
              },
            ),
          ),
          ElevatedButton(
            //child: Text('Guardar'),
            style: ElevatedButton.styleFrom(
              primary: Color.fromRGBO(35, 56, 120, 1.0), // background
              onPrimary: Colors.white, // foreground
            ),
            onPressed: () {
              guardarMateriales();
              print(_unidadController);
              print(_tipoController);
              print(_descripcionctl.text);
              //print(_nombrectl);
            },
            child: Text(
              "Guardar",
              //if sending == true then show "Sending" else show "SEND DATA";
            ),
          ),
          Text(estado),
        ],
      ),
    ),
  );
}

Future<void> guardarMateriales() async {
  print(_unidadController);
  print(_tipoController);
  print(_descripcionctl.text);
  print(_nombrectl.text);
  // final urlinsert = Uri.parse(
  //   'https://asamexico.com.mx/php/controller/categoria.php?op=Insert');

  var resi = await http.post(
      Uri.parse("https://asamexico.com.mx/php/controller/crearmateriales.php"),
      body: {
        "nombre": _nombrectl.text,
        "descripcion": _descripcionctl.text,
        "tipo": _tipoController,
        "unidad": _unidadController,
      }); //sending post request with header data

  if (resi.statusCode == 200) {
    print(resi);
    print(resi.body); //print raw response on console
    var data = json.decode(resi.body); //decoding json to array
    if (data["error"]) {
      //refresh the UI when error is recieved from server
      sending = false;
      msg = data["message"]; //error message from server
      estado = "Error al guardar";
    } else {
      _nombrectl.text = "";
      _descripcionctl.text = "";
      sending = true;
      estado = "Se ha guardado con exito";
      print("$estado");
      Wlistamateriales();
      //print(usuario);
      //after write success, make fields empty
      // ignore: unused_element

      //mark success and refresh UI with setState

    }
  } else {
    //there is error

    msg = "Error during sendign data.";

    //mark error and refresh UI with setState

  }
}
