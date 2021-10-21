import 'package:asa_mexico/src/models/models_sistemas.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final url = '';

String estado = "";
bool error, sending, success;
String msg;
TextEditingController _comentarios = new TextEditingController();
TextEditingController _cantidad = new TextEditingController();

class Avanceproyectos extends StatefulWidget {
  final String idHolder;
  final String id;
  final String cantidad;
  final String referencia;

  const Avanceproyectos(this.idHolder, this.id, this.cantidad, this.referencia);

  @override
  _AvanceproyectosState createState() => _AvanceproyectosState();
}

class _AvanceproyectosState extends State<Avanceproyectos> {
  final apiurl1 = Uri.parse(
    'https://asamexico.com.mx/php/controller/avancesumproyectos.php',
  );

  String _mensaje = "";

  Future<String> recibirString() async {
    var data = {'idp': widget.idHolder, 'ids': widget.id};
    final respuesta = await http.post(apiurl1, body: json.encode(data));
    if (respuesta.statusCode == 200) {
      //log(respuesta.body.toString());
      setState(() {
        _mensaje = respuesta.body.toString();
      });
    } else {
      throw Exception("Fallo");
    }
  }

  @override
  void initState() {
    super.initState();
    recibirString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.referencia),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Title(
                color: Color.fromRGBO(35, 56, 120, 1.0),
                child: Text('Avances por dia'),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Title(
                    color: Color.fromRGBO(35, 56, 120, 1.0),
                    child: Text(
                      widget.cantidad,
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold), // italic
                    ),
                  ),
                  Text(' / '),
                  Title(
                    color: Color.fromRGBO(35, 56, 120, 1.0),
                    child: Text(
                      _mensaje,
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold), // italic
                    ),
                  )
                ],
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 50,
                    ),
                    Expanded(
                        child: ListTile(
                      title: TextField(
                        controller: _cantidad,
                        keyboardType: TextInputType.number,
                      ),
                      subtitle: Text('Cantidad por dia'),
                    )),
                    SizedBox(
                      width: 50,
                    ),
                    IconButton(
                        icon: Icon(Icons.add_circle,
                            color: Colors.redAccent, size: 40),
                        onPressed: () {
                          guardar(_cantidad.text.toString(), _comentarios.text,
                              widget.idHolder.toString(), widget.id.toString());
                        }),
                  ],
                ),
              ),
              Container(
                child: Expanded(
                    child: ListTile(
                  title: TextField(
                    controller: _comentarios,
                  ),
                  subtitle: Text('Comentarios'),
                )),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                  flex: 5,
                  child: Container(
                      child: Avances(
                          widget.idHolder.toString(), widget.id.toString())))
            ],
          ),
        ));
  }

  void guardar(cantidad, comentarios, idholder, id) async {
    print('');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String usuario = prefs.getString('nuser');

    var resi = await http.post(
        Uri.parse(
            "https://asamexico.com.mx/php/controller/altaavancesistemas.php"),
        body: {
          'idproyecto': idholder,
          'idsistema': id,
          'usuario': usuario,
          'cantidad': cantidad,
          'comentario': comentarios
        }); //sending post request with header data

    if (resi.statusCode == 200) {
      print(resi.body); //print raw response on console
      var data = json.decode(resi.body); //decoding json to array
      if (data["error"]) {
        setState(() {
          //refresh the UI when error is recieved from server
          sending = false;
          error = true;
          msg = data["message"]; //error message from server
          estado = "Error al guardar";
        });
      } else {
        estado = "Se guardado";
        print("$estado");
        _comentarios.clear();
        _cantidad.clear();
        setState(() {
          sending = false;
          success = true;
          recibirString();
        });
      }
    } else {
      //there is error
      setState(() {
        error = true;
        msg = "Error during sendign data.";
        sending = false;
      });
    }
  }
}

class Avances extends StatelessWidget {
  final String idHolder;
  final String id;

  const Avances(this.idHolder, this.id);

  Future<List<Avancesistemas>> jsonsistemasavances() async {
    print(idHolder);
    print(id);
    var data = {'idp': idHolder, 'ids': id};
    var response = await http.post(
        Uri.parse(
            'https://asamexico.com.mx/php/controller/avancesproyecto.php'),
        body: json.encode(data));
    print(response);
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      print(items);
      List<Avancesistemas> sistemasList = items.map<Avancesistemas>((json) {
        return Avancesistemas.fromJson(json);
      }).toList();

      return sistemasList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    jsonsistemasavances();
    return FutureBuilder<List<Avancesistemas>>(
        future: jsonsistemasavances(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return ListView(
              children: snapshot.data
                  .map((data) => Container(
                          child: Card(
                        child: ListTile(
                          title: Text(
                            data.comentarios,
                          ),
                          subtitle: Text('Usuario:  ' + data.usuarioReg),
                          trailing: Text(data.fecha.toString(),
                              style: (TextStyle(
                                  fontSize: 25,
                                  color: Color.fromRGBO(35, 56, 120, 1.0)))),
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                data.cantidad.toString(),
                                style: (TextStyle(
                                    fontSize: 30,
                                    color: Color.fromRGBO(35, 56, 120, 1.0))),
                              ),
                              Text("Cantidad",
                                  style: (TextStyle(
                                    fontSize: 10,
                                  )))
                            ],
                          ),
                        ),
                      )))
                  .toList());
        });
  }
}
