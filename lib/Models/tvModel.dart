

// To parse this JSON data, do
//
//     final tv = tvFromMap(jsonString);

import 'dart:convert';

class Tv {
  Tv({
    required this.index,
    required this.relative,
    required this.relation,
    required this.key,
    required this.text,
    required this.tag,
    required this.acclevel,
    required this.isclose,
    required this.aa,
    required this.maden,
    required this.daaen,
    required this.tahselem,

  });

  int index;
  String relative;
  String relation;
  String key;
  String text;
  int tag;
  int acclevel;
  bool isclose;
  int aa;
  int maden;
  int daaen;
  int tahselem;

  factory Tv.fromJson(String str) => Tv.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Tv.fromMap(Map<String, dynamic> json) => Tv(
    index: json["index"],
    relative: json["relative"],
    relation: json["relation"],
    key: json["key"],
    text: json["text"],
    tag: json["tag"],
    acclevel: json["acclevel"],
    isclose: json["isclose"],
    aa: json["aa"],
    maden: json["maden"],
    daaen: json["daaen"],
    tahselem: json["tahselem"],
  );

  Map<String, dynamic> toMap() => {
    "index": index,
    "relative": relative,
    "relation": relation,
    "key": key,
    "text": text,
    "tag": tag,
    "acclevel": acclevel,
    "isclose": isclose,
    "aa": aa,
    "maden": maden,
    "daaen": daaen,
    "tahselem": tahselem,

  };
}
