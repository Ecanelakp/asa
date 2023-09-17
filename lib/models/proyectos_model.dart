class Modellistaproyectos {
  String id;
  String nombre;
  String observaciones;
  DateTime fecha;
  String idCliente;
  String usuario;
  String status;

  Modellistaproyectos({
    required this.id,
    required this.nombre,
    required this.observaciones,
    required this.fecha,
    required this.idCliente,
    required this.usuario,
    required this.status,
  });

  factory Modellistaproyectos.fromJson(Map<String, dynamic> json) =>
      Modellistaproyectos(
        id: json["id"],
        nombre: json["nombre"],
        observaciones: json["observaciones"],
        fecha: DateTime.parse(json["fecha"]),
        idCliente: json["id_cliente"],
        usuario: json["usuario"],
        status: json["status"],
      );
}

class Modellistaproyprods {
  String id;
  String tipoMovimiento;
  String idProducto;
  String producto;
  String cantidad;
  DateTime fecha;
  String usuarioAlta;
  String usuarioAsignado;
  String status;
  String proyecto;
  String cantidad_disponible;

  Modellistaproyprods({
    required this.id,
    required this.tipoMovimiento,
    required this.idProducto,
    required this.producto,
    required this.cantidad,
    required this.fecha,
    required this.usuarioAlta,
    required this.usuarioAsignado,
    required this.status,
    required this.proyecto,
    required this.cantidad_disponible,
  });

  factory Modellistaproyprods.fromJson(Map<String, dynamic> json) =>
      Modellistaproyprods(
        id: json["id"],
        tipoMovimiento: json["tipo_movimiento"],
        idProducto: json["id_producto"],
        producto: json["producto"],
        cantidad: json["cantidad"],
        fecha: DateTime.parse(json["fecha"]),
        usuarioAlta: json["usuario_alta"],
        usuarioAsignado: json["usuario_asignado"],
        status: json["status"],
        proyecto: json["proyecto"],
        cantidad_disponible: json["cantidad_disponible"],
      );
}
