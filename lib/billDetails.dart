import 'dart:math';
import 'package:flutter/material.dart';
import 'package:quantity_input/quantity_input.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:dy_app/Models/billsDetModel.dart';

import 'package:flutter/services.dart';
import 'controller.dart';
import 'databasehelper.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

// ignore: must_be_immutable
class BillDetails extends StatefulWidget {

  int id;
  int? type_id;

  //DateTime date;
  BillDetails({required this.id, required this.type_id, Key? key})
      : super(key: key);

  @override
  State<BillDetails> createState() => _BillDetailsState();
}

class _BillDetailsState extends State<BillDetails> {
  String? _mySelection;
  late String? selectedValueSingleDialog;
  final conn = SqfliteDatabaseHelper.instance;
  bool loading2 = true;
  double? after=0;
  bool loading3 = true;
  bool loading = true;
  List? list;
  List list2 = [];
  List? list3;
  List? list4;
  TextEditingController role = TextEditingController();
  TextEditingController role1 = TextEditingController();
  TextEditingController rolediscount = TextEditingController();
  TextEditingController role2 = TextEditingController();
  TextEditingController itemCode = TextEditingController();
  TextEditingController itemName = TextEditingController();
  TextEditingController itemPrice = TextEditingController();


  double _currentSliderValue = 1;
  var tt = 0.0;
  var Itemid;

  double Final = 0.0;

  Future billDetList() async {
    list3 = await Controller().fetchBillDetailsData(widget.id);

    setState(() {
      loading3 = false;
    });
    print(list3);
  }


  Future billList() async {
    List ff = [];

    var dbclient = await conn.db;
    List<Map<String, dynamic>> maps = await dbclient
        .rawQuery('select * from Bill where bill_id = ${widget.id}');
    for (var item in maps) {
      ff.add(item);
    }
    print("dfcsdfsdf");
    setState(() {
      loading = false;
    });
    print(ff);
    return ff;
  }
  final GlobalKey<ScaffoldState> _scaffoldKey1 = new GlobalKey<ScaffoldState>();
  final focus = FocusNode();
  Future itemList() async {
    List ff = [];
    var dbclient = await conn.db;
    List<Map<String, dynamic>> maps =
        await dbclient.rawQuery("select * from Items order by Item_Name ASC");
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
void afterFunc(){
    setState(() {
      after= double.parse(role1.text) - double.parse(rolediscount.text);

    });
}
  void counter() {
    setState(() {
      list3!.forEach((element) {
        tt += element!["total"];
        role1.text = tt.toString();
      });
      print(tt);
      after= tt;
      role1.text = tt.toString();
      tt = 0.0;
    });
  }

  @override
  void initState() {
    Final = 0.0;
    tt = 0.0;
    this.widget.type_id;

    this.widget.id;
    itemList().then((value) {

      _mySelection = value![0]['Item_Name'];
    });
    billList().then((value) => setState(list = value));
    //billDetList().then((value) => setState(list3 = value));
    super.initState();
  }

  String? xxx;
  String _scanBarcode = 'Unknown';
  String barcodeScanRes = "none";

  Future<String> scanBarcodeNormal() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return barcodeScanRes;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
    return _scanBarcode;
  }

