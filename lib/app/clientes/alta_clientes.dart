import 'package:asamexico/app/variables/colors.dart';
import 'package:asamexico/app/variables/servicesurl.dart';
import 'package:asamexico/app/variables/variables.dart';
import 'package:asamexico/models/catalogossat_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

List<Modelcatregimen> _sugesttionsregimen = [];
List<Modelcatuso> _sugesttionsusodecfdi = [];
TextEditingController _razonsocial = TextEditingController();
TextEditingController _domicilio = TextEditingController();
TextEditingController _cp = TextEditingController();
TextEditingController _rfc = TextEditingController();
TextEditingController _telefono = TextEditingController();
TextEditingController _nombrecontacto = TextEditingController();
TextEditingController _razon_regimen = TextEditingController();
TextEditingController _email = TextEditingController();
TextEditingController _buscar = TextEditingController();
String _selregimen = '';
String _selusocfdi = '';

class alta_clientes extends StatefulWidget {
  @override
  State<alta_clientes> createState() => _alta_clientesState();
}

class _alta_clientesState extends State<alta_clientes> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getregimen();
    getusodecfdi();
    _razonsocial.clear();
    _rfc.clear();
    _cp.clear();
    _email.clear();
    _telefono.clear();
    _nombrecontacto.clear();
    _domicilio.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Alta de Clientes',
          style: GoogleFonts.itim(textStyle: TextStyle(color: blanco)),
        ),
        backgroundColor: azulp,
      ),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _razonsocial,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      labelText: 'Razon social o Nombre',
                      labelStyle: GoogleFonts.sulphurPoint(
                          textStyle: TextStyle(color: azulp)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _rfc,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      labelText: 'RFC',
                      labelStyle: GoogleFonts.sulphurPoint(
                          textStyle: TextStyle(color: azulp)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _domicilio,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      labelText: 'Domicilio',
                      labelStyle: GoogleFonts.sulphurPoint(
                          textStyle: TextStyle(color: azulp)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _cp,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      labelText: 'Código postal',
                      labelStyle: GoogleFonts.sulphurPoint(
                          textStyle: TextStyle(color: azulp)),
                    ),
                  ),
                ),
                ListTile(
                  subtitle: Text(
                    'Régimen',
                    style: GoogleFonts.sulphurPoint(
                        textStyle: TextStyle(color: azulp)),
                  ),
                  title: Autocomplete<Modelcatregimen>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      return _sugesttionsregimen
                          .where((Modelcatregimen county) => county.descripcion
                              .toLowerCase()
                              .startsWith(textEditingValue.text.toLowerCase()))
                          .toList();
                    },
                    displayStringForOption: (Modelcatregimen option) =>
                        option.descripcion,
                    fieldViewBuilder: (BuildContext context,
                        TextEditingController fieldTextEditingController,
                        FocusNode fieldFocusNode,
                        VoidCallback onFieldSubmitted) {
                      return TextField(
                        controller: fieldTextEditingController,
                        focusNode: fieldFocusNode,
                      );
                    },
                    onSelected: (Modelcatregimen selection) {
                      setState(() {
                        _selregimen = selection.cve;
                      });
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                ListTile(
                  subtitle: Text(
                    'Uso de CFDI',
                    style: GoogleFonts.sulphurPoint(
                        textStyle: TextStyle(color: azulp)),
                  ),
                  title: Autocomplete<Modelcatuso>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      return _sugesttionsusodecfdi
                          .where((Modelcatuso county) => county.descripcion
                              .toLowerCase()
                              .startsWith(textEditingValue.text.toLowerCase()))
                          .toList();
                    },
                    displayStringForOption: (Modelcatuso option) =>
                        option.descripcion,
                    fieldViewBuilder: (BuildContext context,
                        TextEditingController fieldTextEditingController,
                        FocusNode fieldFocusNode,
                        VoidCallback onFieldSubmitted) {
                      return TextField(
                        controller: fieldTextEditingController,
                        focusNode: fieldFocusNode,
                      );
                    },
                    onSelected: (Modelcatuso selection) {
                      setState(() {
                        _selusocfdi = selection.cve;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _email,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      labelText: 'Correo electrónico',
                      labelStyle: GoogleFonts.sulphurPoint(
                          textStyle: TextStyle(color: azulp)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _telefono,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      labelText: 'Teléfono',
                      labelStyle: GoogleFonts.sulphurPoint(
                          textStyle: TextStyle(color: azulp)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _nombrecontacto,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      labelText: 'Contacto',
                      labelStyle: GoogleFonts.sulphurPoint(
                          textStyle: TextStyle(color: azulp)),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: _selregimen != '' &&
                                    _razonsocial.text != '' &&
                                    _selusocfdi != ''
                                ? azulp
                                : gris),
                        onPressed: () {
                          _selregimen != '' &&
                                  _razonsocial.text != '' &&
                                  _selusocfdi != ''
                              ? guardar()
                              : print('nada');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Guardar',
                                style: GoogleFonts.sulphurPoint(
                                    textStyle: TextStyle(color: blanco)),
                              ),
                              Icon((Icons.save)),
                            ],
                          ),
                        ))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Modelcatregimen>> getregimen() async {
    //print('======$notmes======');
    var data = {'tipo': 'cat_regimen'};
    // print(data);
    final response = await http.post(urlclientes,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      // print(response.body);

      List<Modelcatregimen> studentList = items.map<Modelcatregimen>((json) {
        return Modelcatregimen.fromJson(json);
      }).toList();
      _sugesttionsregimen = items.map<Modelcatregimen>((json) {
        return Modelcatregimen.fromJson(json);
      }).toList();

      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  Future<List<Modelcatuso>> getusodecfdi() async {
    //print('======$notmes======');
    var data = {
      'tipo': 'cat_uso',
    };
    print(data);
    final response = await http.post(urlclientes,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      print(response.body);

      List<Modelcatuso> studentList = items.map<Modelcatuso>((json) {
        return Modelcatuso.fromJson(json);
      }).toList();
      _sugesttionsusodecfdi = items.map<Modelcatuso>((json) {
        return Modelcatuso.fromJson(json);
      }).toList();

      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  Future guardar() async {
    var data = {
      'tipo': 'alta_clientes',
      'usuario': usuario,
      'rfc_cliente': _rfc.text.toUpperCase(),
      'email': _email.text,
      'razon_social': _razonsocial.text.toUpperCase(),
      'uso_cfdi': _selusocfdi,
      'regimen': _selregimen,
      'domicilio': _domicilio.text.toUpperCase(),
      'cp': _cp.text,
      'telefono': _telefono.text,
      'nombre_contacto': _nombrecontacto.text.toUpperCase(),
      'razon_regimen': ''
    };
    print(data);

    var res = await http.post(urlclientes,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    print(res.body);

    final snackBar = SnackBar(
      content: const Text('Se registro correctamente'),
      backgroundColor: (azulp),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    setState(() {
      _razonsocial.clear();
      _rfc.clear();
      _cp.clear();
      _email.clear();
      _telefono.clear();
      _nombrecontacto.clear();
      _domicilio.clear();
    });
    Navigator.of(context).pop();
  }
}
