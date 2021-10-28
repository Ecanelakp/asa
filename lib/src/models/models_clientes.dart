import 'dart:convert';

ClientesModel productoModelFromJson(String str) =>
    ClientesModel.fromJson(json.decode(str));

String productoModelToJson(ClientesModel data) => json.encode(data.toJson());

class ClientesModel {
  ClientesModel({
    this.id,
    this.referencia = '',
    this.nombre = '',
    this.contacto = '',
    this.puesto = '',
    this.direccion = '',
    this.ciudad = '',
    this.colonia = '',
    this.estado = '',
    this.cp = '',
    this.rfc = '',
    this.email = '',
  });

  String? id;
  String? referencia;
  String? nombre;
  String? contacto;
  String? puesto;
  String? direccion;
  String? ciudad;
  String? colonia;
  String? estado;
  String? cp;
  String? rfc;
  String? email;

  factory ClientesModel.fromJson(Map<String, dynamic> json) => ClientesModel(
        id: json["id"],
        referencia: json["referencia"],
        nombre: json["nombre"],
        contacto: json["contacto"],
        puesto: json["puesto"],
        direccion: json["direccion"],
        ciudad: json["ciudad"],
        colonia: json["colonia"],
        estado: json["estado"],
        cp: json["cp"],
        rfc: json["rfc"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        //"id": id,
        "referencia": referencia,
        "nombre": nombre,
        "contacto": contacto,
        "puesto": puesto,
        "direccion": direccion,
        "ciudad": ciudad,
        "colonia": colonia,
        "estado": estado,
        "cp": cp,
        "rfc": rfc,
        "email": email,
      };
}
