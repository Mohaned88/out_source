



import 'dart:convert';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dailySafe.dart';


class Mas7obatRepShow2 extends StatefulWidget {
  const Mas7obatRepShow2({Key? key}) : super(key: key);

  @override
  State<Mas7obatRepShow2> createState() => _Mas7obatRepShow2State();
}

class _Mas7obatRepShow2State extends State<Mas7obatRepShow2> {
  List list2 = [];
  var _mySelection;
  List data=[];
  double? tag;

  Future GetAllMas7obatData() async {

    final prefs = await SharedPreferences.getInstance();
    final String url = "http://sales.dynamicsdb2.com/api/Mas7obat/$_mySelection";
    var response =
    await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      print("Saving Data ");
      print(response.body);
    } else {
      print(response.statusCode);
    }

    List jsonResponse = jsonDecode(response.body);
    setState(() {
      data= List<Map<String, dynamic>>.from(jsonDecode(response.body));
      print(data);
    });
    print("get Report");
    print(jsonResponse);

    return jsonResponse;
  }
  Future getSWData() async {
    List ff = [];
    final prefs = await SharedPreferences.getInstance();
    var dbclient = await conn.db;
    int? tagx;
    tag  = prefs.getDouble("tag");
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
      list2 = ff;
      _mySelection = list2[0]["org_ID"].toString();


    });
    print(data);
    return data;
  }
  @override
  void initState() {
    getSWData().then((value) {
      _mySelection = value![0]["Item_Name"];
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:
     data!=null? Column(

          children: [
            DropdownFormField(
              onEmptyActionPressed: () async {},
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                  labelText: "عميل "),
              onSaved: (dynamic str) {},
              onChanged: (dynamic str) {print(str["org_ID"]);
              _mySelection=str["org_ID"].toString();
              ;},


              displayItemFn: (dynamic item) => Text(
                (item ?? {})['orgName'] ?? '',
                style: TextStyle(fontSize: 16),
              ),
              findFn: (dynamic str) async => list2,
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
              },),
            ElevatedButton(onPressed: (){GetAllMas7obatData();}, child: Text("عرض")),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  border: TableBorder.all(),
                  columnSpacing: 20.0,
                  columns: [
                    DataColumn(label: Text('اسم الصنف')),
                    DataColumn(label: Text('المسحوبات')),
                    DataColumn(label: Text('اجمالي ',style: (TextStyle(fontSize: 10)),)),
                    DataColumn(label: Text('المرتجعات')),
                    DataColumn(label: Text('اجمالي',style: (TextStyle(fontSize: 10)),)),
                  ],
                  rows: List.generate(data.length, (index) {
                    final b = data[index]["itemName"];
                    final c = double?.tryParse(data![index]["quantityTake"])??0;
                    final d =double?.tryParse(data![index]["total"]);
                    final e = double?.tryParse(data![index]["quantityAdd"]);
                    final f = double?.tryParse(data![index]["total2"]);
                    return DataRow(cells: [
                      DataCell(Container(child: Text(b))),
                      DataCell(Container(child: Text("$c"))),
                      DataCell(Container(child: Text("$d"))),
                      DataCell(Container( child: Text("$e"))),
                      DataCell(Container( child: Text("$f"))),

                    ]);
                  }),
                ),
              ),
            ),
          ],
        ):Text("fgfgffg"),
      );
  }
}
