//import 'package:asa_mexico/src/pages/gastos/homegastos.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
//import 'dart:convert';
//import 'package:http/http.dart' as http;

TextEditingController fechapagoctl = new TextEditingController();
TextEditingController conceptoctl = new TextEditingController();
TextEditingController referenciactl = new TextEditingController();
TextEditingController tipocambioctl = new TextEditingController();

//TextEditingController _deptoController = new TextEditingController();
String _fechapago;
String deptoController;
String gastoController;
String seldepartamento;

bool isPagada;
String usuario;
final format = DateFormat("dd-MM-yyyy");
String estado = "";
bool error, sending, success;
String msg;

@override
void dispose() {
  deptoController = '';
  gastoController = '';
  fechapagoctl.clear();
  tipocambioctl.clear();
  //print('Disposing searchController and Widget!');
}

@override
initState() {
  fechapagoctl.clear();
  conceptoctl.clear();
  tipocambioctl.clear();

  //isPagada = false;
}

class Detagastos extends StatefulWidget {
  final String fecha;
  //final String uuid;
  final String nemisor;
  final String total;
  final String departamento;
  final String categoria;
  final String concepto;
  final int pagada;
  final String uuid;
  final String referencia;
  final dynamic tipocambio;

  const Detagastos(
      {Key key,
      this.nemisor,
      this.fecha,
      this.total,
      this.departamento,
      this.categoria,
      this.concepto,
      this.pagada,
      this.referencia,
      this.tipocambio,
      this.uuid})
      : super(key: key);

  @override
  _DetagastosState createState() => _DetagastosState();
}

class _DetagastosState extends State<Detagastos> {
  List<String> departamentos = [
    'ADMINISTRACION',
    'VENTAS',
    'ADQUISICIONES',
    'ALMACEN',
    'OPERACIONES',
    'SISTEMAS'
  ];
  List<String> gastoadmin = [
    'AUTOS',
    'COMISIONES BANCARIAS',
    'DESPENSA',
    'DONATIVOS',
    'EQUIPO DE OFICINA',
    'EQUIPO DE TRABAJO',
    'EQUIPO DE TRABAJO',
    'EQUIPO DE TRANSPORTE',
    'FLETE',
    'GASOLINA',
    'GASTOS COMPUTACIONALES',
    'GASTOS CONTABLES',
    'GASTOS MEDICOS',
    'HONORARIOS',
    'IMPORTACIONES',
    'IMPUESTOS ADUANALES',
    'IMPUESTOS',
    'MANTENIMIENTO DE LOCAL',
    'MANTENIMIENTO TRANSPORTE',
    'MATERIALES',
    'MEMBRESIAS',
    'MENSAJERIA',
    'PAPELERIA',
    'PRODUCTOS',
    'PUBLICIDAD',
    'RECARGAS Y MULTAS',
    'REGALOS',
    'RENTA DE AUTOS',
    'SEGUROS Y FIANZAS',
    'SUBCONTRATOS',
    'TELEFONOS',
    'TENENCIA Y VERIFICACIONES',
    'TIMBRADO',
    'UNIFORMES',
    'VARIOS',
    'VISAS Y PASAPORTES',
  ];
  List<String> gastosventas = [
    'EQUIPO DE TRABAJO',
    'ESTACIONAMIENTO',
    'GASOLINA',
    'GASTOS DE VIAJE',
    'JUNTAS DE TRABAJO',
    'PASAJES',
    'VIATICOS',
    'VARIOS'
  ];
  List<String> gastosAlmacen = [
    'EQUIPO DE TRABAJO',
    'FLETE',
    'HERRAMIENTAS',
    'MANTENIMIENTO Y REP DE EQUIPO',
    'PRODUCTOS',
  ];
  List<String> gastosSistemas = [
    'EQUIPO DE COMPUTO',
    'GASOLINA',
    'GASTOS COMPUTACIONALES',
    'MANTENIMIENTO Y REP DE EQUIPO',
  ];
  List<String> gastosadquisiciones = [
    'EQUIPO DE TRABAJO',
    'FLETE',
    'HERRAMIENTAS',
    'MATERIALES',
    'MANTENIMIENTO Y REP DE EQUIPO',
    'PRODUCTOS',
    'SERVICIOS',
    'VARIOS',
  ];
  List<String> gastosOperaciones = [
    'ALIMENTOS',
    'AUTOS',
    'AGUINALDOS',
    'ESTACIONAMIENTOS',
    'EQUIPO DE TRANSPORTE',
    'FLETE',
    'FINIQUITO',
    'GASOLINA',
    'GASTOS MEDICOS',
    'HERRAMIENTAS',
    'MATERIALES',
    'MANTENIMIENTO MAQUINARIA Y EQ',
    'MENSAJERIA',
    'MUESTRAS',
    'TELEFONO',
    'PASAJES',
    'RENTA DE MAQUINARIA',
    'VARIOS',
    'VIATICOS',
  ];
  List<String> tipogasto = [];
  String selectedDepartamentos;
  String selectedgastos;

