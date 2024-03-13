import 'package:Asamexico/app/configuracion/usuarios/altausuarios_configuracion.dart';
import 'package:Asamexico/app/configuracion/usuarios/detalle_usuarios.configuracion.dart';
import 'package:Asamexico/app/variables/colors.dart';
import 'package:Asamexico/app/variables/servicesurl.dart';
import 'package:Asamexico/models/compras_model.dart';
import 'package:Asamexico/models/usuarios_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class usuarios_configuracion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: gris,
        title: Text('Control de usuarios',
            style: GoogleFonts.sulphurPoint(
              textStyle: TextStyle(color: blanco),
            )),
      ),
      backgroundColor: blanco,
      body: Container(
        child: _listausuarios(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: azulp,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => altausuarios_configuracion()));
        },
        child: Icon(
          Icons.add,
          color: blanco,
        ),
      ),
    );
  }
}

class _listausuarios extends StatefulWidget {
  const _listausuarios({
    super.key,
  });

  @override
  State<_listausuarios> createState() => _listausuariosState();
}



class _listausuariosState extends State<_listausuarios> {


  Future<List<usuariosmodel>> listausuarios() async {


    
    //print('======$notmes======');
    var data = {
      'tipo': 'lista',
    };
    //print(data);
    final response = await http.post(urluser,
        headers: {
          "Accept": "application/json",
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      //7print(response.body);

      List<usuariosmodel> studentList = items.map<usuariosmodel>((json) {
        return usuariosmodel.fromJson(json);
      }).toList();
      //setState(() {});
      return studentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listausuarios() ;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
    
      child: FutureBuilder<List<usuariosmodel>>(
          future: listausuarios(),
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
                            child: ListTile(title: 
                          Text(data.nombre.toString()), 
                          onTap: (() {
                              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => 
                                detalleusuarios_configuracion(data.id, data.email, data.nombre, data.perfil, data.status)));
                          }),
                          subtitle: Text(data.email.toString()), 
                          leading: CircleAvatar(
                            backgroundColor: azulp,
                            child: Icon(Icons.person_4, color:blanco )),
                          trailing:IconButton(onPressed: (){
                              showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Confirmas que deseas borrar a este usuario?"),
                  content: Text(" Se borra y no podra entrar al sistem, ¿Estas de acuerdo?"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Close"),
                    ),
                  ],
                );
              },
            );
                          }, icon:  Icon(Icons.delete, color: rojo,))),
                          
                          ))).toList());}));
  }
}
