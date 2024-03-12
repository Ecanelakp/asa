<<<<<<< HEAD
import 'package:Asamexico/app/compras/previewordenpdf_compras.dart';
import 'package:Asamexico/app/crm/cotizaciones/pdfcotizacion_clientes.dart';
import 'package:Asamexico/app/variables/colors.dart';
import 'package:Asamexico/app/variables/servicesurl.dart';
import 'package:Asamexico/app/variables/variables.dart';
import 'package:Asamexico/models/clientes_model.dart';
import 'package:Asamexico/models/productos_model.dart';

import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

List<Modellistaclientes> _sugesttioncliente = [];
List<Modellistaproductos> _sugesttionproducto = [];
String _idcliente = '';
String _idproducto = '';
String _idordencompra = '';
String _descripcion = '';
String _tipomaterial = '';

final _format = DateFormat("dd-MM-yyyy");
TextEditingController _fechasol = new TextEditingController();
TextEditingController _nombrecliente = TextEditingController();
TextEditingController _notas = TextEditingController();
TextEditingController _referencia = TextEditingController();
TextEditingController _condicionesdepago = TextEditingController();
TextEditingController _formadepago = TextEditingController();
TextEditingController _descripcionmanual = TextEditingController();
TextEditingController _telefono = TextEditingController();
TextEditingController _productolinea = TextEditingController();
TextEditingController _cantidadlinea = TextEditingController();
TextEditingController _pulinea = TextEditingController();
double _total = 0;
String _unidad = 'Selecciona unidad...';

List<String> _unidades = [
  'Selecciona unidad...',
  'KG',
  'GAL',
  'LT',
  'PZA',
  'M',
  'M2',
  'M3',
  'SER'
  // ... Agrega más códigos de monedas aquí ...
];

List<Lineascoti> lineas = [];

class Lineascoti {
  String? id;
  String? producto;
  String? unidad;
  String? valorunitario;
  String? cantidad;
  String? descripcion;

  Lineascoti(this.id, this.producto, this.unidad, this.valorunitario,
      this.cantidad, this.descripcion);
}

class altacotizacion_clientes extends StatefulWidget {
  const altacotizacion_clientes({super.key});

  @override
  State<altacotizacion_clientes> createState() =>
      _altacotizacion_clientesState();
}

