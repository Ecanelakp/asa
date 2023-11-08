import 'dart:typed_data';

import 'package:asamexico/app/variables/colors.dart';
import 'package:asamexico/app/variables/servicesurl.dart';
import 'package:asamexico/models/productos_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

List<Modellistaproductos> _inventario = [];
String _tipo = '';
DateTime? _hoy;

class inventario_productos extends StatefulWidget {
  const inventario_productos({super.key});

  @override
  State<inventario_productos> createState() => _inventario_productosState();
}

class _inventario_productosState extends State<inventario_productos> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listaprod();
    _hoy = DateTime.now();
  }

  Future<List> listaprod() async {
    //print('======$notmes======');
    var data = {
      'tipo': 'lista_productos',
      'tipo_mat': _tipo,
    };
    print(data);
    final response = await http.post(urlproductos,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      print(response.body);

      _inventario = items.map<Modellistaproductos>((json) {
        return Modellistaproductos.fromJson(json);
      }).toList();
      setState(() {});
      return _inventario;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (Text('Inventarios',
            style: GoogleFonts.sulphurPoint(
              textStyle: TextStyle(color: blanco),
            ))),
        backgroundColor: azulp,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: azuls,
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      _tipo = 'Material';
                      listaprod();
                    });
                  },
                  child: Text(
                    'A',
                    style: TextStyle(color: blanco),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: rojo,
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      _tipo = 'Herramientas';
                      listaprod();
                    });
                  },
                  child: Text(
                    'B',
                    style: TextStyle(color: blanco),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.black38,
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      _tipo = 'Insumos';
                      listaprod();
                    });
                  },
                  child: Text(
                    'C',
                    style: TextStyle(color: blanco),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: gris,
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      _tipo = '';
                      listaprod();
                    });
                  },
                  child: Icon(
                    Icons.list,
                    color: blanco,
                  )),
            ),
          )
        ],
      ),
      body: PdfPreview(
        build: (context) => makePdf(_inventario),
      ),
    );
  }

  Future<Uint8List> makePdf(List inventario) async {
    final pdf = pw.Document();
    final image = await imageFromAssetBundle('assets/images/asaazul.jpg');
    pdf.addPage(pw.MultiPage(
      margin: const pw.EdgeInsets.all(20),
      pageFormat: PdfPageFormat.letter,
      build: (context) {
        return [
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Container(
                      width: 50,
                      height: 100,
                      child: pw.Align(
                        child: pw.Center(
                          child: pw.Image(image),
                        ),
                        alignment: pw.Alignment.center,
                      )),
                  pw.SizedBox(width: 10),
                  pw.Text(
                    "Automatización de Sistemas y Asesoria",
                  ),
                  pw.Center(child: pw.Text('Inventario ' + _tipo)),
                ]),
            pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                    'Fecha: ' +
                        DateFormat('dd/MM/yyyy').format(_hoy!).toString(),
                    textAlign: pw.TextAlign.right)),
            pw.Divider(),
          ]),
          _productos(_inventario),
        ];
      },
      //footer: _buildFooter,
    ));

    // Agregar páginas de inventario usando pw.MultiPage

    return pdf.save();
  }

  pw.Widget _productos(List<Modellistaproductos> _inventario) {
    final headers = [
      'Tipo',
      'Nombre',
      'Descripcion',
      'Inv. Sistema',
      'Inv Fisico',
      'Dif'
    ];
    final rows = _inventario.map((producto) {
      return [
        producto.tipo,
        producto.nombre,
        producto.descripcion,
        producto.inventario,
      ];
    }).toList();

    return pw.Table.fromTextArray(
      //border: null,

      headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
      headerHeight: 15,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.centerRight,
      },
      cellPadding: pw.EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      data: [headers, ...rows],

      cellStyle: pw.TextStyle(
        fontSize: 6,

        // color: PdfColors.black,
        // fontStyle: pw.FontStyle.italic,
      ),
      columnWidths: {
        0: pw.FlexColumnWidth(1), // Descripción centrada
        1: pw.FlexColumnWidth(2), // Cantidad centrada
        2: pw.FlexColumnWidth(3), // Precio centrado
        3: pw.FlexColumnWidth(1), // Total centrado
        4: pw.FlexColumnWidth(1), // Total centrado
        5: pw.FlexColumnWidth(1), // Total centrado
      },
    );
  }
}
