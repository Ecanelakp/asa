class User {
  String? nombre;
  String? descripcion;
  String? unidad;
  String? tipo;
  double? cantidad;
  int? idproducto;

  User(
      {this.nombre,
      this.descripcion,
      this.unidad,
      this.tipo,
      this.cantidad,
      this.idproducto});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        nombre: json['Nombre'],
        descripcion: json['Descripcion'],
        unidad: json['Unidad'],
        tipo: json['Tipo'],
        cantidad: json['CANTIDAD'].toDouble(),
        idproducto: json['id']);
  }
}
