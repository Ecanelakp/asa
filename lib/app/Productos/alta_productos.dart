import 'package:asamexico/app/home/lateral_app.dart';
import 'package:asamexico/app/variables/colors.dart';
import 'package:asamexico/app/variables/servicesurl.dart';
import 'package:asamexico/app/variables/variables.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

TextEditingController _codigo = TextEditingController();
TextEditingController _articulo = TextEditingController();

TextEditingController _cantinicial = TextEditingController();
TextEditingController _descripcion = TextEditingController();

bool _isMaterial = false;
bool _isHerramienta = false;
bool _isInsumo = false;
String _tipoprod = '';
String _selunidad = 'Selecciona unidad...';
String _selpresentacion = 'Selecciona presentacion...';

List<String> _unidades = [
  'Selecciona unidad...',
  'KG',
  'GAL',
  'LT',
  'PZA',
  'MTS'
  // ... Agrega más códigos de monedas aquí ...
];

List<String> _presentacion = [
  'Selecciona presentacion...',

  'CUB',
  'KIT',
  'SACOS',
  'CAJA',
  'BOTE',
  'CARTUCHO',
  'UNIDAD'

  // ... Agrega más códigos de monedas aquí ...
];

class alta_productos extends StatefulWidget {
  const alta_productos({super.key});

  @override
  State<alta_productos> createState() => _alta_productosState();
}

class _alta_productosState extends State<alta_productos> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _codigo.clear();
    _articulo.clear();

    _cantinicial.text = '0';
    _descripcion.clear();

    _isMaterial = false;
    _isHerramienta = false;
    _isInsumo = false;
    _tipoprod = '';
    _selunidad = 'Selecciona unidad...';
    _selpresentacion = 'Selecciona presentacion...';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Alta productos',
          style: GoogleFonts.itim(textStyle: TextStyle(color: blanco)),
        ),
        backgroundColor: azulp,
      ),
      //drawer: menulateral(),
      backgroundColor: blanco,
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: CheckboxListTile(
                      title: Text('Materiales',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.itim(
                            textStyle: TextStyle(color: azulp),
                          )),
                      value: _isMaterial,
                      onChanged: (newValue) {
                        setState(() {
                          _isMaterial = newValue!;
                          // Desactiva la opción de Persona Moral si Persona Física está seleccionada
                          if (_isMaterial) {
                            _isHerramienta = false;
                            _isInsumo = false;
                            _tipoprod = 'Material';
                          }
                        });
                      },
                    ),
                  ),
                  Flexible(
                    child: CheckboxListTile(
                      title: Text(
                        'Herramientas',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.itim(
                          textStyle: TextStyle(color: azulp),
                        ),
                      ),
                      value: _isHerramienta,
                      onChanged: (newValue) {
                        setState(() {
                          _isHerramienta = newValue!;
                          // Desactiva la opción de Persona Física si Persona Moral está seleccionada
                          if (_isHerramienta) {
                            _isMaterial = false;
                            _isInsumo = false;
                            _tipoprod = 'Herramientas';
                          }
                        });
                      },
                    ),
                  ),
                  Flexible(
                    child: CheckboxListTile(
                      title: Text(
                        'Insumos',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.itim(
                          textStyle: TextStyle(color: azulp),
                        ),
                      ),
                      value: _isInsumo,
                      onChanged: (newValue) {
                        setState(() {
                          _isInsumo = newValue!;
                          // Desactiva la opción de Persona Física si Persona Moral está seleccionada
                          if (_isInsumo) {
                            _isMaterial = false;
                            _isHerramienta = false;
                            _tipoprod = 'Insumos';
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
              _campos(_codigo, 'Codigo', 1),
              _campos(_articulo, 'Nombre Corto', 1),
              _campos(_descripcion, 'Descripcion', 4),
              //   _campos(_cantinicial, 'Inventario Incial', 1),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  value: _selunidad,
                  isExpanded: true,
                  style: GoogleFonts.itim(
                    textStyle: TextStyle(color: azulp),
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      _selunidad = newValue.toString();
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  value: _selpresentacion,
                  isExpanded: true,
                  style: GoogleFonts.itim(
                    textStyle: TextStyle(color: azulp),
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      _selpresentacion = newValue.toString();
                    });
                  },
                  items: _presentacion.map((currency) {
                    return DropdownMenuItem<String>(
                      value: currency,
                      child: Text(currency),
                    );
                  }).toList(),
                ),
              ),
              _codigo.text != '' &&
                      _descripcion.text != '' &&
                      _selunidad != 'Selecciona unidad...' &&
                      _selpresentacion != 'Selecciona presentacion...' &&
                      _tipoprod != ''
                  ? Container(
                      child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(primary: rojo),
                              onPressed: () {
                                guardardatos();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(
                                      Icons.save,
                                      color: blanco,
                                    ),
                                    Text(
                                      'Registrar producto',
                                      style: GoogleFonts.itim(
                                          textStyle: TextStyle(color: blanco)),
                                    ),
                                  ],
                                ),
                              ))),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Padding _campos(
      TextEditingController _txtcontroller, String _label, int _lineas) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _txtcontroller,
        maxLines: _lineas,
        onChanged: (value) {
          setState(() {});
        },
        style: GoogleFonts.itim(textStyle: TextStyle(color: azulp)),
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: _label,
            hintStyle: TextStyle(
              color: Colors.black26,
            )),
      ),
    );
  }

  Future guardardatos() async {
    var data = {
      'tipo': 'alta',
      'descripcion': _descripcion.text,
      'presentacion': _selpresentacion,
      'unidad': _selunidad,
      'inventario': '0',
      'tipo_prod': _tipoprod,
      'usuario': usuario,
      'nombre': _articulo.text,
    };
    print(data);
    final reponse = await http.post(urlproductos,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    print(reponse.body);

    final snackBar = SnackBar(
      content: Text(
        'Se ha creado correctamente.........',
        style: GoogleFonts.sulphurPoint(textStyle: TextStyle(color: blanco)),
      ),
      backgroundColor: (azulp),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pop(context);
  }
}
