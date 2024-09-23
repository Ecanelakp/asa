import 'package:Asamexico/app/crm/facturacion/Altafactura_facturacion.dart';
import 'package:flutter/material.dart';

String? idserie = '';
String? selserie = '';
String? selfolio = '';
String? seltipo = '';
String? tipocfdi = '';

Future timbrartxt() async {
    print('aquiiiiiiiiiii');
    var _listapartidas = lineas.map((e) {
      return {
                  "ClaveProductoServicio": e.numProdSat,
                  "Cantidad": e.cantidad,
                  "ClaveUnidad": "H87",
                  "Descripcion": e.descripcion,
                  'Unidad': e.unidad,
                  'num_identi': e.numProdSat,
                  "ValorUnitario":
                      (double.tryParse(e.valorunitario.toString())!)
                          .toStringAsFixed(2),
                  "Importe": ((double.tryParse(e.valorunitario.toString())!) *
                          double.tryParse(e.cantidad.toString())!)
                      .toStringAsFixed(2),
                  "ObjetoImpuesto": '02',
                  'trasladoBase':
                      ((double.tryParse(e.valorunitario.toString())! *
                              double.tryParse(e.cantidad.toString())!))
                          .toStringAsFixed(2),
                  'trasladoImpuesto': '002',
                  'trasladoTipoFactor': 'Tasa',
                  'trasladoTasaCuota':
                      (double.parse(e.ivatrasladado!) / 100).toStringAsFixed(6),
                  'trasladoImporte':
                      (((double.tryParse(e.valorunitario.toString())! *
                                  double.tryParse(e.cantidad.toString())!)) *
                              (double.parse(e.ivatrasladado!) / 100))
                          .toStringAsFixed(2),
                };
    }).toList();
    print(_listapartidas);
    var data = {
      'Data': [
        {
          'Version': '4.0',
          'Fecha': DateTime.now().toString(),
          //'Subtotal': double.tryParse(subTotal.toString())!.toStringAsFixed(2),
          'Moneda': 'MXN',
          //'Total': double.tryParse(total.toString())!.toStringAsFixed(2),
          'TipoComprobante': 'factura',
          'Exportacion': '01',
          'LugarExpedicion': ' 03580',
          'Formapago': formapago.substring(0, 2),
          'Metodopago': metodopago.substring(0, 3),
          //'Folio': selfolio,
          //'Serie': selserie,
          'CP':  '03580',
          'UUID_DR': '',
          'Tipo_DR':'',
          'ig_per': '',
          'ig_mes': '',
          'ig_anio': ''
        }
      ],
      'Emisor': [
        {
          'RFC': 'ASA911031GJ0',
          'Nombre':  'AUTOMATIZACION DE SISTEMAS Y ASESORIA',
          'Regimen': '601',
        }
      ],
      'Receptor': [
        {
          // 'RFC': rfcreceptor,
          // 'Nombre': razonsocialreceptor,
          // 'DomicilioFiscalReceptor': cpreceptor,
          // 'Regimen': regimenreceptor,
          // 'UsoCFDI': usocfdi
        }
      ],
      'Conceptos': _listapartidas,
      'trasladado': [
         {
                    // 'Base': double.tryParse(subTotal.toString())!
                    //     .toStringAsFixed(2),
                    // 'Importe':
                    //     double.tryParse(iva.toString())!.toStringAsFixed(2),
                    // 'Tipo': '002',
                    // 'Tipofactor': 'Tasa',
                    // 'TasaCuota':
                    //     (double.parse(tasaiva) / 100).toStringAsFixed(6),
                  }
      ],

    };
    
    print(data);
    }