import 'dart:convert';

import 'package:dy_app/cashDetails.dart';
import 'package:dy_app/printer.dart';
import 'package:dy_app/syncronize.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'billShowsDetails.dart';
import 'databasehelper.dart';

class BillShows extends StatefulWidget {
  const BillShows({Key? key}) : super(key: key);

  @override
  State<BillShows> createState() => _BillShowsState();
}

class _BillShowsState extends State<BillShows> {
  final conn = SqfliteDatabaseHelper.instance;
  List? list;

  TextEditingController billNum = TextEditingController();
  bool loading = true;
  bool onn = false;

  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: 7));
  }

  DateTime findLastDateOfTheMonth(DateTime dateTime) {
    return dateTime.subtract(Duration(days: 30));
  }

  Future billList() async {
    late List ff = [];
    var dbclient = await conn.db;
    List<Map<String, dynamic>> maps = await dbclient.rawQuery(
        'select *,Organizations.orgName from Bill  INNER Join Organizations ON Bill.customer_id = Organizations.org_ID  order by bill_id asc');
    for (var item in maps) {
      ff.add(item);
    }
    print("dfcsdfsdf");
    setState(() {
      loading = false;
      onn = false;
    });
    print(ff.length);
    print(ff);
    return ff;
  }

  Future billListNum() async {
    late List ff = [];
    var dbclient = await conn.db;
    List<Map<String, dynamic>> maps = await dbclient.rawQuery(
        'select *,Organizations.orgName from Bill  INNER Join Organizations ON Bill.customer_id = Organizations.org_ID where bill_id = ${billNum.text}  order by bill_date desc ');
    for (var item in maps) {
      ff.add(item);
    }
    print("Num");
    setState(() {
      loading = false;
      onn = false;
    });
    print(ff);
    return ff;
  }

  String? getDate1;

  Future billListDay() async {
    late List ff = [];
    var dbclient = await conn.db;
    DateTime now = DateTime.now();
    final intl.DateFormat formatter = intl.DateFormat('yyyy-MM-dd');
    final String time = formatter.format(now);
    print(time);
    List<Map<String, dynamic>> maps = await dbclient.rawQuery(
        'select *,Organizations.orgName from Bill  INNER Join Organizations ON Bill.customer_id = Organizations.org_ID where bill_date = "$getDate1" order by bill_date desc ');
    for (var item in maps) {
      ff.add(item);
    }
    print("dfcsdfsdf");
    setState(() {
      loading = false;
      onn = false;
    });
    print(ff.length);
    print(ff);
    return ff;
  }

  Future<String?> pickdate() async {
    DateTime? time = await showDatePicker(
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2050),
        context: context);
    print(time);
    date2 = time.toString().substring(0, 10);
    return date2;
  }

  Future billListToDay() async {
    late List ff = [];
    var dbclient = await conn.db;
    DateTime now = DateTime.now();
    final intl.DateFormat formatter = intl.DateFormat('yyyy-MM-dd');
    final String time = formatter.format(now);
    print(time);
    List<Map<String, dynamic>> maps = await dbclient.rawQuery(
        'select *,Organizations.orgName from Bill  INNER Join Organizations ON Bill.customer_id = Organizations.org_ID where bill_date = "$time" order by bill_date desc ');
    for (var item in maps) {
      ff.add(item);
    }
    print("dfcsdfsdf");
    setState(() {
      loading = false;
      onn = false;
    });
    print(ff.length);
    print(ff);
    return ff;
  }

  Future billListToWeek() async {
    late List ff = [];
    var dbclient = await conn.db;
    DateTime now = DateTime.now();
    final intl.DateFormat formatter = intl.DateFormat('yyyy-MM-dd');
    final String time = formatter.format(now);
    final String time2 = formatter.format(findLastDateOfTheWeek(now));
    print(time);
    print(time2);
    List<Map<String, dynamic>> maps = await dbclient.rawQuery(
        'select *,Organizations.orgName from Bill  INNER Join Organizations ON Bill.customer_id = Organizations.org_ID where bill_date Between "$time2" AND "$time"  order by bill_date desc ');
    for (var item in maps) {
      ff.add(item);
    }
    print("dfcsdfsdf");
    setState(() {
      loading = false;
      onn = false;
    });
    print(ff.length);
    return ff;
  }

  Future billListToMonth() async {
    late List ff = [];
    var dbclient = await conn.db;
    DateTime now = DateTime.now();
    final intl.DateFormat formatter = intl.DateFormat('yyyy-MM-dd');
    final String time = formatter.format(now);
    final String time2 = formatter.format(findLastDateOfTheMonth(now));
    print(time);
    print(time2);
    List<Map<String, dynamic>> maps = await dbclient.rawQuery(
        'select *,Organizations.orgName from Bill  INNER Join Organizations ON Bill.customer_id = Organizations.org_ID where bill_date Between "$time2" AND "$time"  order by bill_date desc');
    for (var item in maps) {
      ff.add(item);
    }
    print("dfcsdfsdf");
    setState(() {
      loading = false;
      onn = false;
    });
    print(ff.length);
    return ff;
  }

  List? datax;
  double? tag;

  Future getManData(String ID, String Date) async {
    final String url = "http://sales.dynamicsdb2.com/api/SummaryDateOnline";
    final prefs = await SharedPreferences.getInstance();

    int? tagx;
    tag = prefs.getDouble("tag");
    tagx = tag?.toInt();
    var response = await http.post(
      body: jsonEncode({"id": "$ID", "date": "$Date"}),
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json;charset=UTF-8",
        "accept": "text/plain"
      },
    );
    if (response.statusCode == 200) {
      //   print("Saving Data ");
      //   print(response.body);
    } else {
      print(response.statusCode);
    }

    // List jsonResponse = jsonDecode(response.body);

    print("get Mandooooob");
    //  print(jsonResponse);

    setState(() {
      //   data = jsonResponse;
      // datax= List<Map<String, dynamic>>.from(jsonDecode(response.body));
      print("dddddd");
      onn = true;
      loading = false;
      print(json.decode(json.encode(response.body)));
      print(onn);
    });

    datax = List<Map<String, dynamic>>.from(jsonDecode(response.body));

    //datax =json.decode(json.encode(response.body));

    final totalbills = datax!.fold<double>(0,
            (previous, current) => previous + current["bill_total"] ?? 0.0) ??
        0;
    final totalitems = datax!.fold<double>(
            0, (previous, current) => previous + current["num"] ?? 0.0) ??
        0;
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  }

  int totalitems = 1;
  double totalbills = 0.0;

  @override
  void initState() {
    final DateTime now = DateTime.now();
    final intl.DateFormat formatter = intl.DateFormat('yyyy-MM-dd');
    final String time = formatter.format(now);
    getDate1 = time.toString();

    //  billList().then((value) => setState(value = list));
    //  billList().then((value) => setState(value = list));
    // super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.cyanAccent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      SyncronizationData().fetchAllBills();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * .1,
                      height: MediaQuery.of(context).size.height * .1,
                      child: Image.asset("assets/images/bb.png"),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    child: Text(
                      "استعراض الفواتير",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GE SS Two',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: () {
                      billList().then((value) => list = value);
                      print(value);
                    },
                    child: Text(" كل الفواتير ")),
                ElevatedButton(
                    onPressed: () {
                      billListToDay().then((value) {
                        return list = value;
                      });
                    },
                    child: Text("فواتير اليوم")),
                ElevatedButton(
                    onPressed: () {
                      billListToWeek().then((value) => list = value);
                    },
                    child: Text("فواتير الاسبوع")),
                ElevatedButton(
                    onPressed: () {
                      billListToMonth().then((value) => list = value);
                    },
                    child: Text("فواتير الشهر")),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 20,
                width: MediaQuery.of(context).size.width * .4,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: ' رقم الفاتورة'),
                  controller: billNum,
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    billListNum().then((value) => list = value);
                  },
                  child: Text("بحث ")),
            ],
          ),
          Row(
            children: [
              StatefulBuilder(
                key: _scaffoldKey,
                builder: (BuildContext context, StateSetter set) {
                  return Padding(
                    padding: EdgeInsets.all(2),
                    child: Row(
                      children: [
                        Container(
                          child: Text(
                            "تاريخ اليوم",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'GE SS Two',
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                        Container(
                          child: Icon(Icons.date_range),
                        ),
                        SizedBox(width: 1),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.13,
                          child: IconButton(
                            onPressed: () async {
                              pickdate().then((String? value) {
                                set(() {
                                  getDate1 = value!.toString();
                                });
                              });
                            },
                            icon: Icon(Icons.timer),
                            color: Colors.blueAccent,
                            tooltip: 'تاريخ الفاتورة ',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 1.0),
                          child: Text("${getDate1}"),
                        ),
                        SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ElevatedButton(
                              onPressed: () {
                                billListDay().then((value) => list = value);
                              },
                              child: Text("بحث ")),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                              ),
                              onPressed: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                int? tagx;
                                tag = prefs.getDouble("tag");
                                tagx = tag?.toInt();
                                getManData(tagx.toString()!, getDate1!)
                                    .then((value) => datax = value);
                              },
                              child: Text("اون لاين")),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          loading
              ? Center(child: CircularProgressIndicator())
              : onn != true
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: list!.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: list![index]['approve'] == 0
                                ? Colors.red
                                : Colors.green,
                            child: Column(
                              children: [
                                GestureDetector(
                                  //show edit page
                                  // onTap: () {
                                  //       Navigator.pushReplacement(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //               builder: (context) => BillShowDetails(
                                  //                   id: list![index]['bill_id'])));
                                  //     },
                                  child: ListTile(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .4,
                                          color: list![index]['flag'] == "0"
                                              ? Colors.yellow
                                              : Colors.green,
                                          child: Text(
                                            list![index]['bill_id'].toString(),
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'GE SS Two',
                                            ),
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
                                              list![index]['bill_date']
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'GE SS Two',
                                              ),
                                            ),
                                            Text(
                                              'تاريخ الفاتورة',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'GE SS Two',
                                              ),
                                            ),

                                            //   Text(list![index]['City']), Text(list![index]['Role'])
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              list![index]['totalInvoice']
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
                                        //orgName
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              list![index]['orgName']
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'GE SS Two',
                                              ),
                                            ),
                                            Text(
                                              "العميل ",
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
                                              list![index]['totalPaid']
                                                  .toString(),
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
                                              list![index]['totalReset']
                                                  .toString(),
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
                                              list![index]['customer_id']
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'GE SS Two',
                                              ),
                                            ),
                                            Text(
                                              "كود العميل",
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
                                              list![index]['paymenttype']
                                                  .toString(),
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
                                SizedBox(
                                  height: 10,
                                ),
                                Divider(
                                  height: 4,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    list![index]['Flag'] != 1
                                        ? ElevatedButton(
                                            onPressed: () async {
                                              var dbclient = await conn.db;
                                              await dbclient
                                                  .rawQuery(
                                                      "delete from Bill where bill_id = ${list![index]["bill_id"]}")
                                                  .then((value) => setState(() {
                                                        billListToDay();
                                                      }));
                                            },
                                            child: Text("حذف"))
                                        : Container(),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Printer(
                                                id: list![index]['bill_id'],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text("طباعه")),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  : Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: datax?.length != null
                              ? DataTable(
                                  border: TableBorder.all(),
                                  columnSpacing: 38.0,
                                  headingRowColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.greenAccent),
                                  columns: [
                                    DataColumn(label: Text('الفاتورة')),
                                    DataColumn(label: Text('العميل')),
                                    DataColumn(label: Text('عدد الاصناف')),
                                    DataColumn(label: Text('نوع الفاتورة')),
                                    DataColumn(label: Text('اجمالي القيمه')),
                                    DataColumn(label: Text('تاريخ')),
                                  ],
                                  rows: List.generate(datax!.length, (index) {
                                    final bill_id = datax![index]["bill_id"]
                                            .toString()
                                            .substring(0, 14) ??
                                        0;
                                    final num =
                                        datax![index]["num"].toString() ?? 0;
                                    final payType =
                                        datax![index]["payType"].toString() ??
                                            0;
                                    final customer =
                                        datax![index]["customer"].toString() ??
                                            0;
                                    final date = datax![index]["bill_total"]
                                            .toString() ??
                                        0;
                                    final bill_total = datax![index]["date"]
                                            .toString()
                                            .substring(0, 10) ??
                                        0;

                                    return DataRow(cells: [
                                      DataCell(
                                          Container(child: Text("$bill_id"))),
                                      DataCell(
                                          Container(child: Text("$customer"))),
                                      DataCell(Container(child: Text("$num"))),
                                      DataCell(
                                          Container(child: Text("$payType"))),
                                      DataCell(Container(child: Text("$date"))),
                                      DataCell(Container(
                                          child: Text("$bill_total"))),
                                    ]);
                                  })
//                       +
//                       [
// // Add a new DataRow with the total values for each column
//                         DataRow(
//                             cells: [
//                               DataCell(Text(
//                                 'الإجمالي',
//                                 style: TextStyle(
//                                     fontSize: 15, fontWeight: FontWeight.bold),
//                               )),
//                               DataCell(Text(totalbills.toStringAsFixed(2))),
//                               DataCell(Text(totalitems.toStringAsFixed(2))),
//
//                             ],
//                             color: MaterialStateProperty.all<Color>(
//                                 Colors.greenAccent)),
//                       ]
                                  ,
                                )
                              : Center(
                                  child: Text(
                                  "لا يوجد معاملات",
                                  style: (TextStyle(fontSize: 25)),
                                )),
                        ),
                      ),
                    ),
        ],
      ),
    );
  }
}
