import 'package:asamexico/app/variables/colors.dart';
import 'package:asamexico/app/variables/servicesurl.dart';
import 'package:asamexico/models/productos_model.dart';
import 'package:asamexico/models/proyectos_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class retorno_proyectos extends StatefulWidget {
  final String _id;
  const retorno_proyectos(this._id);

  @override
  State<retorno_proyectos> createState() => _retorno_proyectosState();
}

class _retorno_proyectosState extends State<retorno_proyectos> {
  Future<List<Modellistaproyprods>> listaprod() async {
    //print('======$notmes======');
    var data = {
      'tipo': 'prod_x_proyectos',
      'id_proyecto': widget._id,
      'status': '2'
    };
    //print(data);
    final response = await http.post(urlproyectos,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      // print(response.body);

      List<Modellistaproyprods> studentList =
          items.map<Modellistaproyprods>((json) {
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
        Text('Materiales por regresar al almacen'),
        Flexible(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<Modellistaproyprods>>(
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
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Flexible(
                                        flex: 5,
                                        child: ListTile(
                                          title: Text(data.producto,
                                              style: GoogleFonts.sulphurPoint(
                                                textStyle: TextStyle(),
                                              )),
                                          leading: Text(data.cantidad,
                                              style: GoogleFonts.sulphurPoint(
                                                textStyle:
                                                    TextStyle(color: azulp),
                                              )),
                                          subtitle: Text(data.usuarioAsignado,
                                              style: GoogleFonts.sulphurPoint(
                                                textStyle:
                                                    TextStyle(color: azuls),
                                              )),
                                        ),
                                      ),
                                      Flexible(
                                        child: CircleAvatar(
                                          backgroundColor: Colors.green,
                                          child: IconButton(
                                              onPressed: () {
                                                actprodproyect(
                                                  data.id,
                                                  data.idProducto,
                                                  data.cantidad,
                                                );
                                              },
                                              icon: Icon(
                                                Icons.check,
                                                color: blanco,
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList());
                  }),
            ),
          ),
        ),
      ],
    );
  }

  Future actprodproyect(
      String _id, String _idProducto, String _cantidad) async {
    var data = {
      'tipo': 'act_mov_prod',
      'id_producto': _idProducto,
      'id_mov': _id,
      'usuario_asig': 'ecanela@asamexico.mx',
      'status': 3,
      'cantidad': _cantidad
    };
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
        'Se ha retornado correctamente.........',
        style: GoogleFonts.sulphurPoint(textStyle: TextStyle(color: blanco)),
      ),
      backgroundColor: (azulp),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // Navigator.pop(context);
  }
}
