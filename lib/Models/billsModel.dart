

class Bills {
  Bills({
    this.billId,
    this.billDate,
    this.customerId,
    this.storeId,
    this.mandoob1,
    this.naqd,
    this.approve,
    this.userId,
    this.totalPaied,
    this.totalreset,
    this.totalInvoice,
    this.paymenttype,
    this.safeId,
    this.sharh,
    this.startdate,
    this.enddate,
  });

  int? billId;
  String? billDate;
  int? customerId;
  int? storeId;
  int? employeeId;

  int? mandoob1;

  int? naqd;
  int? approve;
  int? userId;
  double? totalPaied;
  double? totalreset;
  double? totalInvoice;
  String? paymenttype;
  int? safeId;
  String? sharh;
  DateTime? startdate;
  DateTime? enddate;

  factory Bills.fromJson(Map<String, dynamic> json) => Bills(
        billId: json["bill_id"],
        billDate: json["bill_date"],
        customerId: json["customer_id"],
        storeId: json["store_id"],
        mandoob1: json["mandoob_1"],
        naqd: json["naqd"],
        approve: json["approve"],
        userId: json["userId"],
        totalPaied: json["totalPaid"],
        totalreset: json["totalReset"],
        paymenttype: json["paymenttype"],
        safeId: json["safe"],
  );

 Map<String, dynamic> toJson() => {
        "billId": billId,
        "billDate": billDate,
        "customerId": customerId,
        "storeId": storeId,
        "mandoob1": mandoob1,
        "naqd": naqd,
        "approve": approve,
        "userId": userId,
        "totalPaied": totalPaied,
        "totalReset": totalreset,
        "paymenttype": paymenttype,
        "safe": safeId,
        "sharh": sharh,
       "enddate": enddate,
      "startdate":startdate,
    "totalInvoice":totalInvoice
      };
}
