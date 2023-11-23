import 'package:Asamexico/app/variables/colors.dart';
import 'package:Asamexico/app/variables/servicesurl.dart';
import 'package:Asamexico/app/variables/variables.dart';
import 'package:Asamexico/models/productos_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

TextEditingController _cantidad = TextEditingController();
TextEditingController _claveaut = TextEditingController();
String _autocode = '1452';
bool _correcto = false;
double? _inventarioact = 0;

class detallemov_productos extends StatefulWidget {
  final String _descripcion;
  final String _id;
  final String _nombre;
  final String _presentacion;
  final String _tipo;
  final String _unidad;
  final String _inventario;
  detallemov_productos(this._descripcion, this._id, this._nombre,
      this._presentacion, this._tipo, this._unidad, this._inventario);

  @override
  State<detallemov_productos> createState() => _detallemov_productosState();
}

class _detallemov_productosState extends State<detallemov_productos> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cantidad.clear();
    _claveaut.clear();
    existencias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle movimiento',
            style: GoogleFonts.itim(textStyle: TextStyle(color: blanco))),
        backgroundColor: azulp,
      ),
      backgroundColor: blanco,
      body: Column(
        children: [
          _cabecera(),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: ExpansionTile(
                title: Text('Descripción',
                    style: GoogleFonts.itim(textStyle: TextStyle(color: gris))),
                children: [
                  Text(widget._descripcion,
                      style:
                          GoogleFonts.itim(textStyle: TextStyle(color: gris))),
                ],
              )),
          Text('Movimientos',
              style: GoogleFonts.itim(textStyle: TextStyle(color: gris))),
          _listamovprod(widget._id),
          _ajustes()
        ],
      ),
    );
  }

  Container _ajustes() {
    return Container(
      color: azulp,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('Ajustes',
                style: GoogleFonts.itim(textStyle: TextStyle(color: blanco))),
            Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _cantidad,
                      onChanged: (value) {
                        setState(() {
                          _claveaut.text == _autocode && _cantidad.text != ''
                              ? _correcto = true
                              : _correcto = false;
                        });
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                      ], // Acepta solo dígitos
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: blanco,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        labelText: 'Cant.',
                        labelStyle:
                            GoogleFonts.itim(textStyle: TextStyle(color: gris)),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: TextField(
                    controller: _claveaut,
                    onChanged: (value) {
                      setState(() {
                        _claveaut.text == _autocode && _cantidad.text != ''
                            ? _correcto = true
                            : _correcto = false;
                      });
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                    ], // Acepta solo dígitos
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: blanco,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      labelText: 'Clave autorización',
                      labelStyle:
                          GoogleFonts.itim(textStyle: TextStyle(color: gris)),
                    ),
                  ),
                ),
                _correcto == true
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: azuls,
                          child: IconButton(
                              onPressed: () {
                                agregarproductos(1);
                              },
                              icon: Icon(
                                Icons.add,
                                color: blanco,
                              )),
                        ),
                      )
                    : Container(),
                _correcto == true &&
                        double.tryParse(_cantidad.text)! <= _inventarioact!
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: rojo,
                          child: IconButton(
                              onPressed: () {
                                agregarproductos(-1);
                              },
                              icon: Icon(
                                Icons.remove,
                                color: blanco,
                              )),
                        ),
                      )
                    : Container(),
              ],
            ),
            Text('Indica el ajuste a realizar',
                style: GoogleFonts.itim(textStyle: TextStyle(color: blanco))),
          ],
        ),
      ),
    );
  }

  Container _cabecera() {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 10,
        color: azulp,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                flex: 1,
                child: Text(widget._tipo,
                    style:
                        GoogleFonts.itim(textStyle: TextStyle(color: blanco))),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(widget._nombre,
                          style: GoogleFonts.itim(
                              textStyle: TextStyle(color: blanco))),
                      Text('Presentacion: ' + widget._presentacion,
                          style: GoogleFonts.itim(
                              textStyle: TextStyle(color: azuls))),
                    ],
                  ),
                ),
              ),
              Flexible(
                  flex: 2,
                  child: Text(
                      NumberFormat.decimalPattern().format((_inventarioact)),
                      style: GoogleFonts.itim(
                          textStyle: TextStyle(color: blanco, fontSize: 20)))),
              Text(widget._unidad,
                  style: GoogleFonts.itim(
                      textStyle: TextStyle(
                    color: blanco,
                  ))),
            ],
          ),
        ),
      ),
    );
  }

  Future existencias() async {
    var data = {
      'tipo': 'inve_x_prod',
      'id_producto': widget._id,
    };
    print(data);
    final reponse = await http.post(urlproductos,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    print(reponse.body);

    setState(() {
      _inventarioact = double.tryParse(reponse.body.toString())!;
    });

    // Navigator.pop(context);
  }

  Future agregarproductos(int _positivo) async {
    var data = {
      'tipo': 'alta_mov_prod_ajuste',
      'nombre': widget._descripcion,
      'id_producto': widget._id,
      'tipo_mov': _positivo == 1 ? 'Ajuste positivo' : 'Ajuste negativo',
      'id_proyecto': '',
      'cantidad': _positivo == 1
          ? _cantidad.text
          : double.tryParse(_cantidad.text)! * (-1),
      'usuario_asig': usuario,
      'usuario': usuario,
      'status': 1,
    };
    print(data);
    final reponse = await http.post(urlproductos,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    print(reponse.body);

    setState(() {
      _cantidad.clear();
      _claveaut.clear();
      _correcto = false;
      existencias();
    });
    final snackBar = SnackBar(
      content: Text(
        'Se ha creado correctamente.........',
        style: GoogleFonts.sulphurPoint(textStyle: TextStyle(color: blanco)),
      ),
      backgroundColor: (azulp),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // Navigator.pop(context);
  }
}

class _listamovprod extends StatefulWidget {
  final String _id;
  _listamovprod(this._id);

  @override
  State<_listamovprod> createState() => _listamovprodState();
}

class _listamovprodState extends State<_listamovprod> {
  @override
  void initState() {
    super.initState();
    listaprod();
  }

  Future<List<Modellistaprodmov>> listaprod() async {
    //print('======$notmes======');
    var data = {'tipo': 'mov_productos', 'id_producto': widget._id};
    //print(data);
    final response = await http.post(urlproductos,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      //print(response.body);

      List<Modellistaprodmov> studentList =
          items.map<Modellistaprodmov>((json) {
        return Modellistaprodmov.fromJson(json);
      }).toList();
      setState(() {});
      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: RefreshIndicator(
            onRefresh: () => listaprod(),
            child: Container(
                child: FutureBuilder<List<Modellistaprodmov>>(
                    future: listaprod(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Container(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                          ),
                        );

                      return ListView(
                          children: snapshot.data!
                              .map((data) => Card(
                                    elevation: 10,
                                    child: ListTile(
                                      leading: Text(
                                          DateFormat('dd/MM')
                                              .format(data.fecha)
                                              .toString(),
                                          style: GoogleFonts.sulphurPoint(
                                            textStyle: TextStyle(color: gris),
                                          )),
                                      title: Text(data.tipoMovimiento,
                                          style: GoogleFonts.sulphurPoint(
                                            textStyle: TextStyle(),
                                          )),
                                      subtitle: Text(data.usuarioAsignado,
                                          style: GoogleFonts.sulphurPoint(
                                            textStyle: TextStyle(),
                                          )),
                                      trailing: Text(data.cantidad,
                                          style: GoogleFonts.sulphurPoint(
                                            textStyle: TextStyle(color: azulp),
                                          )),
                                    ),
                                  ))
                              .toList());
                    }))));
  }
}
