import 'package:asa_mexico/src/Provider/provider_mate.dart';
import 'package:asa_mexico/src/models/models_mate.dart';
import 'package:asa_mexico/src/pages/materiales/addmateriales.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class UserFilterDemo extends StatefulWidget {
  UserFilterDemo() : super();

  final String title = "Lista Materiales";

  @override
  UserFilterDemoState createState() => UserFilterDemoState();
}

class Debouncer {
  final int? milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds!), action);
  }
}

class UserFilterDemoState extends State<UserFilterDemo> {
  // https://jsonplaceholder.typicode.com/users

  final _debouncer = Debouncer(milliseconds: 500);
  List<User>? users = [];
  List<User>? filteredUsers = [];

  @override
  void initState() {
    super.initState();
    Services.getUsers().then((usersFromServer) {
      setState(() {
        users = usersFromServer;
        filteredUsers = users;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(8),
            child: Text("Lista de Materiales",
                style: TextStyle(
                  color: Color.fromRGBO(35, 56, 120, 0.8),
                  fontSize: 14,
                ))),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
                labelText: "Buscar",
                hintText: "Buscar",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            onChanged: (string) {
              _debouncer.run(() {
                setState(() {
                  filteredUsers = users!
                      .where((u) => (u.nombre!
                              .toLowerCase()
                              .contains(string.toLowerCase()) ||
                          u.descripcion!
                              .toLowerCase()
                              .contains(string.toLowerCase())))
                      .toList();
                });
              });
            },
          ),
        ),
        //filteredUsers[index].nombre,
        //filteredUsers[index].descripcion.toLowerCase(),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: filteredUsers!.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: ListTile(
                    leading: Text(
                        filteredUsers![index].cantidad.toString() +
                            " " +
                            filteredUsers![index].unidad!,
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 14.0,
                            color: Colors.redAccent)),

                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Addmaterial(
                                    idproducto:
                                        filteredUsers![index].idproducto,
                                    nombre: filteredUsers![index].nombre,
                                    descripcion:
                                        filteredUsers![index].descripcion,
                                    unidad: filteredUsers![index].unidad,
                                    tipo: filteredUsers![index].tipo,
                                    cantidad: filteredUsers![index].cantidad,
                                  )));
                    },
                    trailing: Icon(Icons.add_circle_outline_rounded,
                        color: Color.fromRGBO(35, 56, 120, 1.0), size: 30),
                    //Agregamos el nombre con un Widget Text
                    title: Text(
                        "Producto:      " +
                            filteredUsers![index].nombre! +
                            "  " +
                            filteredUsers![index].descripcion!,
                        style: TextStyle(color: Colors.black, fontSize: 14.0)
                        //le damos estilo a cada texto
                        ),
                    subtitle: Text('Tipo:    ' + filteredUsers![index].tipo!,
                        style:
                            TextStyle(color: Color.fromRGBO(35, 56, 120, 0.8))),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