  Future<void> scanQR() async {
    String qrResult = await scanBarcodeNormal();
    print("ssadsad $qrResult");
    List ffxx = [];
    if (_scanBarcode != "Unknown") {
      var dbclient = await conn.db;

      List<Map<String, dynamic>> maps = await dbclient
          .rawQuery("select * from Items where Item_ID = ${_scanBarcode}");
      for (var item in maps) {
        ffxx.add(item);
      }
    }
    setState(() {
      list4 = ffxx;
      print(list4);
      print(list4![0]["Item_Name"]);
      itemName.text = list4![0]["Item_Name"];
      itemPrice.text = list4![0]["SalesPrice"].toString();
    });
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
                      dbclient.rawQuery("""
                INSERT INTO sqlite_sequence (name,seq) SELECT 'billsDet', 666666 WHERE NOT EXISTS (SELECT changes() AS change FROM sqlite_sequence WHERE change <> 0);
                  """);
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
                      late List ff = [];
                      var dbclient = await conn.db;
                      List<Map<String, dynamic>> maps = await dbclient.rawQuery(
                          'select * from items order by Item_Name ASC');
                      for (var item in maps) {
                        ff.add(item);
                      }
                      print("dfcsdfsdf");
                      setState(() {
                        loading = false;
                      });
                      print(ff);
                    },
                    child: Text(
                      " ${widget.id}فاتورة مبيعات رقم      ",
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
      body: Container(
        child: Column(
         mainAxisAlignment: MainAxisAlignment.start,
          children: [
            loading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: list!.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height:MediaQuery.of(context).size.height*.2,
                              child: GestureDetector(
                                onTap: () {},
                                child: Card(
                                  shadowColor: Colors.grey,
                                  child: Column(
                                  //  shrinkWrap: true,
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
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'GE SS Two',
                                              ),
                                            ),
                                            Text(
                                              "رقم الفاتورة",
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                fontSize: 14,
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
                                              list![index]['bill_date'].toString(),
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'GE SS Two',
                                              ),
                                            ),
                                            Text(
                                              "تاريخ الفاتورة",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'GE SS Two',
                                              ),
                                            ),

                                            // Text(
                                            //   list![index]['totalInvoice'].toString(),
                                            //   style: TextStyle(
                                            //     fontSize: 16,
                                            //     fontWeight: FontWeight.bold,
                                            //     fontFamily: 'GE SS Two',
                                            //   ),
                                            // ),
                                            // Text(
                                            //   list![index]['customer_id'].toString(),
                                            //   style: TextStyle(
                                            //     fontSize: 16,
                                            //     fontWeight: FontWeight.bold,
                                            //     fontFamily: 'GE SS Two',
                                            //   ),
                                            // ),
                                            //   Text(list![index]['City']), Text(list![index]['Role'])
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
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'GE SS Two',
                                              ),
                                            ),
                                            Text(
                                              "نوع المعامله",
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                fontSize: 14,
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
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'GE SS Two',
                                              ),
                                            ),
                                            Text(
                                              "كود المخزن ",
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                fontSize: 14,
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
                            ),
                          ],
                        );
                      },
                    ),
                  ),
            SizedBox(
              height: 2,
            ),
            Divider(
              height: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'صنف',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'GE SS Two',
                  ),
                ),
              ],
            ),

            DropdownFormField(
              onEmptyActionPressed: () async {},
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                  labelText: "صنف"),
              onSaved: (dynamic str) {},
              onChanged: (dynamic str) {
                print(str["Item_Name"]);
                print(str["Item_ID"]);
                print(str["SalesPrice"]);
                role.text= str["SalesPrice"].toString();
                Itemid= str["Item_ID"];
                _mySelection = str["Item_Name"];
                setState(() {
                  itemName.text=  str["Item_Name"];
                  itemPrice.text= str["SalesPrice"].toString();
                });
                ;
              },
              validator: (dynamic str) {},
              displayItemFn: (dynamic item) => Text(
                (item ?? {})['Item_Name'] ?? '',
                style: TextStyle(fontSize: 16),
              ),
              findFn: (dynamic str) async => list2,
              selectedFn: (dynamic item1, dynamic item2) {
                if (item1 != null && item2 != null) {
                  return item1['Item_Name'] == item2['Item_Name'];
                }
                return false;
              },
              filterFn: (dynamic item, str) =>
              item['Item_Name'].toLowerCase().indexOf(str.toLowerCase()) >= 0,
              dropdownItemFn: (dynamic item, int position, bool focused,
                  bool selected, Function() onTap) {
                return ListTile(
                  title: Text(item['Item_Name']),
                  subtitle: Text(
                    item['Item_ID']?.toString() ?? '',
                  ),
                  selected: false,
                  tileColor:
                  focused ? Color.fromARGB(20, 0, 0, 0) : Colors.transparent,
                  onTap: onTap,
                );
              },
            ),
            Row(
              children: [
                //
                // GestureDetector(
                //     onTap: (){scanQR();},
                //     child: Container(child: Icon(Icons.document_scanner_sharp))),
                // Container(
                //   width: 70,
                //   child: Text(
                //     "$_scanBarcode",
                //     style: TextStyle(
                //       fontSize: 12,
                //       fontWeight: FontWeight.bold,
                //       fontFamily: 'GE SS Two',
                //     ),
                //   ),
                // ),
                Container(
                  width: MediaQuery.of(context).size.width * .4,
                  child: TextField(
                    controller: itemName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'GE SS Two',
                    ),
                  ),
                ),
                Container(
                  width: 50,
                  child: TextField(
                    controller: itemPrice,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'GE SS Two',
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'كميه',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'GE SS Two',
                  ),
                ),
              ],
            ),
            QuantityInput(
                value: _currentSliderValue,
                onChanged: (value) => setState(() => _currentSliderValue = double.parse(value.replaceAll(',', '')))
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      var dbclient = await conn.db;
                      var sql;
                      if ({widget.type_id} == 1) {
                        sql =
                            'update Bill set approve = 1 , totalPaid= ${role2.text} , totalInvoice= ${role1.text},totalReset= ${rolediscount.text} where bill_Id = ${widget.id};';
                      } else {
                        sql =
                            'update Bill set approve = 1 , totalPaid= ${role2.text} , totalInvoice= ${role1.text},totalReset= ${rolediscount.text} where bill_Id = ${widget.id};';
                      }
                      int x = await dbclient.rawInsert(sql);
                      if (x > 0) {
                        print("Success");
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text(" تم اعتماد الفاتورة ")));
                        billDetList().then((value) => counter());
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text(" لم يتم (من فضلك ادخل المبلغ المدفوع) ")));
                      }
                    },
                    child: Text("اعتماد "),
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
                   int transid =   next.toInt();
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
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    height: 20,
                    width: 80,
                    child: TextField(
                      controller: role1,
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
                    child: ElevatedButton(child: Text("تطبيق الخصم"),
                      onPressed: ()async{
                      afterFunc();

                    },),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    height: 20,
                    width: 120,
                    child: ElevatedButton(child: Text("$after"),onPressed: (){},),
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
                  "اسم   الصنف",
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
            if (loading3) Center(child: CircularProgressIndicator()) else Expanded(
                    child: ListView.builder(
                      itemCount: list3!.length,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Column(
                                children: [
                                  GestureDetector(
                                    onDoubleTap: ()async{
                                      var dbclient = await conn.db;
                                      dbclient
                                          .rawQuery(
                                          "delete from billsDet where itemId = ${list3![index]["itemId"]}").whenComplete(() {
                                        setState(() {
                                          list3!.removeAt(index);

                                          billDetList().then(
                                                  (value) {
                                                    counter();
                                                    return value = list3;
                                                  });
                                        });
                                          });
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(list3![index]['price'].toString()),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Text(list3![index]['Item_Name'].toString()),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Text(
                                            list3![index]['unit1Quant'].toString()),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Text(list3![index]['total'].toString()),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }


}
