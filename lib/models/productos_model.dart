class Modellistaproductos {
  String id;
  String tipo;
  String nombre;
  String descripcion;
  String presentacion;
  String unidad;
  String inventario;
  DateTime fechaModificacion;
  String usuarioModificacion;
  String status;

  Modellistaproductos({
    required this.id,
    required this.tipo,
    required this.nombre,
    required this.descripcion,
    required this.presentacion,
    required this.unidad,
    required this.inventario,
    required this.fechaModificacion,
    required this.usuarioModificacion,
    required this.status,
  });

  factory Modellistaproductos.fromJson(Map<String, dynamic> json) =>
      Modellistaproductos(
        id: json["id"],
        tipo: json["tipo"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        presentacion: json["presentacion"],
        unidad: json["unidad"],
        inventario: json["inventario"],
        fechaModificacion: DateTime.parse(json["fecha_modificacion"]),
        usuarioModificacion: json["usuario_modificacion"],
        status: json["status"],
      );
}

class Modellistaprodmov {
  String id;
  String tipoMovimiento;
  String idProducto;
  String producto;
  String cantidad;
  DateTime fecha;
  String usuarioAlta;
  String usuarioAsignado;
  String proyecto;

  Modellistaprodmov({
    required this.id,
    required this.tipoMovimiento,
    required this.idProducto,
    required this.producto,
    required this.cantidad,
    required this.fecha,
    required this.usuarioAlta,
    required this.usuarioAsignado,
    required this.proyecto,
  });

  factory Modellistaprodmov.fromJson(Map<String, dynamic> json) =>
      Modellistaprodmov(
        id: json["id"],
        tipoMovimiento: json["tipo_movimiento"],
        idProducto: json["id_producto"],
        producto: json["producto"],
        cantidad: json["cantidad"],
        fecha: DateTime.parse(json["fecha"]),
        usuarioAlta: json["usuario_alta"],
        usuarioAsignado: json["usuario_asignado"],
        proyecto: json["proyecto"],
      );
}
