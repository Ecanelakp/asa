
class Modellistacfdi {
  String id;
  String rfcEmisor;
  String rfcReceptor;
  String uuid;
  String folio;
  String total;
  String status;
  DateTime fecha;
  String nombre_emisor;
  String nombre_receptor;
  String? email;
  String? tipo_doc;
  String? metodo_pago;
  String? documento_ext;
  String? observaciones;

  Modellistacfdi(
      {required this.id,
      required this.rfcEmisor,
      required this.rfcReceptor,
      required this.uuid,
      required this.folio,
      required this.total,
      required this.status,
      required this.fecha,
      required this.nombre_emisor,
      required this.nombre_receptor,
      this.email,
      this.tipo_doc,
      this.metodo_pago,
      this.documento_ext,
      this.observaciones});

  factory Modellistacfdi.fromJson(Map<String, dynamic> json) => Modellistacfdi(
        id: json["id"],
        rfcEmisor: json["rfc_emisor"],
        rfcReceptor: json["rfc_receptor"],
        uuid: json["uuid"],
        folio: json["folio"],
        total: json["total"],
        status: json["status"],
        fecha: DateTime.parse(json["fecha"]),
        nombre_emisor: json["nombre_emisor"],
        nombre_receptor: json["nombre_receptor"],
        email: json["email"],
        tipo_doc: json["tipo_doc"],
        metodo_pago: json["metodo_pago"],
        documento_ext: json["doc_externo"],
        observaciones: json["observaciones"],
      );

}



class Modellistaseries {
  String id;
  String rfcCliente;
  String tipoDocumento;
  String serie;
  String folioInicial;
  DateTime fecha;
  String activo;

  Modellistaseries({
    required this.id,
    required this.rfcCliente,
    required this.tipoDocumento,
    required this.serie,
    required this.folioInicial,
    required this.fecha,
    required this.activo,
  });

  factory Modellistaseries.fromJson(Map<String, dynamic> json) =>
      Modellistaseries(
        id: json["id"],
        rfcCliente: json["rfc_cliente"],
        tipoDocumento: json["tipo_documento"],
        serie: json["serie"],
        folioInicial: json["folio_inicial"],
        fecha: DateTime.parse(json["fecha"]),
        activo: json["activo"],
      );
}
