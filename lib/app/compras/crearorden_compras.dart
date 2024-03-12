<<<<<<< HEAD
import 'package:Asamexico/app/compras/previewordenpdf_compras.dart';
import 'package:Asamexico/app/variables/colors.dart';
import 'package:Asamexico/app/variables/servicesurl.dart';
import 'package:Asamexico/app/variables/variables.dart';
import 'package:Asamexico/models/compras_model.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

List<Modellisproveedores> _sugesttionproveedor = [];
String _idproveedor = '';
String _idordencompra = '';

final _format = DateFormat("dd-MM-yyyy");
TextEditingController _fechasol = new TextEditingController();
TextEditingController _nombreproveedor = TextEditingController();
TextEditingController _notas = TextEditingController();
TextEditingController _referencia = TextEditingController();
TextEditingController _condicionesdepago = TextEditingController();
TextEditingController _formadepago = TextEditingController();
TextEditingController _nombrecontacto = TextEditingController();
TextEditingController _telefono = TextEditingController();
TextEditingController _descripcionlinea = TextEditingController();
TextEditingController _cantidadlinea = TextEditingController();
TextEditingController _pulinea = TextEditingController();
double _total = 0;

List<Lineas> lineas = [];

class Lineas {
  String? descripcion;

  String? valorunitario;
  String? cantidad;

  Lineas(
    this.descripcion,
    this.valorunitario,
    this.cantidad,
  );
}

class crearorden_compra extends StatefulWidget {
  const crearorden_compra({super.key});

  @override
  State<crearorden_compra> createState() => _crearorden_compraState();
}

