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

class Modellistcontactos {
  String id;
  String idCliente;
  String nombre;
  String telefono;
  String ubicacion;
  String correo;
  String puesto;
  String status;

  Modellistcontactos({
    required this.id,
    required this.idCliente,
    required this.nombre,
    required this.telefono,
    required this.ubicacion,
    required this.correo,
    required this.puesto,
    required this.status,
  });

  factory Modellistcontactos.fromJson(Map<String, dynamic> json) =>
      Modellistcontactos(
        id: json["id"],
        idCliente: json["id_cliente"],
        nombre: json["nombre"],
        telefono: json["telefono"],
        ubicacion: json["ubicacion"],
        correo: json["correo"],
        puesto: json["puesto"],
        status: json["status"],
      );
}

class Modellistinteracciones {
  String id;
  String idCliente;
  String idContacto;
  String titulo;
  String descripcion;
  DateTime fecha;
  String fechaRecordatorio;
  String usuario;
  String status;

  Modellistinteracciones({
    required this.id,
    required this.idCliente,
    required this.idContacto,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.fechaRecordatorio,
    required this.usuario,
    required this.status,
  });

  factory Modellistinteracciones.fromJson(Map<String, dynamic> json) =>
      Modellistinteracciones(
        id: json["id"],
        idCliente: json["id_cliente"],
        idContacto: json["id_contacto"],
        titulo: json["titulo"],
        descripcion: json["descripcion"],
        fecha: DateTime.parse(json["fecha"]),
        fechaRecordatorio: json["fecha_recordatorio"],
        usuario: json["usuario"],
        status: json["status"],
      );
}
