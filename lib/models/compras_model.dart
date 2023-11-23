class Modellisproveedores {
  String id;
  String nombre;
  String rfc;
  String correo;
  String telefono;
  String status;

  Modellisproveedores({
    required this.id,
    required this.nombre,
    required this.rfc,
    required this.correo,
    required this.telefono,
    required this.status,
  });

  factory Modellisproveedores.fromJson(Map<String, dynamic> json) =>
      Modellisproveedores(
        id: json["id"],
        nombre: json["nombre"],
        rfc: json["rfc"],
        correo: json["correo"],
        telefono: json["telefono"],
        status: json["status"],
      );
}

class Modellisordenes {
  String id;
  String idProveedor;
  DateTime fechaRequerida;
  String comentarios;
  String referencia;
  String condicionesPago;
  String usuario;
  DateTime fecha;
  String iva;
  String status;
  String? nombre;
  String total;

  Modellisordenes({
    required this.id,
    required this.idProveedor,
    required this.fechaRequerida,
    required this.comentarios,
    required this.referencia,
    required this.condicionesPago,
    required this.usuario,
    required this.fecha,
    required this.iva,
    required this.status,
    this.nombre,
    required this.total,
  });

  factory Modellisordenes.fromJson(Map<String, dynamic> json) =>
      Modellisordenes(
        id: json["id"],
        idProveedor: json["id_proveedor"],
        fechaRequerida: DateTime.parse(json["fecha_requerida"]),
        comentarios: json["comentarios"],
        referencia: json["referencia"],
        condicionesPago: json["condiciones_pago"],
        usuario: json["usuario"],
        fecha: DateTime.parse(json["fecha"]),
        iva: json["iva"],
        status: json["status"],
        nombre: json["nombre"],
        total: json["total"],
      );
}

class Modellisordeneslineas {
  String id;
  String idCompra;
  String cantidad;
  String descripcion;
  String pu;
  String status;

  Modellisordeneslineas({
    required this.id,
    required this.idCompra,
    required this.cantidad,
    required this.descripcion,
    required this.pu,
    required this.status,
  });

  factory Modellisordeneslineas.fromJson(Map<String, dynamic> json) =>
      Modellisordeneslineas(
        id: json["id"],
        idCompra: json["id_compra"],
        cantidad: json["cantidad"],
        descripcion: json["descripcion"],
        pu: json["pu"],
        status: json["status"],
      );
}