  bool isPagada = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalles factura"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Container(
                color: widget.pagada == 1 ? Colors.green[100] : Colors.red[100],
                child: Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.account_balance,
                      color: Color.fromRGBO(35, 56, 120, 1.0),
                    ),
                    trailing: widget.pagada == 1
                        ? Icon(Icons.check_circle,
                            size: 30.0, color: Colors.green)
                        : Icon(Icons.close, size: 30.0, color: Colors.red),
                    title: Text(
                      widget.nemisor,
                      style: TextStyle(
                        color: Color.fromRGBO(35, 56, 120, 1.0),
                      ),
                    ),
                    subtitle: Text(widget.fecha + "   Total: " + widget.total),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: widget.pagada == 1
                              ? Colors.green[100]
                              : Colors.red[100],
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: ListTile(
                                  leading: Icon(
                                    Icons.keyboard_arrow_right_outlined,
                                    color: Color.fromRGBO(35, 56, 120, 1.0),
                                  ),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Switch(
                                        value: isPagada,
                                        onChanged: (value) {
                                          setState(() {
                                            isPagada = value;
                                            print(isPagada);
                                          });
                                        },
                                        activeTrackColor: Colors.green,
                                        activeColor: Colors.green,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                  subtitle: Text("Pagada?"),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: widget.tipocambio == 1
                                    ? Container()
                                    : ListTile(
                                        title: TextField(
                                          controller: tipocambioctl,
                                          keyboardType: TextInputType.number,
                                          decoration: new InputDecoration(
                                            hintText:
                                                widget.tipocambio.toString(),
                                          ),
                                        ),
                                        subtitle: Text("Tipo de cambio"),
                                      ),
                              )
                            ],
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.keyboard_arrow_right_outlined,
                              color: Color.fromRGBO(35, 56, 120, 1.0),
                            ),
                            title: new DateTimeField(
                              controller: fechapagoctl,
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
                                hintText: _fechapago,
                              ),
                            ),
                            subtitle: Text("Fecha pago"),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.keyboard_arrow_right_outlined,
                              color: Color.fromRGBO(35, 56, 120, 1.0),
                            ),
                            title: DropdownButton<String>(
                              isExpanded: true,
                              value: selectedDepartamentos,
                              onChanged: (departamento) {
                                if (departamento == 'ADMINISTRACION') {
                                  tipogasto = gastoadmin;
                                } else if (departamento == 'VENTAS') {
                                  tipogasto = gastosventas;
                                } else if (departamento == 'ALMACEN') {
                                  tipogasto = gastosAlmacen;
                                } else if (departamento == 'OPERACIONES') {
                                  tipogasto = gastosOperaciones;
                                } else if (departamento == 'SISTEMAS') {
                                  tipogasto = gastosSistemas;
                                } else if (departamento == 'ADQUISICIONES') {
                                  tipogasto = gastosadquisiciones;
                                } else {
                                  tipogasto = [];
                                }
                                setState(() {
                                  selectedgastos = null;
                                  selectedDepartamentos = departamento;
                                  deptoController = departamento;
                                });
                              },
                              items: departamentos.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              hint: Text('Selecciona...'),
                              elevation: 8,
                            ),
                            subtitle: Text("por departamento"),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.keyboard_arrow_right_outlined,
                              color: Color.fromRGBO(35, 56, 120, 1.0),
                            ),
                            title: DropdownButton<String>(
                              isExpanded: true,
                              value: selectedgastos,
                              onChanged: (tipogasto) {
                                setState(() {
                                  selectedgastos = tipogasto;
                                  gastoController = tipogasto;
                                });
                              },
                              items: tipogasto.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              hint: Text('Selecciona...'),
                              elevation: 8,
                            ),
                            subtitle: Text("por tipo de gasto"),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.keyboard_arrow_right_outlined,
                              color: Color.fromRGBO(35, 56, 120, 1.0),
                            ),
                            title: TextField(
                                controller: conceptoctl,
                                decoration: new InputDecoration(
                                  hintText: widget.concepto,
                                )),
                            subtitle: Text("Concepto"),
                          ),
                          SizedBox(height: 5),
                          ListTile(
                            leading: Icon(
                              Icons.keyboard_arrow_right_outlined,
                              color: Color.fromRGBO(35, 56, 120, 1.0),
                            ),
                            title: TextField(
                                controller: referenciactl,
                                decoration: new InputDecoration(
                                  hintText: widget.referencia,
                                )),
                            subtitle: Text("Proyecto/Cliente"),
                          ),
                          SizedBox(height: 10),
                        ],
                      )),
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color.fromRGBO(35, 56, 120, 1.0),
                ),
                child: TextButton.icon(
                    onPressed: () {
                      //print(deptoController);
                      print(widget.tipocambio);
                      updatagasto(context);
                    },
                    icon: Icon(Icons.save, color: Colors.white),
                    label: Text(
                      "Guardar información",
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          ),
        )),
      ),
    );
  }

  Future<void> updatagasto(BuildContext context) async {
    double tca;
    double tc;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    usuario = prefs.getString('nuser');
    tipocambioctl.text == ""
        ? tca = double.parse(widget.tipocambio.toString())
        : tc = double.parse(tipocambioctl.text);

    //String idps = "$idp";
    print(deptoController);
    print(gastoController);
    print(fechapagoctl.text);
    print(conceptoctl.text == "" ? widget.concepto : conceptoctl.text);
    //print(tipocambioctl.text);
    isPagada == false ? print('0') : print('1');
    print(widget.uuid);
    print(tipocambioctl.text == "" ? tca.toString() : tc.toString());

    var resi = await http.post(
        Uri.parse("https://asamexico.com.mx/php/controller/updetagastos.php"),
        body: {
          "departamento": deptoController,
          "categoria": gastoController,
          "concepto":
              conceptoctl.text == "" ? widget.concepto : conceptoctl.text,
          "pagada": isPagada == false ? '0' : '1',
          "fechapago": fechapagoctl.text,
          "referencia":
              referenciactl.text == "" ? widget.referencia : referenciactl.text,
          "usuario": usuario,
          "uuid": widget.uuid,
          "tipocambio":
              tipocambioctl.text == "" ? tca.toString() : tc.toString(),
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
        showAlertDialog(context);
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

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
        child: Text("OK"),
        onPressed: () {
          setState(() {
            initState();
            Navigator.of(context).pop();
          });
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Estado"),
      content: Text("Se ha cargado correctamente la informacion."),
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
}
