class Modellistaclientes {
  String id;
  String rfcUsuario;
  String idUsuario;
  String rfc;
  String razonSocial;
  String razonRegimen;
  String usoCfdi;
  String regimen;
  String domicilio;
  String cp;
  String telefono;
  String nombreContacto;
  String email;
  DateTime fechaAlta;
  String activo;

  Modellistaclientes({
    required this.id,
    required this.rfcUsuario,
    required this.idUsuario,
    required this.rfc,
    required this.razonSocial,
    required this.razonRegimen,
    required this.usoCfdi,
    required this.regimen,
    required this.domicilio,
    required this.cp,
    required this.telefono,
    required this.nombreContacto,
    required this.email,
    required this.fechaAlta,
    required this.activo,
  });

  factory Modellistaclientes.fromJson(Map<String, dynamic> json) =>
      Modellistaclientes(
        id: json["id"],
        rfcUsuario: json["rfc_usuario"],
        idUsuario: json["id_usuario"],
        rfc: json["rfc"],
        razonSocial: json["razon_social"],
        razonRegimen: json["razon_regimen"],
        usoCfdi: json["uso_cfdi"],
        regimen: json["regimen"],
        domicilio: json["domicilio"],
        cp: json["cp"],
        telefono: json["telefono"],
        nombreContacto: json["nombre_contacto"],
        email: json["email"],
        fechaAlta: DateTime.parse(json["fecha_alta"]),
        activo: json["activo"],
      );
}
