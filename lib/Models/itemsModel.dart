
// To parse this JSON data, do
//
//     final users = usersFromMap(jsonString);

import 'dart:async';

import 'package:meta/meta.dart';
import 'dart:convert';

class Items {
  Items({
    required this.itemid,
    required this.itemName,
    required this.groupid,
    required this.linkid,
    required this.salesprice,
    required this.costprice,
  });
  int ? itemid;
  String? itemName;
  int ?groupid;
  String? linkid;
  double ? salesprice;
  double ? costprice;
  factory Items.fromJson(Map<String, dynamic> json) => Items(
    itemid: json["itemid"],
    itemName: json["itemName"],
    groupid: json["groupid"],
    linkid: json["linkid"],
    salesprice: json["salesprice"],
    costprice: json["costprice"],
  );

  Map<String, dynamic> toJson() => {
    "itemId": itemid,
    "itemName": itemName,
    "groupId": groupid,
    "linkId": linkid,
    "salesPrice": salesprice,
    "costprice": costprice,
  };
}
