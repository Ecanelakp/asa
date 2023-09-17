import 'package:asamexico/app/Productos/alta_productos.dart';
import 'package:asamexico/app/Productos/detallemov_producto.dart';
import 'package:asamexico/app/home/lateral_app.dart';
import 'package:asamexico/app/variables/colors.dart';
import 'package:asamexico/app/variables/servicesurl.dart';
import 'package:asamexico/models/productos_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

TextEditingController _buscar = TextEditingController();

class home_productos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Productos',
          style: GoogleFonts.itim(textStyle: TextStyle(color: blanco)),
        ),
        backgroundColor: azulp,
      ),
      drawer: menulateral(),
      backgroundColor: blanco,
      body: _listadeproductos(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: rojo,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => alta_productos()));
        },
        child: Icon(
          Icons.add,
          color: blanco,
        ),
      ),
    );
  }
}

class _listadeproductos extends StatefulWidget {
  @override
  State<_listadeproductos> createState() => _listadeproductosState();
}

class _listadeproductosState extends State<_listadeproductos> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listaprod();
  }

  Future<List<Modellistaproductos>> listaprod() async {
    //print('======$notmes======');
    var data = {
      'tipo': 'lista_productos',
    };
    //print(data);
    final response = await http.post(urlproductos,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      //print(response.body);

      List<Modellistaproductos> studentList =
          items.map<Modellistaproductos>((json) {
        return Modellistaproductos.fromJson(json);
      }).toList();
      setState(() {});
      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _buscar,
            onChanged: (value) {
              setState(() {
                listaprod();
              });
            },
            decoration: InputDecoration(
              labelText: 'Busca un producto',
              labelStyle: GoogleFonts.itim(textStyle: TextStyle(color: gris)),
            ),
          ),
        ),
        Flexible(
            child: RefreshIndicator(
                onRefresh: () => listaprod(),
                child: Container(
                    child: FutureBuilder<List<Modellistaproductos>>(
                        future: listaprod(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Container(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                              ),
                            );

                          return ListView(
                              children: snapshot.data!
                                  .map((data) => Container(
                                        child: Card(
                                          elevation: 10,
                                          child: ListTile(
                                            subtitle: Text(
                                              data.descripcion,
                                              style: GoogleFonts.itim(
                                                  textStyle:
                                                      TextStyle(color: gris)),
                                            ),
                                            title: Text(
                                              data.tipo + ' :  ' + data.nombre,
                                              style: GoogleFonts.itim(
                                                  textStyle:
                                                      TextStyle(color: azulp)),
                                            ),
                                            trailing: Text(
                                              data.inventario +
                                                  ' ' +
                                                  data.unidad,
                                              style: GoogleFonts.itim(
                                                  textStyle:
                                                      TextStyle(color: azuls)),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          detallemov_productos(
                                                              data.descripcion,
                                                              data.id,
                                                              data.nombre,
                                                              data.presentacion,
                                                              data.tipo,
                                                              data.unidad,
                                                              data.inventario)));
                                            },
                                          ),
                                        ),
                                      ))
                                  .toList());
                        }))))
      ]),
    );
  }
}
