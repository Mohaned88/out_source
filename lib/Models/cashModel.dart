
class CashInM {
  CashInM({
    required this.transId,
    required this.transDate,
    required this.transPaper,
    required this.transSafeId,
    required this.approve,
    required this.userId,
    required this.sended,
    required this.posId,
    required this.sarfPrice,
    required this.employeeId,
    required this.tenderId,
    required this.shiftId,
    required this.sendedonline,
    required this.recivedonline,
    required this.invoicenum,
  });

  int transId;
  String? transDate;
  String transPaper;
  int transSafeId;
  int approve;
  int userId;
  int sended;
  int posId;
  int sarfPrice;
  int employeeId;
  int tenderId;
  int shiftId;
  String sendedonline;
  String recivedonline;
  String invoicenum;



  factory CashInM.fromJson(Map<String, dynamic> json) => CashInM(
    transId: json["transId"],
    transDate: json["transDate"],
    transPaper: json["transPaper"],
    transSafeId: json["transSafeId"],
    approve: json["approve"],
    userId: json["userId"],
    sended: json["sended"],
    posId: json["posId"],
    sarfPrice: json["sarfPrice"],
    employeeId: json["employeeId"],
    tenderId: json["tenderId"],
    shiftId: json["shiftId"],
    sendedonline: json["sendedonline"],
    recivedonline: json["recivedonline"],
    invoicenum: json["invoicenum"],
  );

  Map<String, dynamic> toJson() => {
    "transId": transId,
    "transDate": transDate,
    "transPaper": transPaper,
    "transSafeId": transSafeId,
    "approve": approve,
    "userId": userId,
    "sended": sended,
    "posId": posId,
    "sarfPrice": sarfPrice,
    "employeeId": employeeId,
    "tenderId": tenderId,
    "shiftId": shiftId,
    "sendedonline": sendedonline,
    "recivedonline": recivedonline,
    "invoicenum": invoicenum,
  };
}
