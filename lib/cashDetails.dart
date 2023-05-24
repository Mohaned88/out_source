import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:dy_app/Models/cashDetModel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart' as intl;
import 'controller.dart';
import 'dailySafe.dart';

class CashDetails extends StatefulWidget {
  CashDetails({Key? key, required this.id}) : super(key: key);
  int id;
  @override
  State<CashDetails> createState() => _CashDetailsState();
}
String? date2;

String? getDate;
TextEditingController value = TextEditingController();

class _CashDetailsState extends State<CashDetails> {
  String? _mySelection;
  List dataCash = [];

  Future getSWData() async {
    List ff = [];

    final prefs = await SharedPreferences.getInstance();
    var dbclient = await conn.db;
    double? tag = prefs.getDouble("tag");
    int? tagx = tag?.toInt();
    List<Map<String, dynamic>> maps = await dbclient.rawQuery(
        "select * from Organizations where Mandoub1 = $tagx order by orgName ASC");
    for (var item in maps) {
      ff.add(item);
    }
    print("TV get");
    print(ff);
    setState(() {
      data = ff;
      _mySelection = data[0]["org_ID"].toString();
    });
    print(data);
    return data;
  }

  List data = [];

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

  @override
  void initState() {
    CashDetList().then((value) => value = dataCash);
    final DateTime now = DateTime.now();
    final intl.DateFormat formatter = intl.DateFormat('yyyy-MM-dd');
    final String time = formatter.format(now);
    getDate = time.toString();
    getSWData().then(
      (value) {
        // setState(data = value);
        _mySelection = value![0]['org_ID'].toString();
      },
    );
    super.initState();
  }

  Future CashDetList() async {
    dataCash = await Controller().fetchCashDetailsData(widget.id);
    setState(() {
      this.dataCash;
    });
    return dataCash;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: GestureDetector(
                        onTap: () async {

                        },
                        child: Text(
                          "مستند توريد نقدية من عميل",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE SS Two',
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Text(
                        "رقم المستند",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'GE SS Two',
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    Text(
                      "${widget.id}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GE SS Two',
                      ),
                    ),
                  ],
                ),
                StatefulBuilder(
                  key: _scaffoldKey,
                  builder: (BuildContext context, StateSetter set) {
                    return Padding(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            child: Text(
                              "تاريخ المستند",
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
                            child: Text(
                              "${getDate}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'GE SS Two',
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 10),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("العميل"),
                    ),
                    Expanded(
                      child: DropdownFormField(
                        onEmptyActionPressed: () async {},
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.arrow_drop_down),
                            labelText: "عميل"),
                        onSaved: (dynamic str) {},
                        onChanged: (dynamic str) {
                          print(str["org_ID"]);
                          _mySelection = str["org_ID"].toString();
                          ;
                        },
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
                            item['orgName']
                                .toLowerCase()
                                .indexOf(str.toLowerCase()) >=
                            0,
                        dropdownItemFn: (dynamic item, int position,
                            bool focused, bool selected, Function() onTap) {
                          return ListTile(
                            title: Text(item['orgName']),
                            subtitle: Text(
                              item['org_ID'].toString(),
                            ),
                            selected: false,
                            tileColor: focused
                                ? Color.fromARGB(20, 0, 0, 0)
                                : Colors.transparent,
                            onTap: onTap,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          "قيمة  التوريد",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE SS Two',
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(border: Border.all()),
                        width: MediaQuery.of(context).size.width * .7,
                        child: TextField(
                          controller: value,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE SS Two',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      CashInDetM cashdet = CashInDetM(
                          transId: widget.id,
                          transAccount: int.parse(_mySelection!),
                          transText: " ",
                          transValue: int.parse(value.text),
                          transCostCenter: 0,
                          transPaperId: "0",
                          operationId: 0,
                          fileId: 0,
                          userId: 1,
                          invoiceId: 0,
                          costControlId: 0,
                          blockId: 0,
                          cheqNumber: "0",
                          installmentNumber: 0,
                          costTime: getDate!);
                      await Controller()
                          .addCashDetailsData(cashdet)
                          .then((value) {
                        if (value > 0) {
                          print("Success");
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Success")));
                          setState(() {
                            CashDetList();
                          });
                        } else {
                          print("faild");
                        }
                      });
                    },
                    child: Text(
                      "اضافة",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GE SS Two',
                      ),
                    )),
                Container(
                  height: MediaQuery.of(context).size.height * .4,
                  child: SingleChildScrollView(
                    child: DataTable(
                      columnSpacing: 35.0,
                      dataRowHeight: 80.0,
                      columns: [
                        DataColumn(
                            label: Text(
                          'كود ',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE SS Two',
                          ),
                        )),
                        DataColumn(
                            label: Text(
                          'اسم العميل',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE SS Two',
                          ),
                        )),
                        DataColumn(
                            label: Text(
                          'القيمه',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE SS Two',
                          ),
                        )),
                        DataColumn(
                            label: Text(
                          '',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE SS Two',
                          ),
                        )),
                      ],
                      rows: List.generate(dataCash.length, (index) {
                        final d = dataCash[index]["transAccount"];
                        final x = dataCash[index]["orgName"];
                        final e = dataCash[index]["transValue"];

                        return DataRow(cells: [
                          DataCell(
                            Container(
                              child: Text(
                                "$d",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'GE SS Two',
                                ),
                              ),
                            ),
                          ),
                          DataCell(Container(
                              child: Text(
                            "$x",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'GE SS Two',
                            ),
                          ))),
                          DataCell(Container(
                              child: Text(
                            "$e",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'GE SS Two',
                            ),
                          ))),
                          DataCell(
                            new ElevatedButton(
                              onPressed: () async {
                                var dbclient = await conn.db;
                                dbclient
                                    .rawQuery(
                                    "delete from CashDet where transId = ${dataCash[index]["transId"]} And transValue = ${dataCash[index]["transValue"]}").whenComplete(() {
                                  setState(() {
                                    dataCash.removeAt(index);
                                  });
                                });
                              },

                              child: Text("حذف"),
                            ),
                          ),
                        ]);
                      }),
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: () async {
                        num total = 0;
                        total = dataCash.map((ff) => ff["transValue"]).fold(
                            0, (prev, totalInvoice) => prev + totalInvoice);
                        print(total);
                        var dbclient = await conn.db;
                        var sql;
                        print(widget.id);
                        sql =
                            'update Cash set approve = 1,transPaper="${total}"  where transId = ${widget.id}';
                        int x = await dbclient.rawInsert(sql);
                        if (x > 0) {
                          print("Success");
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text(" تم اعتماد  ")));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text(" لم يتم ")));
                        }
                        // //approve
                      },
                      child: Text(
                        "اعتماد",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'GE SS Two',
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
