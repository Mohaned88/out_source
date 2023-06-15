


//6-6-2023

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'ItemLogs.dart';

class InventoryRepShow extends StatefulWidget {
   InventoryRepShow({Key? key,required this.data}) : super(key: key);
List data ;
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


  @override
  Widget build(BuildContext context) {
    return   SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                border: TableBorder.all(),
                columnSpacing: 5.0,
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
                  final z = double.tryParse(data[index]["qTake"])!.roundToDouble();
                  final x = double.tryParse(data[index]["qAdd"])!.roundToDouble();
                  final d =data[index]["quantity"];
                  final e = data[index]["salesPrice"];
                  return DataRow(cells: [
                    DataCell(GestureDetector(onTap: () async {

                      final prefs = await SharedPreferences.getInstance();
                      int?  store  = prefs.getInt("store");
                     String? ItemCode = data[index]["itemId"];
                     print(ItemCode);
                      final String url = "http://sales.dynamicsdb2.com/api/TransLogReport?ItemID=$ItemCode&storeID=$store";
                      var response =
                          await http.post(Uri.parse(url), headers: {"Accept": "application/json"});
                      if (response.statusCode == 200 && response.body[0] !="[\"لايوجد اصناف\"]") {
                        print("Saving Data cc");
                        print(response.body);
                      } else {
                        print(response.statusCode);
                      }
                      String jsonResponse =json.decode(response.body);
                      print("get Reportcf");
                      print(jsonResponse);
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>ItemLogShow(data : jsonResponse)));
                    },child: Container(child: Text("$b",style:TextStyle(decoration: TextDecoration.underline,color: Colors.blue, fontWeight: FontWeight.bold),)))),
                    DataCell(Container(child: Text("$c"))),
                    DataCell(Container(child: Text("$z"))),
                    DataCell(Container(child: Text("$x"))),
                    DataCell(Container(child: Text("$d"))),
                    DataCell(Container( child: Text("$e"))),
                  ]);
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
