import 'package:asa_mexico/src/pages/materiales/addmateriales.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Wlistamateriales extends StatelessWidget {
  const Wlistamateriales({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        Container(
            height: 40,
            padding: const EdgeInsets.all(10.0),
            child: Text("Lista de Materiales",
                style: TextStyle(color: Colors.redAccent, fontSize: 18.0))),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: searchBox(),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
                child: Listamateriales(),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                )),
          ),
        ),
      ],
    );
  }

  Widget searchBox() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (text) {
          // _filterMateList(text);
        },
        controller: editingController,
        decoration: InputDecoration(
            labelText: "Buscar",
            hintText: "Buscar",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)))),
      ),
    );
  }
}

class Listamateriales extends StatefulWidget {
  //final String usuario;
  Listamateriales();

  //String _searchText = "";

  @override
  State<StatefulWidget> createState() {
    return Listamateria();
  }
}

TextEditingController editingController = TextEditingController();

class Listamaterial {
  String? nombre;
  String? descripcion;
  String? unidad;
  String? tipo;
  double? cantidad;
  int? idproducto;

  Listamaterial(
      {this.nombre,
      this.descripcion,
      this.unidad,
      this.tipo,
      this.cantidad,
      this.idproducto});
  factory Listamaterial.fromJson(Map<String, dynamic> json) {
    return Listamaterial(
        nombre: json['Nombre'],
        descripcion: json['Descripcion'],
        unidad: json['Unidad'],
        tipo: json['Tipo'],
        cantidad: json['CANTIDAD'].toDouble(),
        idproducto: json['id']);
  }
}

class Listamateria extends State<Listamateriales> {
  //final String usuario;
  //TextEditingController comentariosctl = TextEditingController();
  //TextEditingController idctl = TextEditingController();
  Listamateria();

  String estado = "";
  bool? error, sending, success;
  String? msg;
  String user = "";
  // API URL
  final apiurl = Uri.parse(
    'https://asamexico.com.mx/php/controller/listamateriales.php',
  );

  int? get idp => null;

  //String user = this.usuario;
  Future<List<Listamaterial>?> fetchStudents() async {
    var response = await http.get(apiurl);

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      //print(this.usuario);
      List<Listamaterial>? studentList = items.map<Listamaterial>((json) {
        return Listamaterial.fromJson(json);
      }).toList();

      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Listamaterial>?>(
        future: fetchStudents(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return ListView(
              children: snapshot.data!
                  .map(
                    (data) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          leading: Text(
                              data.cantidad.toString() + " " + data.unidad!,
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14.0,
                                  color: Colors.redAccent)),

                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Addmaterial(
                                          idproducto: data.idproducto,
                                          nombre: data.nombre,
                                          descripcion: data.descripcion,
                                          unidad: data.unidad,
                                          tipo: data.tipo,
                                          cantidad: data.cantidad,
                                        )));
                          },
                          trailing: Icon(Icons.add_circle_outline_rounded,
                              color: Color.fromRGBO(35, 56, 120, 1.0),
                              size: 30),
                          //Agregamos el nombre con un Widget Text
                          title: Text(
                              "Producto:      " +
                                  data.nombre! +
                                  "  " +
                                  data.descripcion!,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14.0)
                              //le damos estilo a cada texto
                              ),
                          subtitle: Text('Tipo:    ' + data.tipo!,
                              style: TextStyle(
                                  color: Color.fromRGBO(35, 56, 120, 0.8))),
                        ),
                      ),
                    ),
                  )
                  .toList());
        });
  }
}
