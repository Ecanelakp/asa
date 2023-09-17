class Modelcatregimen {
  String cve;
  String descripcion;

  Modelcatregimen({
    required this.cve,
    required this.descripcion,
  });

  factory Modelcatregimen.fromJson(Map<String, dynamic> json) =>
      Modelcatregimen(
        cve: json["cve"],
        descripcion: json["descripcion"],
      );
}

class Modelcatuso {
  String cve;
  String descripcion;
  //String id;

  Modelcatuso({
    required this.cve,
    required this.descripcion,
    //required this.id,
  });

  factory Modelcatuso.fromJson(Map<String, dynamic> json) => Modelcatuso(
        cve: json["cve"],
        descripcion: json["descripcion"],
      );
}
