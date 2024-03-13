import 'package:Asamexico/app/variables/colors.dart';
import 'package:flutter/material.dart';

class detalleusuarios_configuracion extends StatelessWidget {

  final String? _id;
  final String? _email;
  final  String? _nombre;
  final  String? _perfil;
  final String? _status;
  const detalleusuarios_configuracion(this._id, this._email, this._nombre, this._perfil, this._status );

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      backgroundColor: azulp,
      title: Text(_nombre.toString()),),body: Container(child: Column(
     
        children: [
        SizedBox(height: 30,),
          Center(
            child: CircleAvatar(
              
              backgroundColor: azulp,
              child: Icon(Icons.person_4,color: blanco,),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_nombre.toString().toUpperCase()),
          ),
        
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_perfil.toString()),
          ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_email.toString()),
            ),
           Spacer(),
        ],
      ),),);
  }
}