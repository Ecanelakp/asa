class Modellistaproyectos {
  String id;
  String nombre;
  String observaciones;
  DateTime fecha;
  String idCliente;
  String usuario;
  String status;
  String? nombre_cliente;

  Modellistaproyectos(
      {required this.id,
      required this.nombre,
      required this.observaciones,
      required this.fecha,
      required this.idCliente,
      required this.usuario,
      required this.status,
      this.nombre_cliente});

  factory Modellistaproyectos.fromJson(Map<String, dynamic> json) =>
      Modellistaproyectos(
        id: json["id"],
        nombre: json["nombre"],
        observaciones: json["observaciones"],
        fecha: DateTime.parse(json["fecha"]),
        idCliente: json["id_cliente"],
        usuario: json["usuario"],
        status: json["status"],
        nombre_cliente: json["nombre_cliente"],
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

class Modelliscoti {
  String id;
  String idCliente;
  String nombreCliente;
  String? total;
  DateTime fecha;
  String condicionesPago;
  String status;
  String usuario;
  String comentarios;
  String referencia;
  String razonSocial;

  Modelliscoti({
    required this.id,
    required this.idCliente,
    required this.nombreCliente,
    required this.total,
    required this.fecha,
    required this.condicionesPago,
    required this.status,
    required this.usuario,
    required this.comentarios,
    required this.referencia,
    required this.razonSocial,
  });

  factory Modelliscoti.fromJson(Map<String, dynamic> json) => Modelliscoti(
        id: json["id"],
        idCliente: json["id_cliente"],
        nombreCliente: json["nombre_cliente"],
        total: json["total"],
        fecha: DateTime.parse(json["fecha"]),
        condicionesPago: json["condiciones_pago"],
        status: json["status"],
        usuario: json["usuario"],
        comentarios: json["comentarios"],
        referencia: json["referencia"],
        razonSocial: json["razon_social"],
      );
}

class Modellineascoti {
  String id;
  String idVentas;
  String idProducto;
  String descripcion;
  String cantidad;
  String pu;
  String status;

  Modellineascoti({
    required this.id,
    required this.idVentas,
    required this.idProducto,
    required this.descripcion,
    required this.cantidad,
    required this.pu,
    required this.status,
  });

  factory Modellineascoti.fromJson(Map<String, dynamic> json) =>
      Modellineascoti(
        id: json["id"],
        idVentas: json["id_ventas"],
        idProducto: json["id_producto"],
        descripcion: json["descripcion"],
        cantidad: json["cantidad"],
        pu: json["pu"],
        status: json["status"],
      );
}
