
import 'package:date_format/date_format.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:shared_preferences/shared_preferences.dart';

import 'billDetails.dart';
import 'databasehelper.dart';

import 'syncronize.dart';

class Bill extends StatefulWidget {
  const Bill({Key? key}) : super(key: key);

  @override
  State<Bill> createState() => _BillState();
}

class _BillState extends State<Bill> {
  String? _mySelection;
  final conn = SqfliteDatabaseHelper.instance;
  String? getDate;
  String? date2;
  List data = [];
  dynamic cc;

  bool? paid;
  bool? notpaid;
  String? PayType;
  int? naqd;
  bool loading2 = true;
  double? tag;
  int? safe;
  int? store;
  String? id;
  int? tagx;
  Future getSWData() async {
  List ff = [];
    final prefs = await SharedPreferences.getInstance();
  var dbclient = await conn.db;
    tag  = prefs.getDouble("tag");
    safe    =   prefs.getInt("safe");
    store   =  prefs.getInt("store");
    id      = prefs.getString("ID");
    tagx    = tag?.toInt();
    print("$tagx");
    List<Map<String, dynamic>> maps =
       await dbclient.rawQuery("select * from Organizations where Mandoub1 = $tagx order by orgName ASC");
    for (var item in maps) {
      ff.add(item);
    }
    print("TV get");
    print(ff);
    setState(() {
      data = ff;
      _mySelection = data[0]["org_ID"].toString();
      loading2 = false;
    });
    print(data);
    return data;
  }

  @override
  void initState() {
    paid = true;
    naqd = 1;
    PayType = "نقدي";
    notpaid = false;

    getSWData().then(
      (value) {
       // setState(data = value);
        _mySelection = value![0]['org_ID'].toString();
      },
    );

    final DateTime now = DateTime.now();
    final intl.DateFormat formatter = intl.DateFormat('yyyy-MM-dd');
    final String time = formatter.format(now);
    getDate = time.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final conn = SqfliteDatabaseHelper.instance;
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
                      SyncronizationData().fetchAllItems();
                    },
                    child: GestureDetector(
                      onTap: () async {
                        List ff = [];
                        var dbclient = await conn.db;
                        List<Map<String, dynamic>> maps = await dbclient
                            .rawQuery("select * from Organizations");
                        for (var item in maps) {
                          ff.add(item);
                        }
                        print("TV get");
                        print(ff);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * .1,
                        height: MediaQuery.of(context).size.height * .1,
                        child: Image.asset("assets/images/bb.png"),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () async {
                      var dbclient = await conn.db;
                      // var sql = 'delete from Bill';
                      // var sql1 = 'delete from billsDet';
                      //   var sql12 = 'delete from Organization';
                      // dbclient.rawQuery(sql);
                      // dbclient.rawQuery(sql1);
                      // dbclient.rawQuery(sql12);
                    },
                    child: Text(
                      "مبيعات",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GE SS Two',
                      ),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                  onTap: () async {
                    var dbclient = await conn.db;
                    String sharh = "فاتورة مبيعات من الهاتف";
                    var   xx=  formatDate(DateTime.now(), [yy, '-', mm, '-', dd,'-',hh,'-',mm,'-',ss]).toString().replaceAll('-', '');
                    // Obtain shared preferences.
                    final prefs = await SharedPreferences.getInstance();
                    var billid = "${prefs.getString("ID")}"+"$xx";
                    print(billid);
                    var sql =
                        'INSERT into Bill (bill_id,naqd,bill_date,customer_id,startdate,approve,user_id,safe,store_id,paymenttype,mandoob_1,sharh)'
                        ' VALUES($billid,$naqd,"$getDate","${_mySelection?.trim()}","$getDate",0,$id,$safe,$store,"$PayType",$tagx,"$sharh" ) ';
                    int x = await dbclient.rawInsert(sql);
                    print(x);
                       Navigator.push(context, MaterialPageRoute(builder: (context) => BillDetails(id: int.parse(billid),type_id:naqd ,)));
                  },
                  child: Icon(
                    Icons.add,
                    size: 34,
                  ))
            ],
          )),
      body: ListView(
        children: [
          StatefulBuilder(
            key: _scaffoldKey,
            builder: (BuildContext context, StateSetter set) {
              return Padding(
                padding: EdgeInsets.all(5),
                child: Row(
                  children: [
                    Container(
                      child: Text(
                        "تاريخ الفاتورة",
                        style: TextStyle(
                          fontSize: 16,
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
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: IconButton(
                        onPressed: () async {
                          pickdate().then((String? value) {
                            set(() {
                              getDate = value!.toString();
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
                      child: Text("${getDate}"),
                    )
                  ],
                ),
              );
            },
          ),

          StatefulBuilder(
            builder: (BuildContext context, StateSetter setRow) {
              return Padding(
                padding:
                    EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      textDirection: TextDirection.ltr,
                      children: [
                        Checkbox(
                          value: paid,
                          onChanged: (value) {
                            if (value!) {
                              setRow(() {
                                paid = true;
                                notpaid = false;
                                paid == true ? PayType = 'نقدي' : null;
                                paid == true ? naqd = 1 : null;
                                print(PayType);
                                print(naqd);
                              });
                            } else {
                              setRow(() {
                                paid = false;
                              });
                            }
                          },
                        ),
                        Text('نقدي'),
                      ],
                    ),
                    Row(
                      textDirection: TextDirection.ltr,
                      children: [
                        Checkbox(
                          value: notpaid,
                          onChanged: (value) {
                            if (value!) {
                              setRow(() {
                                notpaid = true;
                                paid = false;
                                notpaid == true ? PayType = 'أجل' : null;
                                notpaid == true ? naqd = 2 : null;
                                print(PayType);
                                print(naqd);
                              });
                            } else {
                              setRow(() {
                                notpaid = false;
                              });
                            }
                          },
                        ),
                        Text('اجل'),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
      DropdownFormField(
        onEmptyActionPressed: () async {},
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.arrow_drop_down),
            labelText: "عميل"),
        onSaved: (dynamic str) {},
        onChanged: (dynamic str) {print(str["org_ID"]);
        _mySelection=str["org_ID"].toString();
        ;},


        displayItemFn: (dynamic item) => Text(
          (item ?? {})['orgName'] ?? '',
          style: TextStyle(fontSize: 16),
        ),
        findFn: (dynamic str) async => data,
        selectedFn: (dynamic item1, dynamic item2) {
          if (item1 != null && item2 != null) {
            return item1['orgName'] == item2['orgName'];
          }
          return false;
        },
        filterFn: (dynamic item, str) =>
        item['orgName'].toLowerCase().indexOf(str.toLowerCase()) >= 0,
        dropdownItemFn: (dynamic item, int position, bool focused,
            bool selected, Function() onTap) {

          return ListTile(

              title: Text(item['orgName']),
              subtitle: Text(
                item['org_ID'].toString(),
              ),selected: false,

              tileColor:
              focused ? Color.fromARGB(20, 0, 0, 0) : Colors.transparent,
              onTap: onTap,
            );
        },)

        ],
      ),
    );
  }
}

