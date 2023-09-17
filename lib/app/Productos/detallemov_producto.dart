import 'package:asamexico/app/variables/colors.dart';
import 'package:asamexico/app/variables/servicesurl.dart';
import 'package:asamexico/models/productos_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class detallemov_productos extends StatelessWidget {
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
          Text('Movimientos',
              style: GoogleFonts.itim(textStyle: TextStyle(color: gris))),
          _listamovprod(_id)
        ],
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(_nombre,
                  style: GoogleFonts.itim(textStyle: TextStyle(color: blanco))),
              Text('Descripcion: ' + _descripcion,
                  style: GoogleFonts.itim(textStyle: TextStyle(color: azuls))),
              Text('Inventario actual: ' + _inventario + ' ' + _unidad,
                  style: GoogleFonts.itim(textStyle: TextStyle(color: blanco))),
              Text('Tipo de producto: ' + _tipo,
                  style: GoogleFonts.itim(textStyle: TextStyle(color: azuls))),
              Text('Presentacion: ' + _presentacion,
                  style: GoogleFonts.itim(textStyle: TextStyle(color: azuls))),
            ],
          ),
        ),
      ),
    );
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
      //setState(() {});
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
                                            textStyle: TextStyle(),
                                          )),
                                    ),
                                  ))
                              .toList());
                    }))));
  }
}
