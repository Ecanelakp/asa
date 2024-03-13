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