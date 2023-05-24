
// To parse this JSON data, do
//
//     final users = usersFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class Users {
    Users({
        required this.id,
        required this.lastName,
        required this.firstName,
        required this.city,
        required this.role,
        required this.mac,
    });

    int id;
    String lastName;
    String firstName;
    String city;
    String role;
    int mac;
    factory Users.fromJson(Map<String, dynamic> json) => Users(
        id: json["Id"],
        lastName: json["LastName"],
        firstName: json["FirstName"],
        city: json["City"],
        role: json["Role"],
        mac: json["mac"],
    );

    Map<String, dynamic> toJson() => {
        "Id": id,
        "LastName": lastName,
        "FirstName": firstName,
        "City": city,
        "Role": role,
        "mac": mac,
    };
}
