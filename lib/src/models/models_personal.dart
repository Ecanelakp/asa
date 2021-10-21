class Personallist {
  String username;
  String nombrecorto;
  String acceso;
  String puesto;
  String fullname;
  String tipo;
  double latitude;
  double longitude;
  DateTime fechareg;

  Personallist({
    this.username,
    this.nombrecorto,
    this.acceso,
    this.puesto,
    this.fullname,
    this.tipo,
    this.latitude,
    this.longitude,
    this.fechareg,
  });

  factory Personallist.fromJson(Map<String, dynamic> json) {
    return Personallist(
        username: json['username'],
        nombrecorto: json['nombrecorto'],
        acceso: json['acceso'],
        puesto: json['Puesto'],
        fullname: json['fullname'],
        tipo: json['tipo'],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        fechareg: DateTime.parse(json["fechareg"]));
  }
}

class PersonallistP {
  PersonallistP({
    this.username,
    this.nombrecorto,
    this.acceso,
    this.puesto,
    this.fullname,
  });

  String username;
  String nombrecorto;
  String acceso;
  String puesto;
  String fullname;

  factory PersonallistP.fromJson(Map<String, dynamic> json) => PersonallistP(
        username: json["username"],
        nombrecorto: json["nombrecorto"],
        acceso: json["acceso"],
        puesto: json["Puesto"],
        fullname: json["fullname"],
      );
}

class Locationpersonal {
  Locationpersonal({
    this.id,
    this.user,
    this.nombre,
    this.fechaReg,
    this.tipo,
    this.url,
    this.dia,
    this.mes,
    this.hora,
    this.latitude,
    this.longitude,
  });

  int id;
  String user;
  String nombre;
  DateTime fechaReg;
  String tipo;
  String url;
  int dia;
  int mes;
  String hora;
  double latitude;
  double longitude;

  factory Locationpersonal.fromJson(Map<String, dynamic> json) =>
      Locationpersonal(
        id: json["id"],
        user: json["user"],
        nombre: json["Nombre"],
        fechaReg: DateTime.parse(json["Fecha_reg"]),
        tipo: json["Tipo"],
        url: json["url"],
        dia: json["dia"],
        mes: json["mes"],
        hora: json["hora"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
      );
}
