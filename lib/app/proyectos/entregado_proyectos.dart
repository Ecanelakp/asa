import 'package:asamexico/app/variables/colors.dart';
import 'package:asamexico/app/variables/servicesurl.dart';

import 'package:asamexico/models/proyectos_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

List<TextEditingController> _cantretorno = [];
List<Modellistaproyprods> _materiales = [];

class entregado_proyectos extends StatefulWidget {
  final String _id;
  entregado_proyectos(this._id);

  @override
  State<entregado_proyectos> createState() => _entregado_proyectosState();
}

class _entregado_proyectosState extends State<entregado_proyectos> {
  @override
  void initState() {
    super.initState();
    listaprod();
    _cantretorno.clear();
  }

  Future<List<Modellistaproyprods>> listaprod() async {
    //print('======$notmes======');
    var data = {
      'tipo': 'prod_x_proyectos',
      'id_proyecto': widget._id,
      'status': '1'
    };
    //print(data);
    final response = await http.post(urlproyectos,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      print(response.body);

      List<Modellistaproyprods> studentList =
          items.map<Modellistaproyprods>((json) {
        return Modellistaproyprods.fromJson(json);
      }).toList();
      _materiales = items.map<Modellistaproyprods>((json) {
        return Modellistaproyprods.fromJson(json);
      }).toList();
      setState(() {});
      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Materiales en proyecto'),
        Flexible(
          child: Container(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: _materiales.length,
                    itemBuilder: (BuildContext context, int index) {
                      _cantretorno.add(new TextEditingController());

                      return Card(
                        elevation: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(
                              flex: 5,
                              child: ListTile(
                                title: Text(_materiales[index].producto,
                                    style: GoogleFonts.sulphurPoint(
                                      textStyle: TextStyle(),
                                    )),
                                leading: Text(
                                    (double.tryParse(_materiales[index]
                                                    .cantidad)! *
                                                (-1))
                                            .toString() +
                                        '/' +
                                        ((double.tryParse(_materiales[index]
                                                        .cantidad)! *
                                                    (-1)) -
                                                (double.tryParse(
                                                    _materiales[index]
                                                        .cantidad_disponible)!))
                                            .toString(),
                                    style: GoogleFonts.sulphurPoint(
                                      textStyle: TextStyle(color: azulp),
                                    )),
                                subtitle:
                                    Text(_materiales[index].usuarioAsignado,
                                        style: GoogleFonts.sulphurPoint(
                                          textStyle: TextStyle(color: azuls),
                                        )),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: TextField(
                                  controller: _cantretorno[index],
                                  onChanged: (value) {
                                    setState(() {
                                      // print(double.parse(_materiales[index]
                                      //             .cantidad_disponible) <
                                      //         double.parse(
                                      //             _cantretorno[index].text)
                                      //     ? 'si'
                                      //     : 'no');
                                    });
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9.,]')),
                                  ],
                                  onSubmitted: (value) {
                                    setState(() {});
                                  }, // Acepta solo dígitos
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true), // Acepta solo dígitos

                                  decoration: InputDecoration(
                                      hintText: 'Cant a retornar',
                                      labelText: 'Cant a retornar',
                                      border: OutlineInputBorder(),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintStyle:
                                          TextStyle(color: Colors.grey))),
                            ),
                            Flexible(
                              flex: 1,
                              child: CircleAvatar(
                                backgroundColor: _cantretorno[index].text !=
                                            '' &&
                                        ((double.tryParse(_materiales[index]
                                                        .cantidad)! *
                                                    (-1)) -
                                                (double.tryParse(_materiales[
                                                        index]
                                                    .cantidad_disponible)!)) >=
                                            double.tryParse(
                                                _cantretorno[index].text)!
                                    ? azuls
                                    : gris,
                                child: IconButton(
                                    onPressed: () {
                                      _cantretorno[index].text != '' &&
                                              ((double.tryParse(
                                                              _materiales[index]
                                                                  .cantidad)! *
                                                          (-1)) -
                                                      (double.tryParse(_materiales[
                                                              index]
                                                          .cantidad_disponible)!)) >=
                                                  double.tryParse(
                                                      _cantretorno[index].text)!
                                          ? setState(() {
                                              String _canttotal;

                                              _canttotal = (double.tryParse(
                                                          _cantretorno[index]
                                                              .text)! +
                                                      double.tryParse(_materiales[
                                                              index]
                                                          .cantidad_disponible)!)
                                                  .toString();

                                              agregarproductos(
                                                  _materiales[index].idProducto,
                                                  _cantretorno[index].text,
                                                  _materiales[index].producto);
                                              cant_pend(_materiales[index].id,
                                                  _canttotal);
                                            })
                                          : print('nada');
                                    },
                                    icon: Icon(
                                      Icons.keyboard_return,
                                      color: blanco,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      );
                    })),
          ),
        ),
      ],
    );
  }

  Future agregarproductos(
      String _idProducto, String _cantidad, String _producto) async {
    var data = {
      'tipo': 'alta_mov_prod',
      'nombre': _producto,
      'id_producto': _idProducto,
      'tipo_mov': 'Retorno',
      'id_proyecto': widget._id,
      'cantidad': _cantidad,
      'usuario_asig': 'test@asamexico.mx',
      'usuario': 'ecanela@asamexico.mx',
      'status': 2,
    };
    print(data);
    final reponse = await http.post(urlproductos,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    print(reponse.body);
    setState(() {
      _cantretorno.clear();
    });

    // setState(() {
    //   listaprod();

    // });
    // final snackBar = SnackBar(
    //   content: Text(
    //     'Se ha creado correctamente.........',
    //     style: GoogleFonts.sulphurPoint(textStyle: TextStyle(color: blanco)),
    //   ),
    //   backgroundColor: (azulp),
    // );
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // Navigator.pop(context);
  }

  Future cant_pend(String _id, String _cantidad) async {
    var data = {'tipo': 'act_cantdis', 'id_mov': _id, 'cantidad': _cantidad};
    print(data);
    final reponse = await http.post(urlproductos,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    print(reponse.body);

    setState(() {
      listaprod();
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
