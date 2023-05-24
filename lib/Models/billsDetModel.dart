// To parse this JSON data, do
//
//     final billDet = billDetFromMap(jsonString);

import 'dart:convert';

class BillDet {
  BillDet({
     this.transId,
    required this.billId,
    required this.itemId,
    required this.unit1Quant,
    required this.price,
    required this.total,
    required this.finalPrice,
    required this.userId,
    required this.storeId,
    required this.billdate,
  });

  int ?transId;
  double billId;
  double itemId;
  double unit1Quant;
  double price;
  double total;
  double finalPrice;
  int userId;
  int storeId;
  String? billdate;

  factory BillDet.fromJson(Map<String, dynamic> json) => BillDet(
    transId: json["transId"],
    billId: json["billId"],
    itemId: json["itemId"],
    unit1Quant: json["unit1Quant"],
    price: json["price"],
    total: json["total"],
    finalPrice: json["finalPrice"],
    userId: json["userId"],
    storeId: json["storeId"],
    billdate: json["billdate"],
  );

  Map<String, dynamic> toJson() => {
    "transId": transId,
    "billId": billId,
    "itemId": itemId,
    "unit1Quant": unit1Quant,
    "price": price,
    "total": total,
    "finalPrice": finalPrice,
    "userId": userId,
    "storeId": storeId,
    "billdate": billdate,

  };
}
