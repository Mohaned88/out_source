



import 'dart:convert';

import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../dailySafe.dart';


class GeneralDailyShow extends StatefulWidget {
  const GeneralDailyShow({Key? key}) : super(key: key);

  @override
  State<GeneralDailyShow> createState() => _GeneralDailyShowState();
}

class _GeneralDailyShowState extends State<GeneralDailyShow> {


  List list2 = [];
  var _mySelection;
  List data=[];
  double? tag;

  Future GetGeneralDailyData() async {

    final String url = "http://sales.dynamicsdb2.com/api/GeneralDailyReport/$_mySelection";
    var response =
    await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      print("Saving Data ");
      print(response.body);
    } else {
      print(response.statusCode);
    }
    setState(() {
      data= List<Map<String, dynamic>>.from(jsonDecode(response.body));
      print(data);
    });
    List jsonResponse = jsonDecode(response.body);

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
    return   SafeArea(
      child: Column(
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
          ElevatedButton(onPressed: (){GetGeneralDailyData();}, child: Text("عرض")),

          Container(
            color: Colors.blue,
            height: 38,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('الرصيد '),
                  Text('عليه'),
                  Text('   له   '),
                  Text( 'تاريخ المعامله'),
                  Text('شرح المعامله        '),
                ]),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              child: DataTable(
                border: TableBorder.all(),
                columnSpacing: 10.0,
                dataRowHeight: 100.0,
                headingRowHeight: 0,
                columns: [
                  DataColumn(label: Text('الرصيد')),
                  DataColumn(label: Text('عليه')),
                  DataColumn(label: Text('له')),
                  DataColumn(label: Text('تاريخ المعامله')),
                  DataColumn(label: Text('شرح المعامله')),
                ],
                rows: List.generate(data.length, (index) {
                  final b = data[index]["qedId"];
                  final d =data[index]["from"];
                  final e = data[index]["to"];
                  final f = data?[index]["qeddate"].toString().substring(0,10);
                  final g = data[index]["sharh"];
                  final x= double.tryParse(data[index]["balance"].toString())?.round()??0;
                  return DataRow(cells: [
                    DataCell(Container(child: Text("$x"))),
                    DataCell(Container(child: Text("$d"))),
                    DataCell(Container( child: Text("$e"))),
                    DataCell(Container( child: Text("$f"))),
                    DataCell(Container( child: Text("$g"))),
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
