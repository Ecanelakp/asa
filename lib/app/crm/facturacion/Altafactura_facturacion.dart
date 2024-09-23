import 'package:Asamexico/app/compras/previewordenpdf_compras.dart';
import 'package:Asamexico/app/crm/cotizaciones/altacotizacion_clientes.dart';
import 'package:Asamexico/app/crm/cotizaciones/pdfcotizacion_clientes.dart';
import 'package:Asamexico/app/crm/facturacion/datos_facturacion.dart';
import 'package:Asamexico/app/variables/colors.dart';
import 'package:Asamexico/app/variables/servicesurl.dart';
import 'package:Asamexico/app/variables/variables.dart';
import 'package:Asamexico/models/clientes_model.dart';
import 'package:Asamexico/models/facturacion_model.dart';
import 'package:Asamexico/models/productos_model.dart';

import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

List<Modellistaclientes> _sugesttioncliente = [];
List<Modellistaproductos> _sugesttionproducto = [];
List<Modelunidadssat> _sugesttionsunidades = [];
List<Modelproductosat> _sugesttionsproductosat = [];
String _idcliente = '';
String _idproducto = '';
String _idordencompra = '';
String _descripcion = '';
String _tipomaterial = '';
String formapago = '01: Efectivo';
String metodopago = 'PUE PAGO EN UNA SOLA EXHIBICIÓN';

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
String _selunidadessat = '';
String _selproductosat = '';
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


var _formaspago = [
  '01: Efectivo',
  '02: Cheque nominativo',
  '03: Transferencia electrónica de fondos',
  '04: Tarjeta de crédito',
  '05: Monedero electrónico',
  '06: Dinero electrónico',
  '08: Vales de despensa',
  '12: Dación en pago',
  '13: Pago por subrogación',
  '14: Pago por consignación',
  '15: Condonación',
  '17: Compensación',
  '23: Novación',
  '24: Confusión',
  '25: Remisión de deuda',
  '26: Prescripción o caducidad',
  '27: A satisfacción del acreedor',
  '28: Tarjeta de débito',
  '29: Tarjeta de servicios',
  '30: Aplicación de anticipos',
];


final _metodospago = [
  'PUE PAGO EN UNA SOLA EXHIBICIÓN',
  'PPD PAGO EN PARCIALIDADES O DIFERIDO',
];

List<Lineas> lineas = [];

class Lineas {
  String? numProdSat;
  String? unidadSat;
  String? descripcion;
  // String? unidad;
  // String? satDescripcion;
  String? valorunitario;
  String? cantidad;
  String? ivatrasladado;
  String? unidad;
  String? numeroidentificacion;
  Lineas(
      this.numProdSat,
      this.unidadSat,
      this.descripcion,
      this.valorunitario,
      this.cantidad,
      this.ivatrasladado,
      this.unidad,
      this.numeroidentificacion);
}

class Altafactura_facturacion extends StatefulWidget {
  const Altafactura_facturacion({super.key});

  @override
  State<Altafactura_facturacion> createState() => _Altafactura_facturacionState();
}

class _Altafactura_facturacionState extends State<Altafactura_facturacion> {
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
    getunidades();
    listaprod();
     getproductos();
     getseries();
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
  
