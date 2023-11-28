import 'package:Asamexico/app/crm/cotizaciones/altacotizacion_clientes.dart';
import 'package:Asamexico/app/variables/colors.dart';
import 'package:Asamexico/app/variables/servicesurl.dart';

import 'package:Asamexico/models/proyectos_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

List<Modellineascoti> _lineas = [];

class pdfcotizacioncreada_clientes extends StatefulWidget {
  final String _id;
  final String _nombreproveedor;
  final String _fechasol;
  final String _referencia;
  final String _condicionespago;
  final String _notas;
  final double _total;
  const pdfcotizacioncreada_clientes(
      this._id,
      this._nombreproveedor,
      this._fechasol,
      this._referencia,
      this._condicionespago,
      this._notas,
      this._total);

  @override
  State<pdfcotizacioncreada_clientes> createState() =>
      _pdfcotizacioncreada_clientesState();
}

class _pdfcotizacioncreada_clientesState
    extends State<pdfcotizacioncreada_clientes> {
  @override
  void initState() {
    super.initState();
    listalineas();
  }

  Future<List<Modellineascoti>> listalineas() async {
    //print('======$notmes======');
    var data = {'tipo': 'lista_lin_ventas', 'id_venta': widget._id};
    print(data);
    final response = await http.post(urlventas,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      print(response.body);

      List<Modellineascoti> studentList = items.map<Modellineascoti>((json) {
        return Modellineascoti.fromJson(json);
      }).toList();
      _lineas = items.map<Modellineascoti>((json) {
        return Modellineascoti.fromJson(json);
      }).toList();
      setState(() {});
      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vista previa de cotización',
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
    final PdfColor _azul = PdfColor.fromInt(0x23387A);

    // Función para crear una página con el contenido del inventario
    pw.Widget _buildInventarioPage(PdfColor azul) {
      return pw.Container(
        padding: pw.EdgeInsets.all(3),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
              pw.Container(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text('    ')),
              pw.Container(
                  width: 100,
                  child: pw.Align(
                    child: pw.Center(
                      child: pw.Image(image),
                    ),
                    alignment: pw.Alignment.center,
                  )),
            ]),
            pw.Container(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Text('Cotización')),
            pw.Container(
                child: pw.Row(
              children: [
                pw.Container(
                    color: _azul,
                    padding: const pw.EdgeInsets.all(5.0),
                    child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Cliente:',
                              style: pw.TextStyle(color: PdfColors.white)),
                          pw.Text('Fecha solicitada:',
                              style: pw.TextStyle(color: PdfColors.white)),
                          pw.Text('Referencia:',
                              style: pw.TextStyle(color: PdfColors.white)),
                          pw.Text('Condiciones de pago:',
                              style: pw.TextStyle(color: PdfColors.white)),
                        ])),
                pw.Container(
                  padding: const pw.EdgeInsets.all(5.0),
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(widget._nombreproveedor),
                        pw.Text(widget._fechasol),
                        pw.Text(widget._referencia),
                        pw.Text(widget._condicionespago),
                      ]),
                )
              ],
            )),
            pw.Divider(),
            pw.Container(
                width: double.infinity,
                color: _azul,
                padding: const pw.EdgeInsets.all(5.0),
                child: pw.Text('Proyecto/Notas',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(color: PdfColors.white))),
            pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(5.0),
                child: pw.Text(widget._notas)),
          ],
        ),
      );
    }

    // Agregar páginas de inventario usando pw.MultiPage
    pdf.addPage(pw.MultiPage(
      build: (context) {
        return [
          _buildInventarioPage(_azul),
          pw.Divider(),
          _productos(_lineas, _azul),
          pw.Container(
              padding: const pw.EdgeInsets.all(8.0),
              width: double.infinity,
              color: _azul,
              child: pw.Text(
                  'Total: ' +
                      NumberFormat.simpleCurrency().format(widget._total) +
                      ' MN',
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(
                      color: PdfColors.white, fontWeight: pw.FontWeight.bold))),
          _notas(_azul)
          // Puedes agregar más páginas de inventario aquí si es necesario.
          // _buildInventarioPage(),
          // _buildInventarioPage(),
        ];
      },
      pageFormat: PdfPageFormat.letter.copyWith(
        marginLeft: 10,
        marginTop: 10,
        marginRight: 10,
        marginBottom: 10,
      ),
      footer: _buildFooter,
    ));

    return pdf.save();
  }

  pw.Widget _notas(PdfColor _azul) {
    return pw.Container(
      padding: pw.EdgeInsets.all(3),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                  width: 80,
                  height: 40,
                  padding: const pw.EdgeInsets.all(8.0),
                  color: _azul,
                  child: pw.Text('Inicio:',
                      textAlign: pw.TextAlign.justify,
                      style:
                          pw.TextStyle(fontSize: 8, color: PdfColors.white))),
              pw.Flexible(
                  child: pw.Container(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(
                          '2 semanas después de recibida su orden y anticipo,no obstante debido a la entrada deórdenes y rotación de materiales le sugerimos confirmar la fecha de inicio de trabajos antes de colocar su orden en firme.',
                          textAlign: pw.TextAlign.justify,
                          style: pw.TextStyle(fontSize: 8)))),
            ],
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                  width: 80,
                  padding: const pw.EdgeInsets.all(8.0),
                  color: _azul,
                  child: pw.Text('Ejecucion:',
                      textAlign: pw.TextAlign.justify,
                      style:
                          pw.TextStyle(fontSize: 8, color: PdfColors.white))),
              pw.Flexible(
                  child: pw.Container(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(
                    'Se estiman 7 días hábiles, no obstante, dependerá de los horarios y facilidades que nos proporcionen.',
                    style: pw.TextStyle(fontSize: 8)),
              )),
            ],
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                  width: 80,
                  padding: const pw.EdgeInsets.all(8.0),
                  color: _azul,
                  child: pw.Text('Garantía:',
                      textAlign: pw.TextAlign.justify,
                      style:
                          pw.TextStyle(fontSize: 8, color: PdfColors.white))),
              pw.Flexible(
                  child: pw.Container(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(
                    '1 año sobre materiales y mano de obra y de acuerdo al uso y trato del mismo',
                    style: pw.TextStyle(fontSize: 8)),
              )),
            ],
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                  width: 80,
                  height: 40,
                  padding: const pw.EdgeInsets.all(8.0),
                  color: _azul,
                  child: pw.Text('Precios:',
                      textAlign: pw.TextAlign.justify,
                      style:
                          pw.TextStyle(fontSize: 8, color: PdfColors.white))),
              pw.Flexible(
                  child: pw.Container(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(
                    'En moneda nacional +I.V.A. Aun tipo de cambio de 20.00 MXN/Dólar.Cualquier variación en el tipo de cambio mayor a un 2% deberá ajustarse en el costo del presupuesto hasta que este sea liquidado totalmente.',
                    style: pw.TextStyle(fontSize: 8)),
              )),
            ],
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                  width: 80,
                  padding: const pw.EdgeInsets.all(8.0),
                  color: _azul,
                  child: pw.Text('Condiciones:',
                      textAlign: pw.TextAlign.justify,
                      style:
                          pw.TextStyle(fontSize: 8, color: PdfColors.white))),
              pw.Flexible(
                  child: pw.Container(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(
                    '70% anticipo y 30% contra entrega de los trabajos.',
                    style: pw.TextStyle(fontSize: 8)),
              )),
            ],
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                  width: 80,
                  padding: const pw.EdgeInsets.all(8.0),
                  color: _azul,
                  child: pw.Text('Cancelaciones:',
                      textAlign: pw.TextAlign.justify,
                      style:
                          pw.TextStyle(fontSize: 8, color: PdfColors.white))),
              pw.Flexible(
                  child: pw.Container(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(
                    'Cualquier cancelación generará cargos mínimos del 20% más gastos imposibles de recuperar',
                    style: pw.TextStyle(fontSize: 8)),
              )),
            ],
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                  width: 80,
                  padding: const pw.EdgeInsets.all(8.0),
                  color: _azul,
                  child: pw.Text('Notas:',
                      textAlign: pw.TextAlign.justify,
                      style:
                          pw.TextStyle(fontSize: 8, color: PdfColors.white))),
              pw.Flexible(
                  child: pw.Container(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(
                    'El presente presupuesto fue elaborado con la información disponible al momento de realizarlo. ASA se reserva el derecho de revaluar el mismo si se generar' +
                        'aun cambio importante, tales como aspectos que estuvieran ocultos,problemas para el acceso de materiales o equipo,s istemas de seguridad o de protección' +
                        'especiales debido a condiciones propias de la empresa o del inmueble, horarios de trabajo, cancelaciones de labores, demoras o cualquier otro concepto justificable' +
                        ' y no especificado dentro de este presupuesto \n' +
                        '\nLa presente propuesta está basada en los comentarios y requerimientos hechos por ustedes. \n' +
                        ' \nLos trabajos consistirán en el suministro de materiales, mano de obra, equipo, supervisión y dirección de los mismos bajo las condiciones y requisitos de seguridad'
                            ' e higiene establecidos por la empresa y/o el cliente.\n' +
                        '\nTodos nuestros trabajadores están capacitados y asegurados (IMSS).\n' +
                        '\nLos horarios de trabajo están comprendidos de lunes a sábado de 22:00 a 06:00 Hrs. Del día siguiente',
                    textAlign: pw.TextAlign.left,
                    style: pw.TextStyle(fontSize: 8)),
              )),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
        child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
          pw.SizedBox(height: 10),
          pw.Container(
            child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  pw.Container(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text('Automatizacion de Sistemas y Asesoria',
                          style: pw.TextStyle(fontSize: 8))),
                  pw.Text(
                      'Miravalle 805 Int. 3, Col. Miravalle, Delg. Benito Juarez CP. 03580 CDMX',
                      style: pw.TextStyle(fontSize: 8)),
                  pw.Text('https://asamexico.mx',
                      style: pw.TextStyle(fontSize: 8))
                ]),
          )
        ]));
  }

  pw.Widget _productos(List<Modellineascoti> _lineas, PdfColor _azul) {
    final headers = [
      'Cantidad',
      'Uni',
      'Descripcion',
      'Precio Unitario',
      'Subtotal'
    ];
    final rows = _lineas.map((producto) {
      return [
        NumberFormat.decimalPattern()
            .format(double.parse(producto.cantidad.toString())),
        '',
        producto.descripcion!,
        NumberFormat.simpleCurrency()
            .format(double.parse(producto.pu.toString())),
        NumberFormat.simpleCurrency().format(
            (double.tryParse(producto.cantidad.toString()))! *
                (double.tryParse(producto.pu.toString())!))
      ];
    }).toList();

    return pw.Table.fromTextArray(
      //border: null,

      headerDecoration: pw.BoxDecoration(color: _azul),
      headerHeight: 15,
      headerStyle: pw.TextStyle(color: PdfColors.white),
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight
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
        1: pw.FlexColumnWidth(0.7),
        2: pw.FlexColumnWidth(4), //// Cantidad centrada
        3: pw.FlexColumnWidth(1), // Precio centrado
        4: pw.FlexColumnWidth(1), // Total centrado
      },
    );
  }
}
