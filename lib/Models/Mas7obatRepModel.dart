
// To parse this JSON data, do
//
//     final mas7ObatRep = mas7ObatRepFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class Mas7obatRepM {
  Mas7obatRepM({
    required this.orgId,
    required this.mandoub1,
    required this.mandoob1,
    required this.name,
    required this.quantityTake,
    required this.quantityAdd,
    required this.total2,
    required this.total,
  });

  String orgId;
  String mandoub1;
  String mandoob1;
  String name;
  String quantityTake;
  String quantityAdd;
  String total2;
  String total;

  factory Mas7obatRepM.fromJson(String str) => Mas7obatRepM.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Mas7obatRepM.fromMap(Map<String, dynamic> json) => Mas7obatRepM(
    orgId: json["orgId"],
    mandoub1: json["mandoub1"],
    mandoob1: json["mandoob1"],
    name: json["name"],
    quantityTake: json["quantityTake"],
    quantityAdd: json["quantityAdd"],
    total2: json["total2"],
    total: json["total"],
  );

  Map<String, dynamic> toMap() => {
    "orgId": orgId,
    "mandoub1": mandoub1,
    "mandoob1": mandoob1,
    "name": name,
    "quantityTake": quantityTake,
    "quantityAdd": quantityAdd,
    "total2": total2,
    "total": total,
  };
}
