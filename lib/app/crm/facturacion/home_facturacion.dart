import 'package:Asamexico/app/crm/facturacion/Altafactura_facturacion.dart';
import 'package:Asamexico/app/variables/colors.dart';
import 'package:Asamexico/app/variables/servicesurl.dart';
import 'package:Asamexico/models/facturacion_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class homefacturacion extends StatefulWidget {
  const homefacturacion({super.key});

  @override
  State<homefacturacion> createState() => _homefacturacionState();
}

class _homefacturacionState extends State<homefacturacion> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      backgroundColor: azulp,
      title: Text('Facturación'),),body: FutureBuilder<List<Modellistacfdi>>(
          future: listaprod(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Container(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircularProgressIndicator(
                    color: azulp,
                  ),
                ),
              );
      
            return ListView(
                children: snapshot.data!
                    .map((data) =>Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Card(
                        elevation: 10,
                        shadowColor: azulp,
                        child: ListTile(
                          
                          title: Text(data.nombre_receptor,
                                            style: GoogleFonts.itim(
                                              textStyle: TextStyle(color:azulp),
                                            )),
                           trailing: Text(
                                            NumberFormat.simpleCurrency()
                                                .format(double.parse(data.total)),
                                            style: GoogleFonts.sulphurPoint(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  decoration: data.status ==
                                                          'cancelado'
                                                      ? TextDecoration.lineThrough
                                                      : TextDecoration.none,
                                                  fontWeight: FontWeight.bold),
                                            )),
                          subtitle: Text(data.folio,
                        
                                            style: GoogleFonts.itim(
                                              textStyle: TextStyle(color: gris),
                                            )), leading: Text(
                                            DateFormat('dd/MM')
                                                .format(data.fecha)
                                                .toString(),
                                            style: GoogleFonts.itim(
                                              textStyle: TextStyle(color: azuls),
                                            )),),
                      ),
                    )).toList());}), floatingActionButton: FloatingActionButton(
        backgroundColor: rojo,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Altafactura_facturacion()));
        },
        child: Icon(
          Icons.add,
          color: blanco,
        ),
      ),);
  }


  
  Future<List<Modellistacfdi>> listaprod() async {
    //print('======$notmes======');
    var data = {
      'tipo': 'lista_documentos',
      'rfc_emisor': 'ASA911031GJ0',
      'tipo_doc': 'Factura' // 'buscar': _buscar.text
    };
    //print(data);
    final response = await http.post(urldocumentostimbrados,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      //print(response.body);

      List<Modellistacfdi> studentList = items.map<Modellistacfdi>((json) {
        return Modellistacfdi.fromJson(json);
      }).toList();
      setState(() {});
      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }
}