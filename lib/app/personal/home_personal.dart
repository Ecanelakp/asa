import 'package:Asamexico/app/configuracion/usuarios/detalle_usuarios.configuracion.dart';
import 'package:Asamexico/app/variables/colors.dart';
import 'package:Asamexico/app/variables/servicesurl.dart';
import 'package:Asamexico/models/usuarios_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class home_personal extends StatefulWidget {
  const home_personal({super.key});

  @override
  State<home_personal> createState() => _home_personalState();
}

class _home_personalState extends State<home_personal> {
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
    listausuarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal',
            style: GoogleFonts.sulphurPoint(
              textStyle: TextStyle(color: blanco),
            )),
        backgroundColor: azulp,
      ),
      body: Container(
          child: Container(
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
                                  child: ListTile(
                                      title: Text(data.nombre.toString(),
                                          style: GoogleFonts.sulphurPoint(
                                            textStyle: TextStyle(color: gris),
                                          )),
                                      onTap: (() {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    detalleusuarios_configuracion(
                                                        data.id,
                                                        data.email,
                                                        data.nombre,
                                                        data.perfil,
                                                        data.status)));
                                      }),
                                      subtitle: Text(data.perfil.toString(),
                                          style: GoogleFonts.sulphurPoint(
                                            textStyle: TextStyle(color: azulp),
                                          )),
                                      leading: CircleAvatar(
                                        backgroundImage: AssetImage(
                                          "assets/images/profile.png",
                                        ),
                                      ),
                                      trailing: TextButton.icon(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          label: Text('4.86'))),
                                )))
                            .toList());
                  }))),
    );
  }
}