  Future<List<Modellistaseries>> getseries() async {
    //print('======$notmes======');
    var data = {
      'tipo': 'lista_series',
      'rfc': 'ASA911031GJ0',
    };
    // print(data);
    final response = await http.post(urlaltaclientes,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      print(response.body);

      List<Modellistaseries> studentList = items.map<Modellistaseries>((json) {
        return Modellistaseries.fromJson(json);
      }).toList();

      // _sugesttionsseries = items.map<Modellistaseries>((json) {
      //   return Modellistaseries.fromJson(json);
      // }).toList();
      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Facturación',
            style: GoogleFonts.itim(
              textStyle: TextStyle(),
            )),
        backgroundColor: azulp,
        actions: [
         
         
 
        
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
            ExpansionTile(
              backgroundColor: blanco,
              collapsedBackgroundColor: azulp,
              collapsedTextColor: blanco,
              collapsedIconColor: blanco,
              textColor: azulp,
                            title: Text('Cabecera',style: GoogleFonts.itim(
                          textStyle: TextStyle(),
                        )),
              children:[ _cabecera()]),
             ExpansionTile(
              backgroundColor: blanco,
              collapsedBackgroundColor: azulp,
              collapsedTextColor: blanco,
              collapsedIconColor: blanco,
              textColor: azulp,
                            title: Text('Crear Lineas', style: GoogleFonts.itim(
                          textStyle: TextStyle(),
                        )),
              children:[Column(
                children: [
                   ResponsiveGridRow(
          children: [
            ResponsiveGridCol(
               xs: 6,
              md: 3,
              child:  Card(
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
            ),
            ResponsiveGridCol(
              xs: 6,
              md: 3,
              child:   Card(
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
            ),]),
                  
                   _tipomaterial == 'MAT' ? _crearlineas() : _lineasmanuales(),
          
          
                ],
              )]),
           _lineas() ,
           Spacer(),
           ExpansionTile(
              backgroundColor: blanco,
              collapsedBackgroundColor: azulp,
              collapsedTextColor: blanco,
              collapsedIconColor: blanco,
              textColor: azulp,
                            title: Text('Metodo y forma de pago', style: GoogleFonts.itim(
                          textStyle: TextStyle(),
                        )),
              children:[ Column(
          children: [
            Card(
                child: ListTile(
              title: Text('Metodo de pago',
                  style: GoogleFonts.itim(
                    textStyle: TextStyle(color: gris),
                  )),
              subtitle: DropdownButton(
                style: GoogleFonts.itim(
                  textStyle: TextStyle(color: azulp),
                ),
                value: metodopago,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: _metodospago.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    metodopago = newValue!;
                    metodopago != 'PUE PAGO EN UNA SOLA EXHIBICIÓN'
                        ? formapago = '99'
                        : formapago = '01: Efectivo';
                  });
                },
              ),
            )),
            Card(
                child: ListTile(
              title: Text('Forma de pago',
                  style: GoogleFonts.itim(
                    textStyle: TextStyle(color: gris),
                  )),
              subtitle: metodopago == 'PUE PAGO EN UNA SOLA EXHIBICIÓN'
                  ? DropdownButton(
                      style: GoogleFonts.itim(
                        textStyle: TextStyle(color: azulp),
                      ),
                      value: formapago,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: _formaspago.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          formapago = newValue!;
                        });
                      },
                    )
                  : Container(
                      child: Text(
                        '99: Por definir',
                        style: GoogleFonts.itim(
                          textStyle: TextStyle(color: azulp),
                        ),
                      ),
                    ),
            )),])]),
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
                           timbrartxt();
                          },
                          icon: Icon(
                            Icons.code,
                            color: blanco,
                          )),
                    )
                  ],
                ),
              ),
          )
          ],
        ),
      )
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
            flex: 1,
            child:  Autocomplete<Modelunidadssat>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        return _sugesttionsunidades
                            .where((Modelunidadssat county) =>
                                county.descripcion.toLowerCase().startsWith(
                                    textEditingValue.text.toLowerCase()) ||
                                county.numUnidad.toLowerCase().startsWith(
                                    textEditingValue.text.toLowerCase()))
                            .toList();
                      },
                      displayStringForOption: (Modelunidadssat option) =>
                          option.descripcion,
                          
                      fieldViewBuilder: (BuildContext context,
                          TextEditingController fieldTextEditingController,
                          FocusNode fieldFocusNode,
                          VoidCallback onFieldSubmitted) {
                        return TextField(
                          onChanged: (value) {
                            setState(() {});
                          },
                          controller: fieldTextEditingController,
                          focusNode: fieldFocusNode,
                          decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                labelText: 'Selecciona unidad SAT',
                labelStyle: GoogleFonts.itim(textStyle: TextStyle(color: gris)),
              ),
                        );
                      },
                      onSelected: (Modelunidadssat selection) {
                        setState(() {
                          _selunidadessat = selection.numUnidad;
                        });
                        print(_selunidadessat);
                      },
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
            child:  Autocomplete<Modelproductosat>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      return _sugesttionsproductosat
                          .where((Modelproductosat county) =>
                              county.descripcion.toLowerCase().startsWith(
                                  textEditingValue.text.toLowerCase()) ||
                              county.numProd.toLowerCase().startsWith(
                                  textEditingValue.text.toLowerCase()))
                          .toList();
                    },
                    displayStringForOption: (Modelproductosat option) =>
                        option.descripcion,
                    fieldViewBuilder: (BuildContext context,
                        TextEditingController fieldTextEditingController,
                        FocusNode fieldFocusNode,
                        VoidCallback onFieldSubmitted) {
                      return TextField(
                        controller: fieldTextEditingController,
                        focusNode: fieldFocusNode,
                        onChanged: (value) {
                          setState(() {});
                        },
                      decoration: InputDecoration(
                border:    OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                labelText: 'Selecciona unidad SAT',
                labelStyle: GoogleFonts.itim(textStyle: TextStyle(color: gris))),
                      );
                    },
                    onSelected: (Modelproductosat selection) {
                      setState(() {
                        _selproductosat = selection.numProd;
                      });
                    },
                  )),
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
                           _selproductosat,
                           _selunidadessat,
                           _descripcionmanual.text,
                           _pulinea.text,
                           _cantidadlinea.text,
                           _pulinea.text,                          
                           _unidad, 
                           _idproducto,
                           
                           
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
          child: Expanded(
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
                  title: Text(lineas[index].numProdSat.toString().toLowerCase()+ ' - '+lineas[index].descripcion.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.itim(
                        
                        textStyle: TextStyle(color: gris),
                      )),
                  leading: Text(
                      NumberFormat.decimalPattern().format(double.tryParse(
                              lineas[index].cantidad.toString())) +
                          ' ' +
                          lineas[index].numProdSat.toString().toLowerCase(),
                      style: GoogleFonts.itim(
                        textStyle: TextStyle(color: gris),
                      )),
                  subtitle: Text(
                      'Precio Unitario ' +
                          NumberFormat.simpleCurrency().format(
                              double.tryParse(
                                  lineas[index].valorunitario.toString())),
                      style: GoogleFonts.itim(
                        textStyle: TextStyle(color: gris),
                      )),
                  trailing: Text(
                      NumberFormat.simpleCurrency().format((double.tryParse(
                              lineas[index].cantidad.toString())! *
                          (double.tryParse(
                              lineas[index].valorunitario.toString()))!)),
                      style: GoogleFonts.itim(
                        textStyle: TextStyle(color: gris),
                      )),
                ),
              ),
            ],
                        ),
                      );
                    },
                  )),
          ));

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
                        lineas.add(Lineas(
                          _idproducto,
                          _productolinea.text,
                          _unidad,
                          _pulinea.text,
                          _cantidadlinea.text,
                          _descripcion,
                          _selproductosat,
                          _selunidadessat
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
            child:  Padding(
              padding: const EdgeInsets.all(8.0),
              child: Autocomplete<Modellistaclientes>(
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
                            border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
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
          child:  Container(
            
              width: double.infinity,
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: 
                 
                    FutureBuilder<List<Modellistaseries>>(
                        future: getseries(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Container(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                ),
                              ),
                            );

                          return ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data!
                                  .map((data) => GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selfolio = data.folioInicial;
                                            selserie = data.serie;
                                            seltipo = data.tipoDocumento;
                                            idserie = data.id;
                                            tipocfdi =
                                                data.tipoDocumento == 'Factura'
                                                    ? 'I'
                                                    : data.tipoDocumento ==
                                                            'Recibo de Pagos'
                                                        ? 'P'
                                                        : 'E';
                                          });
                                         
                                        },
                                        child: Container(
                                          width: 100,
                                          height: 80,
                                          color:  selserie==''?gris: azulp,
                                          child: Center(
                                            child: Text(
                                                data.serie + data.folioInicial,
                                                style: GoogleFonts.sulphurPoint(
                                                  textStyle:
                                                      TextStyle(color: blanco),
                                                )),
                                          ),
                                        ),
                                      ))
                                  .toList());
                        }),
               
              ))),
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
                  hintText: 'Fecha vencimiento',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
            )),
        ResponsiveGridCol(
          xs: 6,
          md: 6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _notas,
              maxLines: 1,
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
          md: 6,
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
        'id_producto': elemento.numProdSat,
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


  Future<List<Modelunidadssat>> getunidades() async {
    //print('======$notmes======');
    var data = {'tipo': 'lista_unidades_sat'};
    //print(data);
    final response = await http.post(urlaltaprodcutos,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      //print(response.body);

      List<Modelunidadssat> studentList = items.map<Modelunidadssat>((json) {
        return Modelunidadssat.fromJson(json);
      }).toList();
      _sugesttionsunidades = items.map<Modelunidadssat>((json) {
        return Modelunidadssat.fromJson(json);
      }).toList();

      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  
  Future<List<Modelproductosat>> getproductos() async {
    //print('======$notmes======');
    var data = {'tipo': 'lista_productos_sat'};
    //print(data);
    final response = await http.post(urlaltaprodcutos,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      // print(response.body);

      List<Modelproductosat> studentList = items.map<Modelproductosat>((json) {
        return Modelproductosat.fromJson(json);
      }).toList();
      _sugesttionsproductosat = items.map<Modelproductosat>((json) {
        return Modelproductosat.fromJson(json);
      }).toList();

      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

}
