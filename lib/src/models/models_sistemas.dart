class Sistemas {
  Sistemas({
    this.id,
    this.no,
    this.referencia,
    this.descripcion,
    this.sistema,
    this.cc,
    this.precioUnitario,
    this.unidad,
  });

  int id;
  int no;
  String referencia;
  String descripcion;
  String sistema;
  String cc;
  int precioUnitario;
  String unidad;

  factory Sistemas.fromJson(Map<String, dynamic> json) => Sistemas(
        id: json["id"],
        no: json["No"],
        referencia: json["Referencia"],
        descripcion: json["Descripcion"],
        sistema: json["Sistema"],
        cc: json["CC"],
        precioUnitario: json["Precio Unitario"],
        unidad: json["Unidad"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "No": no,
        "Referencia": referencia,
        "Descripcion": descripcion,
        "Sistema": sistema,
        "CC": cc,
        "Precio Unitario": precioUnitario,
        "Unidad": unidad,
      };
}

class Sistemasusadosp {
  Sistemasusadosp({
    this.id,
    this.no,
    this.referencia,
    this.idSistema,
    this.referenciaSistema,
    this.fechaReg,
    this.usuarioalta,
    this.cantidad,
    this.responsable,
    this.fechaInicio,
    this.unidad,
    this.avance,
    this.sumAvance,
  });

  int id;
  int no;
  dynamic referencia;
  int idSistema;
  dynamic referenciaSistema;
  DateTime fechaReg;
  String usuarioalta;
  int cantidad;
  String responsable;
  String fechaInicio;
  String unidad;
  int avance;
  double sumAvance;

  factory Sistemasusadosp.fromJson(Map<String, dynamic> json) =>
      Sistemasusadosp(
        id: json["id"],
        no: json["No"],
        referencia: json["Referencia"],
        idSistema: json["id_sistema"],
        referenciaSistema: json["Referencia_sistema"],
        fechaReg: DateTime.parse(json["Fecha_reg"]),
        usuarioalta: json["Usuarioalta"],
        cantidad: json["Cantidad"],
        responsable: json["Responsable"],
        fechaInicio: json["Fecha_inicio"],
        unidad: json["Unidad"],
        avance: json["Avance"],
        sumAvance: json["sumAvance"].toDouble(),
      );
}

class Avancesistemas {
  Avancesistemas({
    this.id,
    this.idProyecto,
    this.idSistema,
    this.fechaReg,
    this.usuarioReg,
    this.cantidad,
    this.comentarios,
    this.baja,
    this.fecha,
  });

  int id;
  int idProyecto;
  int idSistema;
  DateTime fechaReg;
  String usuarioReg;
  dynamic cantidad;
  String comentarios;
  int baja;
  String fecha;

  factory Avancesistemas.fromJson(Map<String, dynamic> json) => Avancesistemas(
        id: json["id"],
        idProyecto: json["id_proyecto"],
        idSistema: json["id_sistema"],
        fechaReg: DateTime.parse(json["Fecha_reg"]),
        usuarioReg: json["Usuario_reg"],
        cantidad: (json["Cantidad"]),
        comentarios: json["Comentarios"],
        baja: json["Baja"],
        fecha: json["fecha"],
      );
}

class Avancesistemasxd {
  Avancesistemasxd({this.cantidad, this.fecha, this.sistemas});

  dynamic cantidad;

  String fecha;
  String sistemas;

  factory Avancesistemasxd.fromJson(Map<String, dynamic> json) =>
      Avancesistemasxd(
        cantidad: (json["Cantidad"]),
        fecha: json["fecha"],
        sistemas: json["Sistemas"],
      );
}
