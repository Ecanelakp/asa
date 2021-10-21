import 'package:asa_mexico/src/pages/presupuestos/Presupuestovieslist.dart';
//import 'package:asa_mexico/src/pages/presupuestos/presupuestolist_home.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class Presupuestos2 extends StatefulWidget {
  @override
  _PresupuestosState createState() => _PresupuestosState();
  final String usuario;

  const Presupuestos2(this.usuario, {Key key}) : super(key: key);
}

class _PresupuestosState extends State<Presupuestos2> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Proyectos'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.construction_sharp),
              ),
              Tab(
                icon: Icon(Icons.list),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            JsonSpinner(widget.usuario),
            Center(
              child: Datainsert(widget.usuario),
            ),
          ],
        ),
      ),
    );
  }
}

class JsonSpinner extends StatefulWidget {
  JsonSpinnerWidget createState() => JsonSpinnerWidget();
  final String usuario;
  const JsonSpinner(this.usuario, {Key key}) : super(key: key);
}

class JsonSpinnerWidget extends State<JsonSpinner> {
  String selectedSpinnerItem = '1104-001';
  List data = [];
  Future myFuture;
  final format = ("yyyy-MM-dd");
  TextEditingController referenciactl = TextEditingController();
  TextEditingController proyectoctl = TextEditingController();
  TextEditingController responsablectl = TextEditingController();
  TextEditingController noclientectl = TextEditingController();
  TextEditingController observacionesctl = TextEditingController();
  TextEditingController fechapagoctl = new TextEditingController();

  String estado = "";
  bool error, sending, success;
  String msg;
  String _fechapago;
  final format1 = DateFormat("dd-MM-yyyy");

  final url = Uri.parse(
      'https://asamexico.com.mx/php/controller/clientes.php?op=GetClientes');

  Future<String> fetchData() async {
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var res = await http.get(url);

      var resBody = json.decode(res.body);

      print(resBody);

      setState(() {
        data = resBody;
      });

      print('Loaded Successfully');

      return "Loaded Successfully";
    } else {
      throw Exception('Failed to load data.');
    }
  }

  @override
  void initState() {
    myFuture = fetchData();
    error = false;
    sending = false;
    success = false;
    msg = "";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var startdate = DateTime.now();
    var finaldate = DateTime.now();

    return FutureBuilder<String>(
        future: myFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return Scaffold(
            body: Center(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Crear un Proyecto',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Color.fromRGBO(35, 56, 120, 1.0)),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                          controller: noclientectl,
                          //onSaved: (value)=> ,
                          enabled: false,
                          obscureText: true,
                          decoration: InputDecoration(
                            icon: Icon(Icons.account_circle_sharp,
                                color: Color.fromRGBO(35, 56, 120, 1.0)),
                            labelText: '$selectedSpinnerItem',
                          )),
                      DropdownButtonFormField(
                        // icon: Icon(Icons.account_circle,
                        //     color: Color.fromRGBO(35, 56, 120, 1.0)),
                        items: data.map((item) {
                          return DropdownMenuItem(
                            child: Row(
                              children: [
                                Icon(Icons.account_circle,
                                    color: Color.fromRGBO(35, 56, 120, 1.0)),
                                Container(
                                    width: 300, child: Text(item['Nombre'])),
                              ],
                            ),
                            value: item['Referencia'],
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            selectedSpinnerItem = newVal;
                          });
                        },
                        value: selectedSpinnerItem,
                      ),
                      TextField(
                          controller: referenciactl,
                          decoration: InputDecoration(
                            icon: Icon(Icons.border_color,
                                color: Color.fromRGBO(35, 56, 120, 1.0)),
                            labelText: 'No. Referencia',
                          )),
                      TextField(
                          controller: proyectoctl,
                          decoration: InputDecoration(
                            icon: Icon(Icons.construction,
                                color: Color.fromRGBO(35, 56, 120, 1.0)),
                            labelText: 'Proyecto',
                          )),
                      TextField(
                          controller: responsablectl,
                          decoration: InputDecoration(
                            icon: Icon(Icons.account_circle_outlined,
                                color: Color.fromRGBO(35, 56, 120, 1.0)),
                            labelText: 'Responsable',
                          )),
                      TextField(
                          controller: observacionesctl,
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          decoration: InputDecoration(
                            icon: Icon(Icons.view_week,
                                color: Color.fromRGBO(35, 56, 120, 1.0)),
                            labelText: 'Obervaciones',
                          )),
                      Row(
                        children: [
                          Container(
                              width: 40,
                              height: 50,
                              alignment: Alignment.centerLeft,
                              child: Icon(Icons.calendar_today,
                                  color: Color.fromRGBO(35, 56, 120, 1.0))),
                          Container(
                            width: 300,
                            height: 50,
                            child: InputDatePickerFormField(
                                fieldLabelText: 'Fecha de Inicio',
                                firstDate: startdate,
                                lastDate: finaldate),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        //child: Text('Guardar'),
                        style: ElevatedButton.styleFrom(
                          primary:
                              Color.fromRGBO(35, 56, 120, 1.0), // background
                          onPrimary: Colors.white, // foreground
                        ),
                        onPressed: () {
                          setState(() {
                            sending = true;
                          });
                          sendData(widget.usuario);
                        },
                        child: Text(
                          sending ? "Salvando..." : "Guardar",
                          //if sending == true then show "Sending" else show "SEND DATA";
                        ),
                      ),
                      Container(
                        height: 20,
                        child: Text("$estado",
                            style: TextStyle(
                              color: Colors.blue,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            )),
          );
        });
  }

  Future<void> sendData(usuario) async {
    // final urlinsert = Uri.parse(
    //   'https://asamexico.com.mx/php/controller/categoria.php?op=Insert');

    var resi = await http.post(
        Uri.parse("https://asamexico.com.mx/php/controller/crearproyecto.php"),
        body: {
          "referencia": referenciactl.text,
          "proyecto": proyectoctl.text,
          "nocliente": '$selectedSpinnerItem',
          "responsable": responsablectl.text,
          "observaciones": observacionesctl.text,
          "usuario": usuario,
        }); //sending post request with header data

    if (resi.statusCode == 200) {
      print(resi);
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
        referenciactl.text = "";
        proyectoctl.text = "";
        observacionesctl.text = "";
        responsablectl.text = "";
        estado = "Se ha guardado con exito";
        print("$estado");
        print(usuario);
        //after write success, make fields empty

        setState(() {
          sending = false;
          success = true; //mark success and refresh UI with setState
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
}