class _altacotizacion_clientesState extends State<altacotizacion_clientes> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _productolinea.clear();
    _pulinea.clear();
    _cantidadlinea.clear();
    _descripcion = '';
    _setTotal();
    listaproveedoes();
    listaprod();
    _tipomaterial = 'MAT';
  }

  _setTotal() {
    _total = 0.00;

    for (var p in lineas) {
      _total += (double.parse(p.cantidad.toString()) *
          double.parse(p.valorunitario.toString()));
    }
    setState(() {});
  }

  Future<List<Modellistaclientes>> listaproveedoes() async {
    //print('======$notmes======');
    var data = {
      'tipo': 'lista_clientes',
    };
    // print(data);
    final response = await http.post(urlclientes,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      // print(response.body);

      List<Modellistaclientes> studentList =
          items.map<Modellistaclientes>((json) {
        return Modellistaclientes.fromJson(json);
      }).toList();
      setState(() {});
      _sugesttioncliente = items.map<Modellistaclientes>((json) {
        return Modellistaclientes.fromJson(json);
      }).toList();
      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  Future<List<Modellistaproductos>> listaprod() async {
    //print('======$notmes======');
    var data = {
      'tipo': 'lista_productos',
      'tipo_mat': 'Material',
    };
    //print(data);
    final response = await http.post(urlproductos,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      //print(response.body);

      List<Modellistaproductos> studentList =
          items.map<Modellistaproductos>((json) {
        return Modellistaproductos.fromJson(json);
      }).toList();
      _sugesttionproducto = items.map<Modellistaproductos>((json) {
        return Modellistaproductos.fromJson(json);
      }).toList();
      //setState(() {});
      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear cotizacion',
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
                    _idcliente = '';
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: FractionalOffset(0.0, 0.3),
              end: FractionalOffset(0.0, 0.8),
              colors: [
                blanco,
                blanco,
              ]),
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
              BlendMode.modulate,
            ),
            image: AssetImage('assets/images/asablanco.jpg'),
            fit: BoxFit.contain,
          ),
        ),
        child: Column(
          children: [
            _cabecera(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Tipo de producto a cotizar',
                    style: GoogleFonts.itim(
                      textStyle: TextStyle(color: azuls),
                    )),
                Card(
                  color: _tipomaterial == 'MAT' ? rojo : gris,
                  elevation: 10,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _tipomaterial = 'MAT';
                      });
                    },
                    child: Text(
                      'Material',
                      style: GoogleFonts.itim(
                        textStyle: TextStyle(color: blanco),
                      ),
                    ),
                  ),
                ),
                Card(
                  color: _tipomaterial == 'SER' ? rojo : gris,
                  elevation: 10,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _tipomaterial = 'SER';
                      });
                    },
                    child: Text(
                      'Servicio',
                      style: GoogleFonts.itim(
                        textStyle: TextStyle(color: blanco),
                      ),
                    ),
                  ),
                )
              ],
            ),
            _tipomaterial == 'MAT' ? _crearlineas() : _lineasmanuales(),
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
                      color: lineas.length == 0 ||
                              _nombrecliente.text == '' ||
                              _notas.text == '' ||
                              _fechasol.text == '' ||
                              _referencia.text == ''
                          ? gris
                          : azuls,
                      child: IconButton(
                          onPressed: () {
                            lineas.length == 0 ||
                                    _nombrecliente.text == '' ||
                                    _notas.text == '' ||
                                    _fechasol.text == '' ||
                                    _referencia.text == ''
                                ? print('nada')
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            pdfcotizacion_clientes(
                                                lineas,
                                                _nombrecliente.text,
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
                      color: lineas.length == 0 ||
                              _nombrecliente.text == '' ||
                              _notas.text == '' ||
                              _fechasol.text == '' ||
                              _referencia.text == ''
                          ? gris
                          : rojo,
                      elevation: 10,
                      child: IconButton(
                          onPressed: () {
                            lineas.length == 0 ||
                                    _nombrecliente.text == '' ||
                                    _notas.text == '' ||
                                    _fechasol.text == '' ||
                                    _referencia.text == ''
                                ? print('nada')
                                : guardar();
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
      ),
    );
  }

  Container _lineasmanuales() => Container(
          child: Card(
              child: Row(
        children: [
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
              controller: _descripcionmanual,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                labelText: 'Descripción',
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
          Flexible(
            flex: 1,
            child: DropdownButton<String>(
              value: _unidad,
              isExpanded: true,
              style: GoogleFonts.itim(
                textStyle: TextStyle(color: azulp),
              ),
              onChanged: (newValue) {
                setState(() {
                  _unidad = newValue.toString();
                });
              },
              items: _unidades.map((currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
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
                          lineas.add(Lineascoti(
                            _idproducto,
                            _descripcionmanual.text,
                            _unidad,
                            _pulinea.text,
                            _cantidadlinea.text,
                            _descripcion,
                          ));
                          _idproducto = '';
                          _descripcionmanual.clear();
                          _unidad = 'Selecciona unidad...';
                          _pulinea.clear();
                          _cantidadlinea.clear();
                          _descripcion = '';
                          _setTotal();
                        });
                },
                icon: Icon(
                  Icons.add,
                  color: blanco,
                )),
          )
        ],
      )));

  Container _lineas() => Container(
          child: Flexible(
              child: Container(
                  child: ListView.builder(
        itemCount: lineas.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        lineas.remove(lineas[index]);
                      });
                    },
                    icon: Icon(
                      Icons.delete,
                      color: rojo,
                    )),
                Flexible(
                  child: ListTile(
                    title: Text(lineas[index].producto.toString(),
                        style: GoogleFonts.sulphurPoint(
                          textStyle: TextStyle(color: gris),
                        )),
                    leading: Text(
                        NumberFormat.decimalPattern().format(double.tryParse(
                                lineas[index].cantidad.toString())) +
                            ' ' +
                            lineas[index].unidad.toString().toLowerCase(),
                        style: GoogleFonts.sulphurPoint(
                          textStyle: TextStyle(color: gris),
                        )),
                    subtitle: Text(
                        'Precio Unitario ' +
                            NumberFormat.simpleCurrency().format(
                                double.tryParse(
                                    lineas[index].valorunitario.toString())),
                        style: GoogleFonts.sulphurPoint(
                          textStyle: TextStyle(color: gris),
                        )),
                    trailing: Text(
                        NumberFormat.simpleCurrency().format((double.tryParse(
                                lineas[index].cantidad.toString())! *
                            (double.tryParse(
                                lineas[index].valorunitario.toString()))!)),
                        style: GoogleFonts.sulphurPoint(
                          textStyle: TextStyle(color: gris),
                        )),
                  ),
                ),
              ],
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
          child: ListTile(
            title: Autocomplete<Modellistaproductos>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                return _sugesttionproducto
                    .where((Modellistaproductos county) => county.nombre
                        .toLowerCase()
                        .startsWith(textEditingValue.text.toLowerCase()))
                    .toList();
              },
              displayStringForOption: (Modellistaproductos option) =>
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
                        labelText: 'Selecciona un producto',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        hintStyle: TextStyle(color: azuls)));
              },
              onSelected: (Modellistaproductos selection) {
                setState(() {
                  print(selection.descripcion);
                  _idproducto = selection.id;
                  _productolinea.text = selection.nombre;
                  _descripcion = selection.descripcion.toString();
                });
              },
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
        Flexible(
          flex: 1,
          child: DropdownButton<String>(
            value: _unidad,
            isExpanded: true,
            style: GoogleFonts.itim(
              textStyle: TextStyle(color: azulp),
            ),
            onChanged: (newValue) {
              setState(() {
                _unidad = newValue.toString();
              });
            },
            items: _unidades.map((currency) {
              return DropdownMenuItem<String>(
                value: currency,
                child: Text(currency),
              );
            }).toList(),
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
                        lineas.add(Lineascoti(
                          _idproducto,
                          _productolinea.text,
                          _unidad,
                          _pulinea.text,
                          _cantidadlinea.text,
                          _descripcion,
                        ));
                        _idproducto = '';
                        _productolinea.clear();
                        _unidad = 'Selecciona unidad...';
                        _pulinea.clear();
                        _cantidadlinea.clear();
                        _descripcion = '';
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
              subtitle: Text('Selecciona un cliente',
                  style: GoogleFonts.sulphurPoint(
                    textStyle: TextStyle(color: azulp),
                  )),
              title: Autocomplete<Modellistaclientes>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  return _sugesttioncliente
                      .where((Modellistaclientes county) => county.razonSocial
                          .toLowerCase()
                          .startsWith(textEditingValue.text.toLowerCase()))
                      .toList();
                },
                displayStringForOption: (Modellistaclientes option) =>
                    option.razonSocial,
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
                          labelText: 'Selecciona un cliente',
                          border: OutlineInputBorder(),
                          hintStyle: TextStyle(color: azuls)));
                },
                onSelected: (Modellistaclientes selection) {
                  setState(() {
                    print(selection.razonSocial);
                    _idcliente = selection.id;
                    _nombrecliente.text = selection.razonSocial;
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
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                labelText: 'Proyecto /Comentarios / observaciones',
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
              onChanged: (value) {
                setState(() {});
              },
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
                  onChanged: (value) {
                    setState(() {});
                  },
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
      'tipo': 'alta_cab_ventas',
      'id_cliente': _idcliente,
      'nombre_cliente': _nombrecliente.text,
      'comentarios': _notas.text,
      'referencia': _referencia.text,
      'condiciones': _condicionesdepago.text,
      'usuario': usuario,
    };
    print(data);

    var res = await http.post(urlventas,
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
        'tipo': 'alta_lin_ventas',
        'id_venta': _idordencompra,
        'id_producto': elemento.producto,
        'cantidad': elemento.cantidad,
        'descripcion': elemento.descripcion,
        'pu': elemento.valorunitario
      };
      print(data);

      var response = await http.post(urlventas, body: json.encode(data));
      if (response.statusCode == 200) {
        //print('====aqui =');
        //print(response.body);

        setState(() {
          // lineobservaciones.clear();
          // cantidad.clear();
          // preciounitario.clear();
          _idcliente = '';
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
import 'package:Asamexico/app/crm/cotizaciones/pdfcotizacion_clientes.dart';
import 'package:Asamexico/app/variables/colors.dart';
import 'package:Asamexico/app/variables/servicesurl.dart';
import 'package:Asamexico/app/variables/variables.dart';
import 'package:Asamexico/models/clientes_model.dart';
import 'package:Asamexico/models/productos_model.dart';

import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

List<Modellistaclientes> _sugesttioncliente = [];
List<Modellistaproductos> _sugesttionproducto = [];
String _idcliente = '';
String _idproducto = '';
String _idordencompra = '';
String _descripcion = '';
String _tipomaterial = '';

final _format = DateFormat("dd-MM-yyyy");
TextEditingController _fechasol = new TextEditingController();
TextEditingController _nombrecliente = TextEditingController();
TextEditingController _notas = TextEditingController();
TextEditingController _referencia = TextEditingController();
TextEditingController _condicionesdepago = TextEditingController();
TextEditingController _formadepago = TextEditingController();
TextEditingController _descripcionmanual = TextEditingController();
TextEditingController _telefono = TextEditingController();
TextEditingController _productolinea = TextEditingController();
TextEditingController _cantidadlinea = TextEditingController();
TextEditingController _pulinea = TextEditingController();
double _total = 0;
String _unidad = 'Selecciona unidad...';

List<String> _unidades = [
  'Selecciona unidad...',
  'KG',
  'GAL',
  'LT',
  'PZA',
  'M',
  'M2',
  'M3',
  'SER'
  // ... Agrega más códigos de monedas aquí ...
];

List<Lineascoti> lineas = [];

class Lineascoti {
  String? id;
  String? producto;
  String? unidad;
  String? valorunitario;
  String? cantidad;
  String? descripcion;

  Lineascoti(this.id, this.producto, this.unidad, this.valorunitario,
      this.cantidad, this.descripcion);
}

class altacotizacion_clientes extends StatefulWidget {
  const altacotizacion_clientes({super.key});

  @override
  State<altacotizacion_clientes> createState() =>
      _altacotizacion_clientesState();
}

class _altacotizacion_clientesState extends State<altacotizacion_clientes> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _productolinea.clear();
    _pulinea.clear();
    _cantidadlinea.clear();
    _descripcion = '';
    _setTotal();
    listaproveedoes();
    listaprod();
    _tipomaterial = 'MAT';
  }

  _setTotal() {
    _total = 0.00;

    for (var p in lineas) {
      _total += (double.parse(p.cantidad.toString()) *
          double.parse(p.valorunitario.toString()));
    }
    setState(() {});
  }

  Future<List<Modellistaclientes>> listaproveedoes() async {
    //print('======$notmes======');
    var data = {
      'tipo': 'lista_clientes',
    };
    // print(data);
    final response = await http.post(urlclientes,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      // print(response.body);

      List<Modellistaclientes> studentList =
          items.map<Modellistaclientes>((json) {
        return Modellistaclientes.fromJson(json);
      }).toList();
      setState(() {});
      _sugesttioncliente = items.map<Modellistaclientes>((json) {
        return Modellistaclientes.fromJson(json);
      }).toList();
      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  Future<List<Modellistaproductos>> listaprod() async {
    //print('======$notmes======');
    var data = {
      'tipo': 'lista_productos',
      'tipo_mat': 'Material',
    };
    //print(data);
    final response = await http.post(urlproductos,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      //print(response.body);

      List<Modellistaproductos> studentList =
          items.map<Modellistaproductos>((json) {
        return Modellistaproductos.fromJson(json);
      }).toList();
      _sugesttionproducto = items.map<Modellistaproductos>((json) {
        return Modellistaproductos.fromJson(json);
      }).toList();
      //setState(() {});
      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear cotizacion',
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
                    _idcliente = '';
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: FractionalOffset(0.0, 0.3),
              end: FractionalOffset(0.0, 0.8),
              colors: [
                blanco,
                blanco,
              ]),
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
              BlendMode.modulate,
            ),
            image: AssetImage('assets/images/asablanco.jpg'),
            fit: BoxFit.contain,
          ),
        ),
        child: Column(
          children: [
            _cabecera(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Tipo de producto a cotizar',
                    style: GoogleFonts.itim(
                      textStyle: TextStyle(color: azuls),
                    )),
                Card(
                  color: _tipomaterial == 'MAT' ? rojo : gris,
                  elevation: 10,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _tipomaterial = 'MAT';
                      });
                    },
                    child: Text(
                      'Material',
                      style: GoogleFonts.itim(
                        textStyle: TextStyle(color: blanco),
                      ),
                    ),
                  ),
                ),
                Card(
                  color: _tipomaterial == 'SER' ? rojo : gris,
                  elevation: 10,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _tipomaterial = 'SER';
                      });
                    },
                    child: Text(
                      'Servicio',
                      style: GoogleFonts.itim(
                        textStyle: TextStyle(color: blanco),
                      ),
                    ),
                  ),
                )
              ],
            ),
            _tipomaterial == 'MAT' ? _crearlineas() : _lineasmanuales(),
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
                      color: lineas.length == 0 ||
                              _nombrecliente.text == '' ||
                              _notas.text == '' ||
                              _fechasol.text == '' ||
                              _referencia.text == ''
                          ? gris
                          : azuls,
                      child: IconButton(
                          onPressed: () {
                            lineas.length == 0 ||
                                    _nombrecliente.text == '' ||
                                    _notas.text == '' ||
                                    _fechasol.text == '' ||
                                    _referencia.text == ''
                                ? print('nada')
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            pdfcotizacion_clientes(
                                                lineas,
                                                _nombrecliente.text,
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
                      color: lineas.length == 0 ||
                              _nombrecliente.text == '' ||
                              _notas.text == '' ||
                              _fechasol.text == '' ||
                              _referencia.text == ''
                          ? gris
                          : rojo,
                      elevation: 10,
                      child: IconButton(
                          onPressed: () {
                            lineas.length == 0 ||
                                    _nombrecliente.text == '' ||
                                    _notas.text == '' ||
                                    _fechasol.text == '' ||
                                    _referencia.text == ''
                                ? print('nada')
                                : guardar();
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
      ),
    );
  }

  Container _lineasmanuales() => Container(
          child: Card(
              child: Row(
        children: [
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
              controller: _descripcionmanual,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                labelText: 'Descripción',
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
          Flexible(
            flex: 1,
            child: DropdownButton<String>(
              value: _unidad,
              isExpanded: true,
              style: GoogleFonts.itim(
                textStyle: TextStyle(color: azulp),
              ),
              onChanged: (newValue) {
                setState(() {
                  _unidad = newValue.toString();
                });
              },
              items: _unidades.map((currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
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
                          lineas.add(Lineascoti(
                            _idproducto,
                            _descripcionmanual.text,
                            _unidad,
                            _pulinea.text,
                            _cantidadlinea.text,
                            _descripcion,
                          ));
                          _idproducto = '';
                          _descripcionmanual.clear();
                          _unidad = 'Selecciona unidad...';
                          _pulinea.clear();
                          _cantidadlinea.clear();
                          _descripcion = '';
                          _setTotal();
                        });
                },
                icon: Icon(
                  Icons.add,
                  color: blanco,
                )),
          )
        ],
      )));

  Container _lineas() => Container(
          child: Flexible(
              child: Container(
                  child: ListView.builder(
        itemCount: lineas.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        lineas.remove(lineas[index]);
                      });
                    },
                    icon: Icon(
                      Icons.delete,
                      color: rojo,
                    )),
                Flexible(
                  child: ListTile(
                    title: Text(lineas[index].producto.toString(),
                        style: GoogleFonts.sulphurPoint(
                          textStyle: TextStyle(color: gris),
                        )),
                    leading: Text(
                        NumberFormat.decimalPattern().format(double.tryParse(
                                lineas[index].cantidad.toString())) +
                            ' ' +
                            lineas[index].unidad.toString().toLowerCase(),
                        style: GoogleFonts.sulphurPoint(
                          textStyle: TextStyle(color: gris),
                        )),
                    subtitle: Text(
                        'Precio Unitario ' +
                            NumberFormat.simpleCurrency().format(
                                double.tryParse(
                                    lineas[index].valorunitario.toString())),
                        style: GoogleFonts.sulphurPoint(
                          textStyle: TextStyle(color: gris),
                        )),
                    trailing: Text(
                        NumberFormat.simpleCurrency().format((double.tryParse(
                                lineas[index].cantidad.toString())! *
                            (double.tryParse(
                                lineas[index].valorunitario.toString()))!)),
                        style: GoogleFonts.sulphurPoint(
                          textStyle: TextStyle(color: gris),
                        )),
                  ),
                ),
              ],
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
          child: ListTile(
            title: Autocomplete<Modellistaproductos>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                return _sugesttionproducto
                    .where((Modellistaproductos county) => county.nombre
                        .toLowerCase()
                        .startsWith(textEditingValue.text.toLowerCase()))
                    .toList();
              },
              displayStringForOption: (Modellistaproductos option) =>
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
                        labelText: 'Selecciona un producto',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        hintStyle: TextStyle(color: azuls)));
              },
              onSelected: (Modellistaproductos selection) {
                setState(() {
                  print(selection.descripcion);
                  _idproducto = selection.id;
                  _productolinea.text = selection.nombre;
                  _descripcion = selection.descripcion.toString();
                });
              },
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
        Flexible(
          flex: 1,
          child: DropdownButton<String>(
            value: _unidad,
            isExpanded: true,
            style: GoogleFonts.itim(
              textStyle: TextStyle(color: azulp),
            ),
            onChanged: (newValue) {
              setState(() {
                _unidad = newValue.toString();
              });
            },
            items: _unidades.map((currency) {
              return DropdownMenuItem<String>(
                value: currency,
                child: Text(currency),
              );
            }).toList(),
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
                        lineas.add(Lineascoti(
                          _idproducto,
                          _productolinea.text,
                          _unidad,
                          _pulinea.text,
                          _cantidadlinea.text,
                          _descripcion,
                        ));
                        _idproducto = '';
                        _productolinea.clear();
                        _unidad = 'Selecciona unidad...';
                        _pulinea.clear();
                        _cantidadlinea.clear();
                        _descripcion = '';
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
              subtitle: Text('Selecciona un cliente',
                  style: GoogleFonts.sulphurPoint(
                    textStyle: TextStyle(color: azulp),
                  )),
              title: Autocomplete<Modellistaclientes>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  return _sugesttioncliente
                      .where((Modellistaclientes county) => county.razonSocial
                          .toLowerCase()
                          .startsWith(textEditingValue.text.toLowerCase()))
                      .toList();
                },
                displayStringForOption: (Modellistaclientes option) =>
                    option.razonSocial,
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
                          labelText: 'Selecciona un cliente',
                          border: OutlineInputBorder(),
                          hintStyle: TextStyle(color: azuls)));
                },
                onSelected: (Modellistaclientes selection) {
                  setState(() {
                    print(selection.razonSocial);
                    _idcliente = selection.id;
                    _nombrecliente.text = selection.razonSocial;
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
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                labelText: 'Proyecto /Comentarios / observaciones',
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
              onChanged: (value) {
                setState(() {});
              },
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
                  onChanged: (value) {
                    setState(() {});
                  },
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
      'tipo': 'alta_cab_ventas',
      'id_cliente': _idcliente,
      'nombre_cliente': _nombrecliente.text,
      'comentarios': _notas.text,
      'referencia': _referencia.text,
      'condiciones': _condicionesdepago.text,
      'usuario': usuario,
    };
    print(data);

    var res = await http.post(urlventas,
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
        'tipo': 'alta_lin_ventas',
        'id_venta': _idordencompra,
        'id_producto': elemento.producto,
        'cantidad': elemento.cantidad,
        'descripcion': elemento.descripcion,
        'pu': elemento.valorunitario
      };
      print(data);

      var response = await http.post(urlventas, body: json.encode(data));
      if (response.statusCode == 200) {
        //print('====aqui =');
        //print(response.body);

        setState(() {
          // lineobservaciones.clear();
          // cantidad.clear();
          // preciounitario.clear();
          _idcliente = '';
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
