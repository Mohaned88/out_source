// To parse this JSON data, do
//
//     final login = loginFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class Login1 {
  Login1({
    required this.personId,
    required this.personName,
    required this.profileId,
    required this.personIndex,
    required this.personRespon,
    required this.username,
    required this.password,
    required this.employeeId,
    required this.deleted,
    required this.branchId,
    required this.mandoub,
    required this.mandoubtag,
    required this.hesab,
    required this.doctor,
    required this.pointsaleId,
    required this.chLoginprivacy,
  });

  int personId;
  String personName;
  int profileId;
  int personIndex;
  String personRespon;
  String username;
  String password;
  int employeeId;
  dynamic deleted;
  int branchId;
  bool mandoub;
  int mandoubtag;
  int hesab;
  bool doctor;
  int pointsaleId;
  dynamic chLoginprivacy;

  factory Login1.fromJson(String str) => Login1.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Login1.fromMap(Map<String, dynamic> json) => Login1(
    personId: json["PersonId"],
    personName: json["PersonName"],
    profileId: json["ProfileId"],
    personIndex: json["PersonIndex"],
    personRespon: json["PersonRespon"],
    username: json["Username"],
    password: json["Password"],
    employeeId: json["EmployeeId"],
    deleted: json["Deleted"],
    branchId: json["BranchId"],
    mandoub: json["Mandoub"],
    mandoubtag: json["Mandoubtag"],
    hesab: json["Hesab"],
    doctor: json["Doctor"],
    pointsaleId: json["PointsaleId"],
    chLoginprivacy: json["ChLoginprivacy"],
  );

  Map<String, dynamic> toMap() => {
    "PersonId": personId,
    "PersonName": personName,
    "ProfileId": profileId,
    "PersonIndex": personIndex,
    "PersonRespon": personRespon,
    "Username": username,
    "Password": password,
    "EmployeeId": employeeId,
    "Deleted": deleted,
    "BranchId": branchId,
    "Mandoub": mandoub,
    "Mandoubtag": mandoubtag,
    "Hesab": hesab,
    "Doctor": doctor,
    "PointsaleId": pointsaleId,
    "ChLoginprivacy": chLoginprivacy,
  };
}
