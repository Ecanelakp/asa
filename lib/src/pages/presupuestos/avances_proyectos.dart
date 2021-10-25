import 'dart:async';

import 'package:asa_mexico/src/models/models_sistemas.dart';
import 'package:asa_mexico/src/pages/presupuestos/altasistemas_proyectos.dart';
import 'package:asa_mexico/src/pages/presupuestos/avances_sistemas.dart';
import 'package:asa_mexico/src/pages/presupuestos/avancesxdia_proyectos.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Avancesproyectoshm extends StatefulWidget {
  final String idHolder;
  final String referencia;
  Avancesproyectoshm(this.idHolder, this.referencia);

  @override
  _AvancesproyectoshmState createState() => _AvancesproyectoshmState();
}

class _AvancesproyectoshmState extends State<Avancesproyectoshm> {
  final apiurl1 = Uri.parse(
    'https://asamexico.com.mx/php/controller/proyectosumrealpres.php',
  );

  @override
  void initState() {
    super.initState();
    recibirString();
  }

  String _avance = '';
  Future<String> recibirString() async {
    var data = {'idp': widget.idHolder};
    final respuesta = await http.post(apiurl1, body: json.encode(data));
    if (respuesta.statusCode == 200) {
      //log(respuesta.body.toString());
      setState(() {
        _avance = respuesta.body.toString();
      });
    } else {
      throw Exception("Fallo");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro Avances'),
        backgroundColor: Color.fromRGBO(35, 56, 120, 1.0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color.fromRGBO(35, 56, 120, 1.0),
              ),
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Avance real / Presupuesto",
                    style: (TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    _avance,
                    style: (TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Sistemas usados',
                    style: (TextStyle(
                        color: Color.fromRGBO(35, 56, 120, 1.0), fontSize: 20)),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.calendar_today,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Avancexdia(
                                    widget.idHolder, widget.referencia)));
                      }),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: Color.fromRGBO(35, 56, 120, 1.0),
                  //                   <--- border color
                ),
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.1), BlendMode.dstATop),
                    image: AssetImage(
                      'assets/images/asablanco.jpg',
                    ),
                    fit: BoxFit.cover),
              ),
              height: MediaQuery.of(context).size.height * 0.55,
              width: MediaQuery.of(context).size.width * 1,
              child: Listasisusados(widget.idHolder),
            ),
            Text('desliza hacia abajo actualizar la informacion')
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Sistemasproyecto(widget.idHolder, widget.referencia)));
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}

class Listasisusados extends StatefulWidget {
  final String idHolder;

  const Listasisusados(this.idHolder);
  @override
  _ListasisusadosState createState() => _ListasisusadosState();
}

class _ListasisusadosState extends State<Listasisusados> {
  Future<List<Sistemasusadosp>> jsonsistemasused() async {
    var data = {'idp': widget.idHolder};
    var response = await http.post(
        Uri.parse(
            'https://asamexico.com.mx/php/controller/proyectossistemasusados.php'),
        body: json.encode(data));
    print(response);
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      print(items);
      List<Sistemasusadosp> sistemasList = items.map<Sistemasusadosp>((json) {
        return Sistemasusadosp.fromJson(json);
      }).toList();

      return sistemasList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  Future<void> _refreshProducts(BuildContext context) async {
    return setState(() {
      _ListasisusadosState();
    });
  }

  @override
  Widget build(BuildContext context) {
    jsonsistemasused();
    return RefreshIndicator(
      onRefresh: () => _refreshProducts(context),
      child: FutureBuilder<List<Sistemasusadosp>>(
          future: jsonsistemasused(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());

            return ListView(
                children: snapshot.data
                    .map((data) => Container(
                            child: Card(
                          child: ListTile(
                            title: Text(
                              data.referenciaSistema.toString(),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Responsable: ' + data.responsable),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('Fecha incio:' + data.fechaInicio),
                              ],
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: Color.fromRGBO(35, 56, 120, 1.0),
                              size: 20,
                            ),
                            leading: Text(data.cantidad.toString() +
                                '/' +
                                data.sumAvance.toString()),
                            onTap: () {
                              //print(widget.idHolder);
                              //print(data.id);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Avanceproyectos(
                                          widget.idHolder.toString(),
                                          data.id.toString(),
                                          data.cantidad.toString(),
                                          data.referenciaSistema)));
                            },
                          ),
                        )))
                    .toList());
          }),
    );
  }
}
