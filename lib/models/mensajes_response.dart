// To parse this JSON data, do
//
//     final mensajesResponse = mensajesResponseFromJson(jsonString);

import 'dart:convert';

MensajesResponse mensajesResponseFromJson(String str) =>
    MensajesResponse.fromJson(json.decode(str));

String mensajesResponseToJson(MensajesResponse data) =>
    json.encode(data.toJson());

class MensajesResponse {
  MensajesResponse({
    this.ok,
    this.mensages,
  });

  bool ok;
  List<Mensage> mensages;

  factory MensajesResponse.fromJson(Map<String, dynamic> json) =>
      MensajesResponse(
        ok: json["ok"],
        mensages: List<Mensage>.from(
            json["mensages"].map((x) => Mensage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "mensages": List<dynamic>.from(mensages.map((x) => x.toJson())),
      };
}

class Mensage {
  Mensage({
    this.de,
    this.para,
    this.mensaje,
    this.createdAt,
    this.updatedAt,
  });

  String de;
  String para;
  String mensaje;
  DateTime createdAt;
  DateTime updatedAt;

  factory Mensage.fromJson(Map<String, dynamic> json) => Mensage(
        de: json["de"],
        para: json["para"],
        mensaje: json["mensaje"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "de": de,
        "para": para,
        "mensaje": mensaje,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
