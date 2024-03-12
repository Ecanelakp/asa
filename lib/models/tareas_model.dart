class Modellistusers {
  String id;
  String email;
  String password;
  String nombre;
  DateTime fechaAlta;
  String status;
  String perfil;

  Modellistusers({
    required this.id,
    required this.email,
    required this.password,
    required this.nombre,
    required this.fechaAlta,
    required this.status,
    required this.perfil,
  });

  factory Modellistusers.fromJson(Map<String, dynamic> json) => Modellistusers(
        id: json["id"],
        email: json["email"],
        password: json["password"],
        nombre: json["nombre"],
        fechaAlta: DateTime.parse(json["fecha_alta"]),
        status: json["status"],
        perfil: json["Perfil"],
      );
}

class Modellisttareas {
  String id;
  String titulo;
  DateTime fechaVencimiento;
  String tipo;
  String descripcion;
  String usuario;

  Modellisttareas({
    required this.id,
    required this.titulo,
    required this.fechaVencimiento,
    required this.tipo,
    required this.descripcion,
    required this.usuario,
  });

  factory Modellisttareas.fromJson(Map<String, dynamic> json) =>
      Modellisttareas(
          id: json["id"],
          titulo: json["titulo"],
          fechaVencimiento: DateTime.parse(json["fecha_vencimiento"]),
          tipo: json["tipo"],
          descripcion: json["descripcion"],
          usuario: json["usuario"]);
}

class Modellisttareasusaasig {
  String id;
  String idTarea;
  String usuario;
  DateTime fechaTerm;
  String status;
  String fecha;

  Modellisttareasusaasig({
    required this.id,
    required this.idTarea,
    required this.usuario,
    required this.fechaTerm,
    required this.status,
    required this.fecha,
  });

  factory Modellisttareasusaasig.fromJson(Map<String, dynamic> json) =>
      Modellisttareasusaasig(
        id: json["id"],
        idTarea: json["id_tarea"],
        usuario: json["usuario"],
        fechaTerm: DateTime.parse(json["fecha_term"]),
        status: json["status"],
        fecha: json["fecha"],
      );
}

class Modellisttareacomentarios {
  String id;
  String idSegTareas;
  String usuario;
  String comentario;
  DateTime fecha;
  String status;

  Modellisttareacomentarios({
    required this.id,
    required this.idSegTareas,
    required this.usuario,
    required this.comentario,
    required this.fecha,
    required this.status,
  });

  factory Modellisttareacomentarios.fromJson(Map<String, dynamic> json) =>
      Modellisttareacomentarios(
        id: json["id"],
        idSegTareas: json["id_seg_tareas"],
        usuario: json["usuario"],
        comentario: json["comentario"],
        fecha: DateTime.parse(json["fecha"]),
        status: json["status"],
      );
}

class Modellistnotificaciones {
  String id;
  String usuario;
  String asunto;
  String descripcion;
  DateTime fecha;
  String leido;
  String status;

  Modellistnotificaciones({
    required this.id,
    required this.usuario,
    required this.asunto,
    required this.descripcion,
    required this.fecha,
    required this.leido,
    required this.status,
  });

  factory Modellistnotificaciones.fromJson(Map<String, dynamic> json) =>
      Modellistnotificaciones(
        id: json["id"],
        usuario: json["usuario"],
        asunto: json["asunto"],
        descripcion: json["descripcion"],
        fecha: DateTime.parse(json["fecha"]),
        leido: json["leido"],
        status: json["status"],
      );
}
