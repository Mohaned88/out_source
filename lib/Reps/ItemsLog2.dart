

///12-6-2023 new


import 'dart:convert';

import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../dailySafe.dart';

class ItemsLog extends StatefulWidget {
  const ItemsLog({Key? key}) : super(key: key);

  @override
  State<ItemsLog> createState() => _ItemsLogState();
}

class _ItemsLogState extends State<ItemsLog> {
  List list2 = [];
  var ItemCode;
  List data=[];
  String? _mySelectionItem;
  Future itemList() async {
    List fff = [];
    var dbclient = await conn.db;
    List<Map<String, dynamic>> maps =
    await dbclient.rawQuery("select * from Items order by Item_Name ASC");
    for (var item in maps) {
      fff.add(item);
    }
    print("items get");
    setState(() {
      list2 = fff;
      _mySelectionItem = fff[0]["Item_Name"];
    });
    print(fff);
    return list2;
  }
  Future GetItemLog() async {
    final prefs = await SharedPreferences.getInstance();
    int? store = prefs.getInt("store");

    final String url = "http://sales.dynamicsdb2.com/api/TransLogReport?ItemID=$ItemCode&storeID=$store";
    var response =
    await http.post(Uri.parse(url), headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      print("Saving Data ");
      print(response.body);
    } else {
      print(response.statusCode);
    }
setState(() {
 //data=  List<Map<String, dynamic>>.from(jsonDecode(response.body));
     data= json.decode(jsonDecode(response.body));
 print(data);
});
    String jsonResponse = jsonDecode(response.body);
    print("get Report");
    print(jsonResponse);


    return jsonResponse;
  }
  @override
  void initState() {
    itemList().then((value) {
      _mySelectionItem = value![0]["Item_Name"];
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return        SafeArea(
      child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.all(0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 4),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  //new BoxShadow(color: Colors.blue, offset: new Offset(6.0, 6.0),),
                ],
              ),

              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .20,
              child:
              Container(

                child:
                Column(
                  children: [
                    Text(
                      "حركه صنف",
                      textDirection: TextDirection.rtl,
                      style: (TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                        _mySelectionItem = str["Item_Name"];
                        setState(() {
                          ItemCode = str["Item_ID"];
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
                    ElevatedButton(onPressed: (){GetItemLog();}, child: Text("عرض"))
                  ],
                ),
              ),
            ),
            //end,
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child:
                  data.length!=1?
                  DataTable(
                    border: TableBorder.all(),
                    columnSpacing: 38.0,
                    headingRowColor:  MaterialStateProperty.all<Color>(
                        Colors.greenAccent),
                    columns: [
                      DataColumn(label: Text('نوع')),
                      DataColumn(label: Text('تاريخ')),
                      DataColumn(label: Text('رقم المعامله')),
                      DataColumn(label: Text('العميل')),
                      DataColumn(label: Text('مضاف')),
                      DataColumn(label: Text('مسحوبات')),
                      DataColumn(label: Text('رصيد')),
                    ],
                    rows: List.generate(data.length, (index) {
                      final c = data[index]["TransType"].toString() ?? 0;
                      final date = data[index]["TransDate"].toString().substring(0, 10) ?? 0;
                      final d = data[index]["QuantityAdd"].toString() ?? 0;
                      final e = data[index]["QuantityTake"].toString() ?? 0;
                      final f = data[index]["TransId"].toString() ?? 0;
                      final tag = data[index]["Tag"].toString() ?? 0;
                      final balance = data[index]["balance"].toString() ?? 0;
                      // final x = double.tryParse(d)!-double.tryParse(e)!;s
                      return DataRow(cells: [
                        DataCell(Container(child: Text("$c"))),
                        DataCell(Container(child: Text("$date"))),
                        DataCell(Container(child: Text("$f"))),
                        DataCell(Container(child: Text("$tag"))),
                        DataCell(Container(child: Text("$d"))),
                        DataCell(Container(child: Text("$e"))),
                        DataCell(Container(child: Text("$balance"))),
                        //  DataCell(Container( child: Text("$x"))),
                      ]);
                    }),
                  ):Center(child: Text("لا يوجد معاملات",style: (TextStyle(fontSize: 25)),)),
                ),
              ),

            ),])
      ,
    );

  }
}
