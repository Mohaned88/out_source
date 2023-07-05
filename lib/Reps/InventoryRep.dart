//6-6-2023

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../resources/colors.dart';
import 'ItemLogs.dart';

class InventoryRepShow extends StatefulWidget {
  InventoryRepShow({Key? key, required this.data}) : super(key: key);
  List data;

  @override
  State<InventoryRepShow> createState() => _InventoryRepShowState();
}

class _InventoryRepShowState extends State<InventoryRepShow> {
  List data = [];

  @override
  void initState() {
    data = widget.data;
    super.initState();
  }

  ///update 1/7/2023///
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          title: Text(
            "اصناف مخزن المندوب",
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'GE SS Two',
              color: Colors.white,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columnSpacing: w * 0.1,
                      headingRowColor: MaterialStateProperty.all<Color>(
                        AppColors.mainColor.withOpacity(0.3),
                      ),
                      border: TableBorder.all(),
                      columns: [
                        DataColumn(label: Text('كود')),
                        DataColumn(label: Text('اسم الصنف')),
                        DataColumn(label: Text('المنصرف')),
                        DataColumn(label: Text('الوارد')),
                        DataColumn(label: Text('الكميه')),
                        DataColumn(label: Text('سعر ')),
                      ],
                      rows: List.generate(data.length, (index) {
                        final b = data[index]["itemId"];
                        final c = data[index]["itemName"];
                        final z = double.tryParse(data[index]["qTake"])!
                            .roundToDouble();
                        final x = double.tryParse(data[index]["qAdd"])!
                            .roundToDouble();
                        final d = data[index]["quantity"];
                        final e = data[index]["salesPrice"];
                        return DataRow(cells: [
                          DataCell(
                            GestureDetector(
                              onTap: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                int? store = prefs.getInt("store");
                                String? ItemCode = data[index]["itemId"];
                                print(ItemCode);
                                final String url =
                                    "http://sales.dynamicsdb2.com/api/TransLogReport?ItemID=$ItemCode&storeID=$store";
                                var response = await http.post(
                                  Uri.parse(url),
                                  headers: {"Accept": "application/json"},
                                );
                                if (response.statusCode == 200 &&
                                    response.body[0] != "[\"لايوجد اصناف\"]") {
                                  print("Saving Data cc");
                                  print(response.body);
                                } else {
                                  print(response.statusCode);
                                }
                                String jsonResponse =
                                    json.decode(response.body);
                                print("get Reportcf");
                                print(jsonResponse);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ItemLogShow(
                                      data: jsonResponse,
                                      title: "$c",
                                    ),
                                  ),
                                );
                              },
                              child: SizedBox(
                                width: double.infinity,
                                child: Container(
                                  child: Text(
                                    "$b",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          DataCell(Container(child: Text("$c"))),
                          DataCell(SizedBox(
                              width: double.infinity,
                              child: Text(
                                "$z",
                                textAlign: TextAlign.center,
                              ))),
                          DataCell(SizedBox(
                              width: double.infinity,
                              child: Text(
                                "$x",
                                textAlign: TextAlign.center,
                              ))),
                          DataCell(SizedBox(width: double.infinity, child: Text("$d", textAlign: TextAlign.center,))),
                          DataCell(SizedBox(
                              width: double.infinity,
                              child: Text(
                                "$e",
                                textAlign: TextAlign.center,
                              ))),
                        ]);
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  ///end update 1/7/2023///
}
