import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Models/cashModel.dart';
import 'cashDetails.dart';
import 'databasehelper.dart';
import 'printer.dart';
import 'package:intl/intl.dart' as intl;

class CashIn extends StatefulWidget {
  const CashIn({Key? key}) : super(key: key);

  @override
  State<CashIn> createState() => _CashInState();
}

class _CashInState extends State<CashIn> {
  final conn = SqfliteDatabaseHelper.instance;
  List? list;
  List? listDet;
  TextEditingController cashNum = TextEditingController();
  bool loading = true;

  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: 7));
  }

  DateTime findLastDateOfTheMonth(DateTime dateTime) {
    return dateTime.subtract(Duration(days: 30));
  }

  Future cashList() async {
    late List ff = [];


    var dbclient = await conn.db;
    List<Map<String, dynamic>> maps =
        await dbclient.rawQuery('select * from Cash order by transDate desc');
    for (var item in maps) {
      ff.add(item);
    }

    print("dfcsdfsdf");
    setState(() {

      loading = false;
    });
    print(ff.length);
    return ff;
  }

  Future cashListNum() async {
    late List ff = [];
    var dbclient = await conn.db;
    List<Map<String, dynamic>> maps = await dbclient.rawQuery(
        'select * from Cash where transId = ${cashNum.text}  order by transDate desc ');
    for (var item in maps) {
      ff.add(item);
    }
    print("Num");
    setState(() {
      loading = false;
    });
    print(ff);
    return ff;
  }

  Future cashListToDay() async {
    late List ff = [];
    var dbclient = await conn.db;
    DateTime now = DateTime.now();
    final intl.DateFormat formatter = intl.DateFormat('yyyy-MM-dd');
    final String time = formatter.format(now);
    print(time);
    List<Map<String, dynamic>> maps = await dbclient.rawQuery(
        'select * from Cash where transDate = "$time" order by transDate desc ');
    for (var item in maps) {
      ff.add(item);
    }
    print("dfcsdfsdf");
    setState(() {
      loading = false;
    });
    print(ff.length);
    print(ff);
    return ff;
  }

  bool _customTileExpanded = false;
  String? getDate;

  Future cashListToWeek() async {
    late List ff = [];
    var dbclient = await conn.db;
    DateTime now = DateTime.now();
    final intl.DateFormat formatter = intl.DateFormat('yyyy-MM-dd');
    final String time = formatter.format(now);
    final String time2 = formatter.format(findLastDateOfTheWeek(now));
    print(time);
    print(time2);
    List<Map<String, dynamic>> maps = await dbclient.rawQuery(
        'select * from Cash where transDate Between "$time2" AND "$time"  order by transDate desc ');
    for (var item in maps) {
      ff.add(item);
    }
    print("dfcsdfsdf");
    setState(() {
      loading = false;
    });
    print(ff.length);
    return ff;
  }

  Future cashListToMonth() async {
    late List ff = [];
    var dbclient = await conn.db;
    DateTime now = DateTime.now();
    final intl.DateFormat formatter = intl.DateFormat('yyyy-MM-dd');
    final String time = formatter.format(now);
    final String time2 = formatter.format(findLastDateOfTheMonth(now));
    print(time);
    print(time2);
    List<Map<String, dynamic>> maps = await dbclient.rawQuery(
        'select * from Cash where transDate Between "$time2" AND "$time"  order by transDate desc');
    for (var item in maps) {
      ff.add(item);
    }
    print("dfcsdfsdf");
    setState(() {
      loading = false;
    });
    print(ff.length);
    return ff;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.cyanAccent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      var dbclient = await conn.db;
                      var xx = formatDate(DateTime.now(), [
                        yy,
                        '-',
                        mm,
                        '-',
                        dd,
                        '-',
                        hh,
                        '-',
                        mm,
                        '-',
                        ss
                      ]).toString().replaceAll('-', '');
                      // Obtain shared preferences.
                      final prefs = await SharedPreferences.getInstance();
                      DateTime now = DateTime.now();
                      final intl.DateFormat formatter =
                          intl.DateFormat('yyyy-MM-dd');
                      final String time = formatter.format(now);
                      getDate = time.toString();
                      var cashid = "${prefs.getString("ID")}" + "$xx";
                      print(cashid);
                      int? safe = prefs.getInt("safe");
                      String? id = prefs.getString("ID");
                      var sql =
                          'INSERT into Cash (transId,transDate,transSafeId,userId,transPaper,sendedonline,recivedonline,invoicenum)'
                          ' VALUES($cashid,"$getDate",$safe,$id,0,0,0,0 ) ';
                      int x = await dbclient.rawInsert(sql);
                      print(x);
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
                    onTap: () async {
                      List<CashInM> cashList1 = [];
                      var dbclient = await conn.db;
                      final maps =
                          await dbclient.rawQuery("select * from Cash ");
                      for (var item in maps) {
                        cashList1.add(CashInM.fromJson(item));
                        print("x");
                        print(item);
                      }
                    },
                    child: Text(
                      "استعراض التحصيلات",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GE SS Two',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                      onTap: () async {
                        var dbclient = await conn.db;
                        var xx = formatDate(DateTime.now(), [
                          yy,
                          '-',
                          mm,
                          '-',
                          dd,
                          '-',
                          hh,
                          '-',
                          mm,
                          '-',
                          ss
                        ]).toString().replaceAll('-', '');
                        // Obtain shared preferences.
                        final prefs = await SharedPreferences.getInstance();
                        DateTime now = DateTime.now();
                        final intl.DateFormat formatter =
                        intl.DateFormat('yyyy-MM-dd');
                        final String time = formatter.format(now);
                        getDate = time.toString();
                        var cashid = "${prefs.getString("ID")}" + "$xx";
                        print(cashid);
                        int? safe = prefs.getInt("safe");
                        String? id = prefs.getString("ID");
                        var sql =
                            'INSERT into Cash (transId,transDate,transSafeId,userId,posId,transPaper,sendedonline,recivedonline,invoicenum)'
                            ' VALUES($cashid,"$getDate",$safe,$id,1,0,0,0,0 ) ';
                        int x = await dbclient.rawInsert(sql);
                        print(x);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CashDetails(id: int.parse(cashid) ,)));
                      },
                      child: Icon(color: Colors.green,
                        Icons.add,
                        size: 30,
                      )),
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
                      cashList().then((value) => list = value);
                    },
                    child: Text("الكل")),
                ElevatedButton(
                    onPressed: () {
                      cashListToDay().then((value) => list = value);
                    },
                    child: Text("تحصيلات اليوم")),
                ElevatedButton(
                    onPressed: () {
                      cashListToWeek().then((value) => list = value);
                    },
                    child: Text("تحصيلات الاسبوع")),
                ElevatedButton(
                    onPressed: () {
                      cashListToMonth().then((value) => list = value);
                    },
                    child: Text("تحصيلات الشهر")),
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
                  decoration: InputDecoration(hintText: ' رقم مستند التحصيل'),
                  controller: cashNum,
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    cashListNum().then((value) => list = value);
                  },
                  child: Text("بحث ")),
            ],
          ),
          loading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
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
                              onTap: () {
                                 
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CashDetails(id:  list![index]['transId'])));
                              },
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      list![index]['transId'].toString(),
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
                                      "رقم المستند",
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
                                          list![index]['transDate'].toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'GE SS Two',
                                          ),
                                        ),
                                        Text(
                                          'تاريخ المستند',
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
                                          list![index]['transPaper']
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'GE SS Two',
                                          ),
                                        ),
                                        Text(
                                          "اجمالي قيمه  المستند",
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

                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // Expanded(
                                //
                                //   child: ExpansionTile(
                                //
                                //     title: const Text('تفاصيل'),
                                //
                                //     trailing: Icon(
                                //       _customTileExpanded
                                //           ? Icons.arrow_drop_down_circle
                                //           : Icons.arrow_drop_down,
                                //     ),
                                //     children: <Widget>[
                                //       ListView.builder(
                                //         shrinkWrap: true,
                                //          itemCount:listDet?.length,
                                //           itemBuilder: (context, index) {
                                //             return Card();
                                //           })
                                //     ],
                                //     onExpansionChanged: (bool expanded) {
                                //       setState(
                                //               () => _customTileExpanded = expanded);
                                //     },
                                //   ),
                                // ),
                                list![index]['FlagC'] != 1
                                    ? ElevatedButton(
                                        onPressed: () async {
                                          var dbclient = await conn.db;
                                          await dbclient
                                              .rawQuery(
                                                  "delete from Cash where transId = ${list![index]["transId"]}")
                                              .then((value) => setState(() {
                                                    cashListToDay();
                                                  }));
                                          
                                        },
                                        child: Text("حذف"))
                                    : Container(),

                                Container()
                              ],
                            ),

                          ],
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
      // GestureDetector(
      //   onTap: () async {
      //   },
      //   child: Center(
      //     child: Text("تحصيلات المبيعات",
      //         style: TextStyle(
      //           fontSize: 16,
      //           fontWeight: FontWeight.bold,
      //           fontFamily: 'GE SS Two',
      //         )),
      //   ),
      // ),
    );
  }
}