class _crearorden_compraState extends State<crearorden_compra> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _descripcionlinea.clear();
    _pulinea.clear();
    _cantidadlinea.clear();
    _setTotal();
    listaproveedoes();
  }

  _setTotal() {
    _total = 0.00;

    for (var p in lineas) {
      _total += (double.parse(p.cantidad.toString()) *
          double.parse(p.valorunitario.toString()));
    }
    setState(() {});
  }

  Future<List<Modellisproveedores>> listaproveedoes() async {
    //print('======$notmes======');
    var data = {
      'tipo': 'lista_prov',
    };
    // print(data);
    final response = await http.post(urlcompras,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      // print(response.body);

      List<Modellisproveedores> studentList =
          items.map<Modellisproveedores>((json) {
        return Modellisproveedores.fromJson(json);
      }).toList();
      setState(() {});
      _sugesttionproveedor = items.map<Modellisproveedores>((json) {
        return Modellisproveedores.fromJson(json);
      }).toList();
      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear de Compra',
            style: GoogleFonts.itim(
              textStyle: TextStyle(),
            )),
        backgroundColor: azulp,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  setState(() {
                    // lineobservaciones.clear();
                    // cantidad.clear();
                    // preciounitario.clear();
                    _idproveedor = '';
                    _fechasol.clear();
                    _notas.clear();
                    _referencia.clear();
                    _condicionesdepago.clear();
                    lineas.clear();
                    _total = 0;
                  });
                },
                icon: Icon(
                  Icons.cleaning_services,
                  color: blanco,
                )),
          )
        ],
      ),
      body: Column(
        children: [
          _cabecera(),
          Text('Crear lineas',
              style: GoogleFonts.itim(
                textStyle: TextStyle(color: azuls),
              )),
          _crearlineas(),
          _lineas(),
          Spacer(),
          Container(
            color: azulp,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Total:  ',
                      style: GoogleFonts.itim(
                        textStyle: TextStyle(color: blanco),
                      )),
                  Text(NumberFormat.simpleCurrency().format(_total),
                      style: GoogleFonts.itim(
                        textStyle: TextStyle(color: blanco),
                      )),
                  Card(
                    elevation: 10,
                    color: azuls,
                    child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => previesordenpdf_compras(
                                      lineas,
                                      _nombreproveedor.text,
                                      _fechasol.text,
                                      _referencia.text,
                                      _condicionesdepago.text,
                                      _notas.text,
                                      _total)));
                        },
                        icon: Icon(
                          Icons.print,
                          color: blanco,
                        )),
                  ),
                  Card(
                    color: rojo,
                    elevation: 10,
                    child: IconButton(
                        onPressed: () {
                          guardar();
                        },
                        icon: Icon(
                          Icons.save,
                          color: blanco,
                        )),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Container _lineas() => Container(
          child: Flexible(
              child: Container(
                  child: ListView.builder(
        itemCount: lineas.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              title:
                  Text('Descripcion: ' + lineas[index].descripcion.toString(),
                      style: GoogleFonts.sulphurPoint(
                        textStyle: TextStyle(color: gris),
                      )),
              leading: Text(
                  NumberFormat.decimalPattern().format(
                      double.tryParse(lineas[index].cantidad.toString())),
                  style: GoogleFonts.sulphurPoint(
                    textStyle: TextStyle(color: gris),
                  )),
              subtitle: Text(
                  'Precio Unitario ' +
                      NumberFormat.simpleCurrency().format(double.tryParse(
                          lineas[index].valorunitario.toString())),
                  style: GoogleFonts.sulphurPoint(
                    textStyle: TextStyle(color: gris),
                  )),
              trailing: Text(
                  NumberFormat.simpleCurrency().format(
                      (double.tryParse(lineas[index].cantidad.toString())! *
                          (double.tryParse(
                              lineas[index].valorunitario.toString()))!)),
                  style: GoogleFonts.sulphurPoint(
                    textStyle: TextStyle(color: gris),
                  )),
            ),
          );
        },
      ))));

  Container _crearlineas() {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [
        Flexible(
          flex: 1,
          child: TextField(
            controller: _cantidadlinea,
            onChanged: (value) {
              setState(() {});
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
            ], // Acepta solo dígitos
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              labelText: 'Cant.',
              labelStyle: GoogleFonts.itim(textStyle: TextStyle(color: gris)),
            ),
          ),
        ),
        Flexible(
          flex: 3,
          child: TextField(
            controller: _descripcionlinea,
            onChanged: (value) {
              setState(() {});
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              labelText: 'Nombre del producto/servicio',
              labelStyle: GoogleFonts.itim(textStyle: TextStyle(color: gris)),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: TextField(
            controller: _pulinea,
            onChanged: (value) {
              setState(() {});
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
            ], // Acepta solo dígitos
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              labelText: 'PU',
              labelStyle: GoogleFonts.itim(textStyle: TextStyle(color: gris)),
            ),
          ),
        ),
        Card(
          color: _cantidadlinea.text == '' ||
                  _pulinea.text == '' ||
                  _cantidadlinea.text == ''
              ? gris
              : rojo,
          child: IconButton(
              onPressed: () {
                _cantidadlinea.text == '' ||
                        _pulinea.text == '' ||
                        _cantidadlinea.text == ''
                    ? print('nada')
                    : setState(() {
                        lineas.add(Lineas(
                          _descripcionlinea.text,
                          _pulinea.text,
                          _cantidadlinea.text,
                        ));
                        _descripcionlinea.clear();
                        _pulinea.clear();
                        _cantidadlinea.clear();
                        _setTotal();
                      });
              },
              icon: Icon(
                Icons.add,
                color: blanco,
              )),
        )
      ]),
    ));
  }

  Container _cabecera() {
    return Container(
        child: ResponsiveGridRow(
      children: [
        ResponsiveGridCol(
          xs: 6,
          md: 2,
          child: Container(
            child: ListTile(
              subtitle: Text('Selecciona un proveedor',
                  style: GoogleFonts.sulphurPoint(
                    textStyle: TextStyle(color: azulp),
                  )),
              title: Autocomplete<Modellisproveedores>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  return _sugesttionproveedor
                      .where((Modellisproveedores county) => county.nombre
                          .toLowerCase()
                          .startsWith(textEditingValue.text.toLowerCase()))
                      .toList();
                },
                displayStringForOption: (Modellisproveedores option) =>
                    option.nombre,
                fieldViewBuilder: (BuildContext context,
                    TextEditingController fieldTextEditingController,
                    FocusNode fieldFocusNode,
                    VoidCallback onFieldSubmitted) {
                  return TextField(
                      controller: fieldTextEditingController,
                      focusNode: fieldFocusNode,
                      style: GoogleFonts.sulphurPoint(
                        textStyle: TextStyle(color: azulp),
                      ),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintStyle: TextStyle(color: azuls)));
                },
                onSelected: (Modellisproveedores selection) {
                  setState(() {
                    print(selection.nombre);
                    _idproveedor = selection.id;
                    _nombreproveedor.text = selection.nombre;
                  });
                },
              ),
            ),
          ),
        ),
        ResponsiveGridCol(
            xs: 6,
            md: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: new DateTimeField(
                controller: _fechasol,
                format: _format,
                onShowPicker: (context, currentValue) {
                  return showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100));
                },
                onChanged: (string) {
                  setState(() {});
                },
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  hintText: 'Fecha requerida',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
            )),
        ResponsiveGridCol(
          xs: 12,
          md: 6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _notas,
              maxLines: 2,
              onChanged: (value) {},
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                labelText: 'Comentarios / observaciones',
                labelStyle: GoogleFonts.itim(textStyle: TextStyle(color: gris)),
              ),
            ),
          ),
        ),
        ResponsiveGridCol(
          xs: 6,
          md: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _referencia,
              onChanged: (value) {},
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                labelText: 'Referencia',
                labelStyle: GoogleFonts.itim(textStyle: TextStyle(color: gris)),
              ),
            ),
          ),
        ),
        ResponsiveGridCol(
            xs: 6,
            md: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  controller: _condicionesdepago,
                  onChanged: (value) {},
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      labelText: 'Condiciones de pago',
                      labelStyle:
                          GoogleFonts.itim(textStyle: TextStyle(color: gris)))),
            ))
      ],
    ));
  }

  Future guardar() async {
    var data = {
      'tipo': 'alta_cab_compra',
      'id_prov': _idproveedor,
      'fecharq': _fechasol.text,
      'comentarios': _notas.text,
      'referencia': _referencia.text,
      'condiciones': _condicionesdepago.text,
      'usuario': usuario,
      'iva': '1'
    };
    print(data);

    var res = await http.post(urlcompras,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    print(res.body);
    setState(() {
      _idordencompra = res.body;
    });
    lineascompra();
  }

  Future lineascompra() async {
    lineas.forEach((elemento) async {
      // print(elemento.descripcion);
      // print(elemento.comentarios);
      var data = {
        'tipo': 'alta_lin_compra',
        'id_compra': _idordencompra,
        'cantidad': elemento.cantidad,
        'descripcion': elemento.descripcion,
        'pu': elemento.valorunitario
      };
      print(data);

      var response = await http.post(urlcompras, body: json.encode(data));
      if (response.statusCode == 200) {
        //print('====aqui =');
        //print(response.body);

        setState(() {
          // lineobservaciones.clear();
          // cantidad.clear();
          // preciounitario.clear();
          _idproveedor = '';
          _fechasol.clear();
          _notas.clear();
          _referencia.clear();
          _condicionesdepago.clear();
          lineas.clear();
          _total = 0;
        });
        final snackBar = SnackBar(
          content: Text('Agregado correctamente'),
          backgroundColor: (azulp),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        throw Exception('Failed to load data from Server.');
      }
    });
    Navigator.pop(context);
  }
}
=======
import 'package:Asamexico/app/compras/previewordenpdf_compras.dart';
import 'package:Asamexico/app/variables/colors.dart';
import 'package:Asamexico/app/variables/servicesurl.dart';
import 'package:Asamexico/app/variables/variables.dart';
import 'package:Asamexico/models/compras_model.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

List<Modellisproveedores> _sugesttionproveedor = [];
String _idproveedor = '';
String _idordencompra = '';

final _format = DateFormat("dd-MM-yyyy");
TextEditingController _fechasol = new TextEditingController();
TextEditingController _nombreproveedor = TextEditingController();
TextEditingController _notas = TextEditingController();
TextEditingController _referencia = TextEditingController();
TextEditingController _condicionesdepago = TextEditingController();
TextEditingController _formadepago = TextEditingController();
TextEditingController _nombrecontacto = TextEditingController();
TextEditingController _telefono = TextEditingController();
TextEditingController _descripcionlinea = TextEditingController();
TextEditingController _cantidadlinea = TextEditingController();
TextEditingController _pulinea = TextEditingController();
double _total = 0;

List<Lineas> lineas = [];

class Lineas {
  String? descripcion;

  String? valorunitario;
  String? cantidad;

  Lineas(
    this.descripcion,
    this.valorunitario,
    this.cantidad,
  );
}

class crearorden_compra extends StatefulWidget {
  const crearorden_compra({super.key});

  @override
  State<crearorden_compra> createState() => _crearorden_compraState();
}

class _crearorden_compraState extends State<crearorden_compra> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _descripcionlinea.clear();
    _pulinea.clear();
    _cantidadlinea.clear();
    _setTotal();
    listaproveedoes();
  }

  _setTotal() {
    _total = 0.00;

    for (var p in lineas) {
      _total += (double.parse(p.cantidad.toString()) *
          double.parse(p.valorunitario.toString()));
    }
    setState(() {});
  }

  Future<List<Modellisproveedores>> listaproveedoes() async {
    //print('======$notmes======');
    var data = {
      'tipo': 'lista_prov',
    };
    // print(data);
    final response = await http.post(urlcompras,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      // print(response.body);

      List<Modellisproveedores> studentList =
          items.map<Modellisproveedores>((json) {
        return Modellisproveedores.fromJson(json);
      }).toList();
      setState(() {});
      _sugesttionproveedor = items.map<Modellisproveedores>((json) {
        return Modellisproveedores.fromJson(json);
      }).toList();
      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear de Compra',
            style: GoogleFonts.itim(
              textStyle: TextStyle(),
            )),
        backgroundColor: azulp,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  setState(() {
                    // lineobservaciones.clear();
                    // cantidad.clear();
                    // preciounitario.clear();
                    _idproveedor = '';
                    _fechasol.clear();
                    _notas.clear();
                    _referencia.clear();
                    _condicionesdepago.clear();
                    lineas.clear();
                    _total = 0;
                  });
                },
                icon: Icon(
                  Icons.cleaning_services,
                  color: blanco,
                )),
          )
        ],
      ),
      body: Column(
        children: [
          _cabecera(),
          Text('Crear lineas',
              style: GoogleFonts.itim(
                textStyle: TextStyle(color: azuls),
              )),
          _crearlineas(),
          _lineas(),
          Spacer(),
          Container(
            color: azulp,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Total:  ',
                      style: GoogleFonts.itim(
                        textStyle: TextStyle(color: blanco),
                      )),
                  Text(NumberFormat.simpleCurrency().format(_total),
                      style: GoogleFonts.itim(
                        textStyle: TextStyle(color: blanco),
                      )),
                  Card(
                    elevation: 10,
                    color: azuls,
                    child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => previesordenpdf_compras(
                                      lineas,
                                      _nombreproveedor.text,
                                      _fechasol.text,
                                      _referencia.text,
                                      _condicionesdepago.text,
                                      _notas.text,
                                      _total)));
                        },
                        icon: Icon(
                          Icons.print,
                          color: blanco,
                        )),
                  ),
                  Card(
                    color: rojo,
                    elevation: 10,
                    child: IconButton(
                        onPressed: () {
                          guardar();
                        },
                        icon: Icon(
                          Icons.save,
                          color: blanco,
                        )),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Container _lineas() => Container(
          child: Flexible(
              child: Container(
                  child: ListView.builder(
        itemCount: lineas.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              title:
                  Text('Descripcion: ' + lineas[index].descripcion.toString(),
                      style: GoogleFonts.sulphurPoint(
                        textStyle: TextStyle(color: gris),
                      )),
              leading: Text(
                  NumberFormat.decimalPattern().format(
                      double.tryParse(lineas[index].cantidad.toString())),
                  style: GoogleFonts.sulphurPoint(
                    textStyle: TextStyle(color: gris),
                  )),
              subtitle: Text(
                  'Precio Unitario ' +
                      NumberFormat.simpleCurrency().format(double.tryParse(
                          lineas[index].valorunitario.toString())),
                  style: GoogleFonts.sulphurPoint(
                    textStyle: TextStyle(color: gris),
                  )),
              trailing: Text(
                  NumberFormat.simpleCurrency().format(
                      (double.tryParse(lineas[index].cantidad.toString())! *
                          (double.tryParse(
                              lineas[index].valorunitario.toString()))!)),
                  style: GoogleFonts.sulphurPoint(
                    textStyle: TextStyle(color: gris),
                  )),
            ),
          );
        },
      ))));

  Container _crearlineas() {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [
        Flexible(
          flex: 1,
          child: TextField(
            controller: _cantidadlinea,
            onChanged: (value) {
              setState(() {});
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
            ], // Acepta solo dígitos
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              labelText: 'Cant.',
              labelStyle: GoogleFonts.itim(textStyle: TextStyle(color: gris)),
            ),
          ),
        ),
        Flexible(
          flex: 3,
          child: TextField(
            controller: _descripcionlinea,
            onChanged: (value) {
              setState(() {});
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              labelText: 'Nombre del producto/servicio',
              labelStyle: GoogleFonts.itim(textStyle: TextStyle(color: gris)),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: TextField(
            controller: _pulinea,
            onChanged: (value) {
              setState(() {});
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
            ], // Acepta solo dígitos
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              labelText: 'PU',
              labelStyle: GoogleFonts.itim(textStyle: TextStyle(color: gris)),
            ),
          ),
        ),
        Card(
          color: _cantidadlinea.text == '' ||
                  _pulinea.text == '' ||
                  _cantidadlinea.text == ''
              ? gris
              : rojo,
          child: IconButton(
              onPressed: () {
                _cantidadlinea.text == '' ||
                        _pulinea.text == '' ||
                        _cantidadlinea.text == ''
                    ? print('nada')
                    : setState(() {
                        lineas.add(Lineas(
                          _descripcionlinea.text,
                          _pulinea.text,
                          _cantidadlinea.text,
                        ));
                        _descripcionlinea.clear();
                        _pulinea.clear();
                        _cantidadlinea.clear();
                        _setTotal();
                      });
              },
              icon: Icon(
                Icons.add,
                color: blanco,
              )),
        )
      ]),
    ));
  }

  Container _cabecera() {
    return Container(
        child: ResponsiveGridRow(
      children: [
        ResponsiveGridCol(
          xs: 6,
          md: 2,
          child: Container(
            child: ListTile(
              subtitle: Text('Selecciona un proveedor',
                  style: GoogleFonts.sulphurPoint(
                    textStyle: TextStyle(color: azulp),
                  )),
              title: Autocomplete<Modellisproveedores>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  return _sugesttionproveedor
                      .where((Modellisproveedores county) => county.nombre
                          .toLowerCase()
                          .startsWith(textEditingValue.text.toLowerCase()))
                      .toList();
                },
                displayStringForOption: (Modellisproveedores option) =>
                    option.nombre,
                fieldViewBuilder: (BuildContext context,
                    TextEditingController fieldTextEditingController,
                    FocusNode fieldFocusNode,
                    VoidCallback onFieldSubmitted) {
                  return TextField(
                      controller: fieldTextEditingController,
                      focusNode: fieldFocusNode,
                      style: GoogleFonts.sulphurPoint(
                        textStyle: TextStyle(color: azulp),
                      ),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintStyle: TextStyle(color: azuls)));
                },
                onSelected: (Modellisproveedores selection) {
                  setState(() {
                    print(selection.nombre);
                    _idproveedor = selection.id;
                    _nombreproveedor.text = selection.nombre;
                  });
                },
              ),
            ),
          ),
        ),
        ResponsiveGridCol(
            xs: 6,
            md: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: new DateTimeField(
                controller: _fechasol,
                format: _format,
                onShowPicker: (context, currentValue) {
                  return showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100));
                },
                onChanged: (string) {
                  setState(() {});
                },
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  hintText: 'Fecha requerida',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
            )),
        ResponsiveGridCol(
          xs: 12,
          md: 6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _notas,
              maxLines: 2,
              onChanged: (value) {},
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                labelText: 'Comentarios / observaciones',
                labelStyle: GoogleFonts.itim(textStyle: TextStyle(color: gris)),
              ),
            ),
          ),
        ),
        ResponsiveGridCol(
          xs: 6,
          md: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _referencia,
              onChanged: (value) {},
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                labelText: 'Referencia',
                labelStyle: GoogleFonts.itim(textStyle: TextStyle(color: gris)),
              ),
            ),
          ),
        ),
        ResponsiveGridCol(
            xs: 6,
            md: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  controller: _condicionesdepago,
                  onChanged: (value) {},
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      labelText: 'Condiciones de pago',
                      labelStyle:
                          GoogleFonts.itim(textStyle: TextStyle(color: gris)))),
            ))
      ],
    ));
  }

  Future guardar() async {
    var data = {
      'tipo': 'alta_cab_compra',
      'id_prov': _idproveedor,
      'fecharq': _fechasol.text,
      'comentarios': _notas.text,
      'referencia': _referencia.text,
      'condiciones': _condicionesdepago.text,
      'usuario': usuario,
      'iva': '1'
    };
    print(data);

    var res = await http.post(urlcompras,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    print(res.body);
    setState(() {
      _idordencompra = res.body;
    });
    lineascompra();
  }

  Future lineascompra() async {
    lineas.forEach((elemento) async {
      // print(elemento.descripcion);
      // print(elemento.comentarios);
      var data = {
        'tipo': 'alta_lin_compra',
        'id_compra': _idordencompra,
        'cantidad': elemento.cantidad,
        'descripcion': elemento.descripcion,
        'pu': elemento.valorunitario
      };
      print(data);

      var response = await http.post(urlcompras, body: json.encode(data));
      if (response.statusCode == 200) {
        //print('====aqui =');
        //print(response.body);

        setState(() {
          // lineobservaciones.clear();
          // cantidad.clear();
          // preciounitario.clear();
          _idproveedor = '';
          _fechasol.clear();
          _notas.clear();
          _referencia.clear();
          _condicionesdepago.clear();
          lineas.clear();
          _total = 0;
        });
        final snackBar = SnackBar(
          content: Text('Agregado correctamente'),
          backgroundColor: (azulp),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        throw Exception('Failed to load data from Server.');
      }
    });
    Navigator.pop(context);
  }
}
>>>>>>> 7a0a6b2 (mac)
