import 'package:asamexico/app/variables/colors.dart';
import 'package:asamexico/app/variables/servicesurl.dart';
import 'package:asamexico/app/variables/variables.dart';
import 'package:asamexico/models/productos_model.dart';
import 'package:asamexico/models/proyectos_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

List<Modellistaproductos> _sugesttionsproductos = [];
TextEditingController _cantidad = TextEditingController();
String _nombre = '';
String _idprod = '';
double _cantsuf = 0;
double _cantenviada = 0;

class envioprods_proyectos extends StatefulWidget {
  final String _id;
  const envioprods_proyectos(
    this._id,
  );

  @override
  State<envioprods_proyectos> createState() => _envioprods_proyectosState();
}

class _envioprods_proyectosState extends State<envioprods_proyectos> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listaproductos();
    listaprod();
  }

  Future<List<Modellistaproyprods>> listaprod() async {
    //print('======$notmes======');
    var data = {
      'tipo': 'prod_x_proyectos',
      'id_proyecto': widget._id,
      'status': '0'
    };
    //print(data);
    final response = await http.post(urlproyectos,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      //print(response.body);

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
        Text('Busca y agrega materiales por entregar al proyecto',
            style: GoogleFonts.sulphurPoint(
              textStyle: TextStyle(color: gris),
            )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _Agregarproductos(),
        ),
        Text('Lista por entregar',
            style: GoogleFonts.sulphurPoint(
              textStyle: TextStyle(color: gris),
            )),
        Flexible(
            flex: 5,
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
                                          subtitle: Text(data.usuarioAlta,
                                              style: GoogleFonts.sulphurPoint(
                                                textStyle:
                                                    TextStyle(color: azuls),
                                              )),
                                        ),
                                      ),
                                      Flexible(
                                        child: CircleAvatar(
                                          backgroundColor: rojo,
                                          child: IconButton(
                                              onPressed: () {
                                                borrarmov(data.id);
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: blanco,
                                              )),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: CircleAvatar(
                                          backgroundColor: Colors.green,
                                          child: IconButton(
                                              onPressed: () {
                                                actprodproyect(
                                                    data.id,
                                                    data.idProducto,
                                                    data.cantidad);
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
            )),
      ],
    );
  }

  Row _Agregarproductos() {
    return Row(
      children: [
        Flexible(
          flex: 3,
          child: Card(
            elevation: 10,
            child: Container(
              child: Autocomplete<Modellistaproductos>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  return _sugesttionsproductos
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
                  );
                },
                onSelected: (Modellistaproductos selection) {
                  setState(() {
                    _nombre = selection.nombre;
                    _idprod = selection.id;
                    _cantsuf = double.tryParse(selection.inventario)!;
                  });
                },
              ),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Card(
            elevation: 10,
            child: TextField(
              controller: _cantidad,
              maxLines: 1,
              onChanged: (value) {
                _cantenviada = double.tryParse(_cantidad.text)!;
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
              ], // Acepta solo dígitos
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: GoogleFonts.itim(textStyle: TextStyle(color: azulp)),
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: _cantsuf.toString() + ' max.',
                  //hintText: _cantsuf.toString() + ' max.',
                  hintStyle: TextStyle(
                    color: Colors.black26,
                  )),
            ),
          ),
        ),
        Container(
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: _cantenviada > _cantsuf ? gris : rojo),
                  onPressed: () {
                    _cantenviada > _cantsuf
                        ? print('Nada')
                        : agregarproductos();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Agregar',
                      style:
                          GoogleFonts.itim(textStyle: TextStyle(color: blanco)),
                    ),
                  ))),
        ),
      ],
    );
  }

  Future agregarproductos() async {
    var data = {
      'tipo': 'alta_mov_prod',
      'nombre': _nombre,
      'id_producto': _idprod,
      'tipo_mov': 'Enviado',
      'id_proyecto': widget._id,
      'cantidad': _cantenviada * -1,
      'usuario_asig': 'test@asamexico.mx',
      'usuario': usuario,
      'status': 0,
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
      _cantidad.clear();
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

  Future actprodproyect(
      String _id, String _idProducto, String _cantidad) async {
    var data = {
      'tipo': 'act_mov_prod',
      'id_producto': _idProducto,
      'id_mov': _id,
      'usuario_asig': usuario,
      'status': 1,
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
        'Se ha creado correctamente.........',
        style: GoogleFonts.sulphurPoint(textStyle: TextStyle(color: blanco)),
      ),
      backgroundColor: (azulp),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // Navigator.pop(context);
  }

  Future borrarmov(String _id) async {
    var data = {
      'tipo': 'borra_mov',
      'id_mov': _id,
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
        'Se ha creado correctamente.........',
        style: GoogleFonts.sulphurPoint(textStyle: TextStyle(color: blanco)),
      ),
      backgroundColor: (azulp),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // Navigator.pop(context);
  }

  Future<List<Modellistaproductos>> listaproductos() async {
    //print('======$notmes======');
    var data = {
      'tipo': 'lista_productos',
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
      _sugesttionsproductos = items.map<Modellistaproductos>((json) {
        return Modellistaproductos.fromJson(json);
      }).toList();
      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }
}
