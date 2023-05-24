

import 'dart:convert';

class MadoubCustomers {
  MadoubCustomers({
    required this.customerId,
    required this.mandoub,
    required this.customer,
    required this.telephone,
    required this.gpsid,
    required this.address,
    required this.mobile,
    required this.mandoob1,
    required this.initialbalance,
    required this.dfrom,
    required this.dto,
    required this.diff,
    required this.sadad,
    required this.mortagaa,
    required this.discount,
    required this.sales,
    required this.id,
  });

  String customerId;
  String mandoub;
  String customer;
  String telephone;
  String gpsid;
  String address;
  String mobile;
  String mandoob1;
  String initialbalance;
  String dfrom;
  String dto;
  String diff;
  String sadad;
  String mortagaa;
  String discount;
  String sales;
  int id;

  factory MadoubCustomers.fromJson(String str) => MadoubCustomers.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MadoubCustomers.fromMap(Map<String, dynamic> json) => MadoubCustomers(
    customerId: json["customerId"],
    mandoub: json["mandoub"],
    customer: json["customer"],
    telephone: json["telephone"],
    gpsid: json["gpsid"] == null ? null : json["gpsid"],
    address: json["address"],
    mobile: json["mobile"],
    mandoob1: json["mandoob1"],
    initialbalance: json["initialbalance"],
    dfrom: json["dfrom"],
    dto: json["dto"],
    diff: json["diff"],
    sadad: json["sadad"],
    mortagaa: json["mortagaa"],
    discount: json["discount"],
    sales: json["sales"],
    id: json["id"],
  );

  Map<String, dynamic> toMap() => {
    "customerId": customerId,
    "mandoub": mandoub,
    "customer": customer,
    "telephone": telephone,
    "gpsid": gpsid == null ? null : gpsid,
    "address": address,
    "mobile": mobile,
    "mandoob1": mandoob1,
    "initialbalance": initialbalance,
    "dfrom": dfrom,
    "dto": dto,
    "diff": diff,
    "sadad": sadad,
    "mortagaa": mortagaa,
    "discount": discount,
    "sales": sales,
    "id": id,
  };
}
