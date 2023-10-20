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
    //final image = (await rootBundle.load('assets/images/asaazul.jpg')).buffer.asUint8List();

    // Función para crear una página con el contenido del inventario
    pw.Widget _buildInventarioPage() {
      return pw.Container(
        padding: pw.EdgeInsets.all(20),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            // pw.Container(
            //   width: 50,
            //   height: 50,
            //   child: pw.Align(
            //     child: pw.Center(
            //       child: pw.Image(PdfImage(
            //         pdf,
            //         image: image,
            //         width: 50,
            //         height: 50,
            //       )),
            //     ),
            //     alignment: pw.Alignment.center,
            //   ),
            // ),
            pw.SizedBox(height: 10),
            pw.Text("Automatización de Sistemas y Asesoría"),
            pw.Center(child: pw.Text('Hoja de inventario')),
            pw.Divider(),
            pw.Center(child: pw.Text('Fecha')),
            pw.Divider(),
            _productos(_inventario),
          ],
        ),
      );
    }

    // Agregar páginas de inventario usando pw.MultiPage
    pdf.addPage(pw.MultiPage(
      build: (context) {
        return [
          _buildInventarioPage(),
          // Puedes agregar más páginas de inventario aquí si es necesario.
          // _buildInventarioPage(),
          // _buildInventarioPage(),
        ];
      },
      pageFormat: PdfPageFormat.letter.copyWith(
        marginLeft: 20,
        marginTop: 10,
        marginRight: 20,
        marginBottom: 20,
      ),
    ));

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
