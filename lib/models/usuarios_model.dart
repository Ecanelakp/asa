class usuariosmodel {
  String? id;
  String? email;
  String? nombre;
  String? fechaAlta;
  String? status;
  String? perfil;

  usuariosmodel(
      {this.id,
      this.email,
      this.nombre,
      this.fechaAlta,
      this.status,
      this.perfil});

  usuariosmodel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    nombre = json['nombre'];
    fechaAlta = json['fecha_alta'];
    status = json['status'];
    perfil = json['Perfil'];
  }
}

class modelchecadorlista {
  String? id;
  String? idUsuario;
  String? nombre;
  DateTime? entrada;
  DateTime? salida;
  String? referencia;
  String? latitud;
  String? longitud;

  modelchecadorlista({
    required this.id,
    required this.idUsuario,
    this.nombre,
    this.entrada,
    this.salida,
    this.referencia,
    this.latitud,
    this.longitud,
  });

  modelchecadorlista.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idUsuario = json['id_Usuario'];
    nombre = json['nombre'];
    entrada = DateTime.parse(json['entrada']);
    salida = DateTime.parse(json['salida']);
    referencia = json['referencia'];
    latitud = json[' latitud'];
    longitud = json['longitud'];
  }
}
