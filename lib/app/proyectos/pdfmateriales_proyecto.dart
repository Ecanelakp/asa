import 'dart:typed_data';

import 'package:asamexico/app/variables/colors.dart';
import 'package:asamexico/models/proyectos_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class pdfmateriales_proyecto extends StatefulWidget {
  final _materiales;
  final String _nombre;
  final String _observaciones;
  const pdfmateriales_proyecto(
      this._materiales, this._nombre, this._observaciones);

  @override
  State<pdfmateriales_proyecto> createState() => _pdfmateriales_proyectoState();
}

class _pdfmateriales_proyectoState extends State<pdfmateriales_proyecto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Proyectos',
            style: GoogleFonts.sulphurPoint(
              textStyle: TextStyle(color: blanco),
            )),
        backgroundColor: azulp,
      ),
      backgroundColor: blanco,
      body: PdfPreview(
        build: (context) => makePdf(widget._materiales),
      ),
    );
  }

  Future<Uint8List> makePdf(List<Modellistaproyprods> materiales) async {
    final pdf = pw.Document();
    final image = await imageFromAssetBundle('assets/images/asaazul.jpg');
    pdf.addPage(pw.MultiPage(
      margin: const pw.EdgeInsets.all(10),
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
                  pw.Center(child: pw.Text('Hoja de entrega de materiales')),
                ]),
            pw.Divider(),
            pw.Center(child: pw.Text('Proyecto: ' + widget._observaciones)),
            pw.Center(child: pw.Text('Cliente: ' + widget._nombre)),
            pw.Center(child: pw.Text('Fecha')),
            pw.Divider(),
            _productos(materiales),
          ])
        ];
      },
      footer: _buildFooter,
    ));

    return pdf.save();
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
        child: pw.Align(
      alignment: pw.Alignment.center,
      child: pw.Text(
          'Miravalle 805 Int. 3, Col. Miravalle, Delg. Benito Juarez CP. 03580 CDMX',
          style: pw.TextStyle(fontSize: 10)),
    ));
  }

  pw.Widget _productos(List<Modellistaproyprods> materiales) {
    final headers = [
      'Descripción',
      'Cant',
      'status',
      'Asignado',
      'Observaciones',
      'Check'
    ];
    final rows = materiales.map((producto) {
      return [
        producto.producto,
        producto.cantidad,
        producto.tipoMovimiento,
        producto.usuarioAsignado,
      ];
    }).toList();

    return pw.Table.fromTextArray(
      //border: null,

      headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
      headerHeight: 30,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerRight,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
      },
      cellPadding: pw.EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      data: [headers, ...rows],

      cellStyle: pw.TextStyle(
        fontSize: 8,

        // color: PdfColors.black,
        // fontStyle: pw.FontStyle.italic,
      ),
      columnWidths: {
        0: pw.FlexColumnWidth(2), // Descripción centrada
        1: pw.FlexColumnWidth(1), // Cantidad centrada
        2: pw.FlexColumnWidth(1), // Precio centrado
        3: pw.FlexColumnWidth(2), // Total centrado
        4: pw.FlexColumnWidth(2), // Total centrado
        5: pw.FlexColumnWidth(1), // Total centrado
      },
    );
  }
}
