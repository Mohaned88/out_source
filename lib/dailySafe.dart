import 'package:intl/intl.dart' as intl;

import 'databasehelper.dart';
import 'package:flutter/material.dart';

class DailySafe extends StatefulWidget {
  DailySafe({Key? key, required this.date}) : super(key: key);
  String? date;

  @override
  State<DailySafe> createState() => _DailySafeState();
}

final conn = SqfliteDatabaseHelper.instance;
bool loading = true;

double totalInvoice = 0;
double totalPaid = 0;
double totalReset = 0;
double totalCash = 0;
double totalWithoutReset = 0;
List<dynamic> list = [];
List<dynamic> listCash = [];

class _DailySafeState extends State<DailySafe> {
  String? time;

  Future<List<dynamic>> billListToDay() async {
    late List<dynamic> ff = [];
    var dbclient = await conn.db;
    print(time);
    List<Map<String, dynamic>> maps = await dbclient.rawQuery(
        'select * from Bill where bill_date = "$time" And approve =1 order by bill_date desc ');
    for (var item in maps) {
      ff.add(item);
    }
    setState(() {
      loading = false;
      list = ff;
      totalInvoice = ff
          .map((ff) => ff["totalInvoice"])
          .fold(0, (prev, totalInvoice) => prev + totalInvoice);
      totalPaid = ff
          .map((ff) => ff["totalPaid"])
          .fold(0, (prev, totalInvoice) => prev + totalInvoice);
      totalReset = ff
          .map((ff) => ff["totalReset"])
          .fold(0, (prev, totalInvoice) => prev + totalInvoice);
      totalWithoutReset = totalInvoice - totalReset;
    });
    print(ff.length);
    print(ff);
    return ff;
  }

  Future<List<dynamic>> CashListToDay() async {
    late List<dynamic> ff = [];
    var dbclient = await conn.db;
    List<Map<String, dynamic>> maps = await dbclient.rawQuery(
        'select CashDet.transAccount,CashDet.transId,CashDet.transValue,CashDet.costTime,Organizations.orgName from CashDet inner join Organizations on CashDet.transAccount=Organizations.org_ID where costTime = "$time" order by  costTime desc ');
    for (var item in maps) {
      ff.add(item);
    }
    setState(() {
      loading = false;
      listCash = ff;
      totalCash = ff
          .map((ff) => ff["transValue"])
          .fold(0, (prev, totalCash) => prev + totalCash);
    });
    print(ff.length);
    print(ff);
    return ff;
  }

  @override
  void initState() {
    time = widget.date;
    billListToDay().then((value) => loading = false);
    CashListToDay().then((value2) => loading = false);
    print("init");
    print(list);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Container(child: Center(child: CircularProgressIndicator()))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.green,
                        child: Column(
                          children: [
                            GestureDetector(
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      list[index]['bill_id'].toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'GE SS Two',
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "رقم الفاتورة",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'GE SS Two',
                                      ),
                                    ),
                                    // Text(list![index]['LastName']),
                                  ],
                                ),
                                subtitle: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          list[index]['totalInvoice']
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'GE SS Two',
                                          ),
                                        ),
                                        Text(
                                          "اجمالي الفاتورة",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'GE SS Two',
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          list[index]['totalPaid'].toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'GE SS Two',
                                          ),
                                        ),
                                        Text(
                                          "اجمالي المدفوع",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'GE SS Two',
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          list[index]['totalReset'].toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'GE SS Two',
                                          ),
                                        ),
                                        Text(
                                          "اجمالي الخصم",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'GE SS Two',
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          list[index]['paymenttype'].toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'GE SS Two',
                                          ),
                                        ),
                                        Text(
                                          "نوع الفاتورة ",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'GE SS Two',
                                          ),
                                        ),
                                        //   Text(list![index]['City']), Text(list![index]['Role'])
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: listCash.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.green,
                        child: Column(
                          children: [
                            GestureDetector(
                              child: ListTile(
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          listCash[index]['transId'].toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'GE SS Two',
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "رقم اذن التحصيل",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'GE SS Two',
                                          ),
                                        ),
                                        // Text(list![index]['LastName']),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          listCash[index]['transAccount']
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'GE SS Two',
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "كود العميل",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'GE SS Two',
                                          ),
                                        ),
                                        // Text(list![index]['LastName']),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          listCash[index]['orgName'].toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'GE SS Two',
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "اسم العميل",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'GE SS Two',
                                          ),
                                        ),
                                        // Text(list![index]['LastName']),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          listCash[index]['transValue']
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'GE SS Two',
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "قيمه التحصيل",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'GE SS Two',
                                          ),
                                        ),
                                        // Text(list![index]['LastName']),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.bottomCenter,
                          colors: [Colors.white, Colors.blue],
                        ),
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            child: ListTile(
                              title: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "$totalInvoice",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'GE SS Two',
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "اجمالي قيمه الفواتير",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'GE SS Two',
                                        ),
                                      ),
                                      // Text(list![index]['LastName']),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "$totalPaid",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'GE SS Two',
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        " اجمالي التحصيلات الفواتير",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'GE SS Two',
                                        ),
                                      ),
                                      // Text(list![index]['LastName']),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "$totalReset",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'GE SS Two',
                                        ),
                                      ),

                                      SizedBox(
                                        width: 5,
                                      ),

                                      Text(
                                        "اجمالي الخصومات",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'GE SS Two',
                                        ),
                                      ),
                                      // Text(list![index]['LastName']),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "$totalWithoutReset",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'GE SS Two',
                                        ),
                                      ),

                                      SizedBox(
                                        width: 5,
                                      ),

                                      Text(
                                        "اجمالي الفواتير بعد الخصم",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'GE SS Two',
                                        ),
                                      ),
                                      // Text(list![index]['LastName']),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "$totalCash",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'GE SS Two',
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "  اجمالي التحصيلات الكاش",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'GE SS Two',
                                        ),
                                      ),
                                      // Text(list![index]['LastName']),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${totalCash + totalPaid}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'GE SS Two',
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "اجمالي النقديه",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'GE SS Two',
                                        ),
                                      ),
                                      // Text(list![index]['LastName']),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
