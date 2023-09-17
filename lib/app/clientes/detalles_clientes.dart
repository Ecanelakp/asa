import 'package:asamexico/app/variables/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class detalles_clientes extends StatelessWidget {
  final String _razonSocial;
  final String _rfc;
  final String _domicilio;
  final String _cp;
  final String _usoCfdi;
  final String _regimen;
  final String _telefono;
  final String _email;
  final String _nombreContacto;

  detalles_clientes(
      this._razonSocial,
      this._rfc,
      this._domicilio,
      this._cp,
      this._usoCfdi,
      this._regimen,
      this._telefono,
      this._email,
      this._nombreContacto);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles',
            style: GoogleFonts.itim(textStyle: TextStyle(color: blanco))),
        backgroundColor: azulp,
      ),
      backgroundColor: blanco,
      body: Container(
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Datos',
                  style: GoogleFonts.itim(textStyle: TextStyle(color: gris))),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CircleAvatar(
                            backgroundColor: azulp,
                            child: Icon(
                              Icons.home_work,
                              color: blanco,
                            ),
                          ),
                        ),
                        _datos(_razonSocial, 'Nombre o razon social'),
                        _datos(_rfc, 'RFC'),
                        _datos(_domicilio, 'Domicilio'),
                        _datos(_cp, 'Codigo postal'),
                        _datos(_telefono, 'Telefono'),
                        _datos(_email, 'Email'),
                        _datos(_nombreContacto, 'Contacto'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListTile _datos(String _dato, String _label) {
    return ListTile(
      title: Text(_dato,
          style: GoogleFonts.itim(textStyle: TextStyle(color: azulp))),
      subtitle: Text(_label,
          style: GoogleFonts.itim(textStyle: TextStyle(color: gris))),
    );
  }
}
