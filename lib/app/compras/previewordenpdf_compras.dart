import 'package:asamexico/app/compras/crearorden_compras.dart';
import 'package:asamexico/app/variables/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class previesordenpdf_compras extends StatelessWidget {
  final List<Lineas> lineas;
  final String _nombreproveedor;
  final String _fechasol;
  final String _referencia;
  final String _condicionespago;
  final String _notas;
  final double _total;
  const previesordenpdf_compras(
      this.lineas,
      this._nombreproveedor,
      this._fechasol,
      this._referencia,
      this._condicionespago,
      this._notas,
      this._total);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear de Compra',
            style: GoogleFonts.itim(
              textStyle: TextStyle(),
            )),
        backgroundColor: azulp,
        actions: [],
      ),
      body: PdfPreview(
        build: (context) => makePdf(),
      ),
    );
  }

  Future<Uint8List> makePdf() async {
    final pdf = pw.Document();
    final image = await imageFromAssetBundle('assets/images/asablanco.jpg');

    // Función para crear una página con el contenido del inventario
    pw.Widget _buildInventarioPage() {
      return pw.Container(
        padding: pw.EdgeInsets.all(5),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Container(
                width: 120,
                child: pw.Align(
                  child: pw.Center(
                    child: pw.Image(image),
                  ),
                  alignment: pw.Alignment.center,
                )),
            pw.Text("Automatización de Sistemas y Asesoría"),
            pw.Center(child: pw.Text('Orden de compra')),
            pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    pw.Text('Proveedor:' + _nombreproveedor),
                    pw.Text('Fecha solicitada:' + _fechasol),
                  ],
                )),
            pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    pw.Text('Referencia:' + _referencia),
                    pw.Text('Condiciones de pago:' + _condicionespago),
                  ],
                )),
            pw.Divider(),
            pw.Divider(),
            _productos(lineas),
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
      footer: _buildFooter,
    ));

    return pdf.save();
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
        child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
          pw.Text('Notas:' + _notas),
          pw.SizedBox(height: 10),
          pw.Container(
              padding: const pw.EdgeInsets.all(8.0),
              width: double.infinity,
              color: PdfColors.grey600,
              child: pw.Text(
                  'Total:' + NumberFormat.simpleCurrency().format(_total),
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      color: PdfColors.white, fontWeight: pw.FontWeight.bold))),
          pw.SizedBox(height: 10),
          pw.Container(
            child: pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text(
                    'Miravalle 805 Int. 3, Col. Miravalle, Delg. Benito Juarez CP. 03580 CDMX',
                    style: pw.TextStyle(fontSize: 10))),
          )
        ]));
  }

  pw.Widget _productos(List<Lineas> lineas) {
    final headers = ['Cantidad', 'Descripcion', 'Precio Unitario', 'Subtotal'];
    final rows = lineas.map((producto) {
      return [
        NumberFormat.decimalPattern()
            .format(double.parse(producto.cantidad.toString())),
        producto.descripcion,
        NumberFormat.simpleCurrency()
            .format(double.parse(producto.valorunitario.toString())),
        NumberFormat.simpleCurrency().format(
            (double.tryParse(producto.cantidad.toString()))! *
                (double.tryParse(producto.valorunitario.toString())!))
      ];
    }).toList();

    return pw.Table.fromTextArray(
      //border: null,

      headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
      headerHeight: 15,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight
      },
      cellPadding: pw.EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      data: [headers, ...rows],

      cellStyle: pw.TextStyle(
        fontSize: 10,

        // color: PdfColors.black,
        // fontStyle: pw.FontStyle.italic,
      ),
      columnWidths: {
        0: pw.FlexColumnWidth(1), // Descripción centrada
        1: pw.FlexColumnWidth(3), // Cantidad centrada
        2: pw.FlexColumnWidth(1), // Precio centrado
        3: pw.FlexColumnWidth(2), // Total centrado
      },
    );
  }
}
