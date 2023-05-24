import 'dart:math';

import 'package:dy_app/Models/billsDetModel.dart';
import 'package:flutter/material.dart';
import 'controller.dart';
import 'databasehelper.dart';

// ignore: must_be_immutable
class BillShowDetails extends StatefulWidget {
  int id;

  //DateTime date;
  BillShowDetails({required this.id, Key? key}) : super(key: key);

  @override
  State<BillShowDetails> createState() => _BillShowDetailsState();
}

class _BillShowDetailsState extends State<BillShowDetails> {
  late String? selectedValueSingleDialog;
  final conn = SqfliteDatabaseHelper.instance;
  bool loading2 = true;
  bool loading3 = true;

  bool loading = true;
  List? list;
  List? list2;
  List list3=[];
  TextEditingController role = TextEditingController();
  TextEditingController role1 = TextEditingController();
  double _currentSliderValue = 1;
  var tt = 0.0;
  var Itemid;
  double Final = 0.0;
  var Itemprice;
  double? after = 0;
  TextEditingController role2 = TextEditingController();
  TextEditingController rolediscount = TextEditingController();

  void afterFunc() {
    setState(() {
      after = double.parse(role1.text) - double.parse(rolediscount.text);
    });
  }

  Future billDetList() async {
    List ff = [];
    var dbclient = await conn.db;
    List<Map<String, dynamic>> maps = await dbclient.rawQuery(
        'select itemId,unit1Quant,price,finalPrice,total,Item_Name from billsDet  INNER JOIN Items ON itemId = Item_ID where billId = ${widget.id}  ');
    for (var item in maps) {
      ff.add(item);
    }
    print("cxxxxxxxxxxxx");
    setState(() {
      loading3 = false;
    });
    print(ff);
    return ff;
  }


  Future billList() async {
    List? ff = [];

    var dbclient = await conn.db;
    List<Map<String, dynamic>> maps = await dbclient
        .rawQuery('select * from Bill where bill_id = ${widget.id}');
    for (var item in maps) {
      ff.add(item);
    }
    print("dfcsdfsdf");
    setState(() {
      loading = false;
      //counter();
    });
    print(ff);
    return ff;
  }

  final GlobalKey<ScaffoldState> _scaffoldKey1 = new GlobalKey<ScaffoldState>();

  final focus = FocusNode();
  String? _mySelection;

  Future itemList() async {
    List ff = [];
    var dbclient = await conn.db;
    List<Map<String, dynamic>> maps =
        await dbclient.rawQuery("select * from Items");
    for (var item in maps) {
      ff.add(item);
    }
    print("items get");
    setState(() {
      list2 = ff;
      role.text = "${ff[0]["SalesPrice"].toString()}";
      _mySelection = ff[0]["Item_Name"];
      loading2 = false;
    });
    print(ff);
    return list2;
  }

  void counter() {
    setState(() {
      list3.forEach((element) {
        tt += element!["total"];
        role1.text = tt.toString();
      });
      print(tt);
      after = tt;
      role1.text = tt.toString();
      tt = 0.0;
    });
  }

