

// To parse this JSON data, do
//
//     final cashInDetM = cashInDetMFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class CashInDetM {
  CashInDetM({
    required this.transId,
    required this.transAccount,
    required this.transText,
    required this.transValue,
    required this.transCostCenter,
    required this.transPaperId,
    required this.operationId,
    required this.fileId,
    required this.userId,
    required this.invoiceId,
    required this.costControlId,
    required this.blockId,
    required this.cheqNumber,
    required this.installmentNumber,
    required this.costTime,
  });

  int transId;
  int transAccount;
  String transText;
  int transValue;
  int transCostCenter;
  String transPaperId;
  int operationId;
  int fileId;
  int userId;
  int invoiceId;
  int costControlId;
  int blockId;
  String cheqNumber;
  int installmentNumber;
  String costTime;



  factory CashInDetM.fromJson(Map<String, dynamic> json) => CashInDetM(
    transId: json["transId"],
    transAccount: json["transAccount"],
    transText: json["transText"],
    transValue: json["transValue"],
    transCostCenter: json["transCostCenter"],
    transPaperId: json["transPaperId"],
    operationId: json["operationId"],
    fileId: json["fileId"],
    userId: json["userId"],
    invoiceId: json["invoiceId"],
    costControlId: json["costControlId"],
    blockId: json["blockId"],
    cheqNumber: json["cheqNumber"],
    installmentNumber: json["installmentNumber"],
    costTime: json["costTime"],
  );

  Map<String, dynamic> toJson() => {
    "transId": transId,
    "transAccount": transAccount,
    "transText": transText,
    "transValue": transValue,
    "transCostCenter": transCostCenter,
    "transPaperId": transPaperId,
    "operationId": operationId,
    "fileId": fileId,
    "userId": userId,
    "invoiceId": invoiceId,
    "costControlId": costControlId,
    "blockId": blockId,
    "cheqNumber": cheqNumber,
    "installmentNumber": installmentNumber,
    "costTime": costTime,
  };
}