  @override
  void initState() {
    Final = 0.0;
    tt = 0.0;
    this.widget.id;
    itemList().then((value) {
      setState(list2 = value);
      _mySelection = value!['Item_Name'];
    });

    billList().then((value) => setState(list = value));
    billDetList().then((value) {
      setState(list3 = value);
    }).then((value) => counter());
    super.initState();
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
                      counter();
                      billDetList();
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
                      " ${widget.id}فاتورة مبيعات رقم   ",
                      style: TextStyle(
                        fontSize: 12,
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          loading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: list!.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Card(
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          list![index]['bill_id'].toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'GE SS Two',
                                          ),
                                        ),
                                        Text(
                                          "رقم الفاتورة",
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'GE SS Two',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          list![index]['bill_date'].toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'GE SS Two',
                                          ),
                                        ),
                                        Text(
                                          "تاريخ الفاتورة",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'GE SS Two',
                                          ),
                                        ),


                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
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
                                          "نوع المعامله",
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'GE SS Two',
                                          ),
                                        ),

                                        // Text(list![index]['LastName']),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          list![index]['store_id'].toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'GE SS Two',
                                          ),
                                        ),
                                        Text(
                                          "كود المخزن ",
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'GE SS Two',
                                          ),
                                        ),

                                        // Text(list![index]['LastName']),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
          SizedBox(
            height: 10,
          ),
          Divider(
            height: 4,
          ),
          Text(
            'صنف',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'GE SS Two',
            ),
          ),
          Row(
            children: [
              Row(
                children: [
                  loading2
                      ? Center(child: CircularProgressIndicator())
                      : StatefulBuilder(
                          key: _scaffoldKey1,
                          builder: (BuildContext context, StateSetter set) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                //SizedBox(width: 6),
                                DropdownButton<String>(
                                  value: _mySelection,
                                  onChanged: (value) async {
                                    List ff = [];
                                    var dbclient = await conn.db;
                                    List<Map<String, dynamic>> maps =
                                        await dbclient.rawQuery(
                                            "select * from Items where Item_Name Like '%${value}%'");
                                    for (var item in maps) {
                                      ff.add(item);
                                    }
                                    setState(() {
                                      _mySelection = value;
                                      _mySelection = ff[0]["Item_Name"];
                                      Itemid = ff[0]["Item_ID"];
                                      role.text =
                                          ff[0]["SalesPrice"].toString();
                                      print(
                                          "item code is ${ff[0]["SalesPrice"]} ");
                                      print(_mySelection);
                                    });
                                  },
                                  items: list2!.map(
                                    (item) {
                                      return DropdownMenuItem(
                                        value: item["Item_Name"].toString(),
                                        child: Row(
                                          children: [
                                            new Text(
                                                item['Item_Name'].toString()),
                                          ],
                                        ),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ],
                            );
                          },
                        ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 50,
                      child: TextField(
                        enabled: false,
                        controller: role,
                        decoration: InputDecoration(hintText: ' price'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            'كميه',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'GE SS Two',
            ),
          ),
          Slider(
            value: _currentSliderValue,
            min: 0,
            max: 20,
            divisions: 20,
            label: _currentSliderValue.round().toString(),
            onChanged: (double value) {
              setState(() {
                _currentSliderValue = value;
                print(_currentSliderValue);
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    var dbclient = await conn.db;
                    var sql =
                        'update Bill set approve = 1 , totalPaid= ${role2.text} , totalInvoice= ${role1.text},totalReset= ${rolediscount.text} where bill_Id = ${widget.id};';
                    int x = await dbclient.rawInsert(sql);
                    if (x > 0) {
                      print("Success");
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("  تم الاعتماد ")));
                      billDetList().then((value) => counter());
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text(" لم يتم الاعتماد ")));
                    }
                  },
                  child: Text("اعتماد "),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    counter();
                    billDetList();
                  },
                  child: Text("تحديث اجمالي الفاتورة "),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    var rnd = new Random();
                    var next = rnd.nextDouble() * 1000000;
                    while (next < 100000) {
                      next *= 10;
                    }
                    int transid = next.toInt();
                    print(next.toInt());
                    double _total =
                        double.parse(role.text) * _currentSliderValue;
                    BillDet billdetial = BillDet(
                        transId: transid,
                        billId: list![0]['bill_id'].toDouble(),
                        userId: 1,
                        storeId: list![0]['store_id'],
                        unit1Quant: _currentSliderValue,
                        price: double.parse(role.text),
                        billdate: list![0]['bill_date'].toString(),
                        total: _total,
                        finalPrice: _total,
                        itemId: Itemid.toDouble());
                    await Controller().addDetailsData(billdetial).then((value) {
                      if (value > 0) {
                        print("Success");
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Success")));
                        billDetList().then((value) => counter());
                      } else {
                        print("faild");
                      }
                    });
                  },
                  child: Text("اضافة"),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("اجمالي الفاتورة"),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 50,
                  child: TextField(
                    controller: role1,
                    enabled: false,
                    decoration: InputDecoration(hintText: ' price'),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("قيمه الخصم"),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  height: 20,
                  width: 50,
                  child: TextField(
                    controller: rolediscount,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: ' price'),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  height: 20,
                  width: 120,
                  child: ElevatedButton(
                    child: Text("تطبيق الخصم"),
                    onPressed: () async {
                      afterFunc();
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  height: 20,
                  width: 120,
                  child: ElevatedButton(
                    child: Text("$after"),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("المبلغ المدفوع"),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  height: 20,
                  width: 50,
                  child: TextField(
                    controller: role2,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: ' price'),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "السعر",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'GE SS Two',
                ),
              ),
              Text(
                "الكود",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'GE SS Two',
                ),
              ),
              Text(
                "الصنف",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'GE SS Two',
                ),
              ),
              Text(
                "الكميه",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'GE SS Two',
                ),
              ),
              Text(
                "الاجمالي",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'GE SS Two',
                ),
              )
            ],
          ),
          loading3
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: list3.length,
                    itemBuilder: (context, index) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            ListTile(
                              title: Column(
                                children: [
                                  GestureDetector(
                                    onDoubleTap: () async {
                                      var dbclient = await conn.db;
                                      dbclient
                                          .rawQuery(
                                              "delete from billsDet where itemId = ${list3[index]["itemId"]}")
                                          .then((value) => setState(() {
                                            list3.removeAt(index);
                                            loading3 =true;
                                                billDetList().then(
                                                    (value) => value = list3);
                                              }));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(list3[index]['price'].toString()),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Text(
                                            list3[index]['itemId'].toString()),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Text(list3[index]['Item_Name']
                                            .toString()),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Text(list3[index]['unit1Quant']
                                            .toString()),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Text(list3[index]['total'].toString()),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
