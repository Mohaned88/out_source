import 'dart:convert';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dailySafe.dart';
import '../resources/colors.dart';

class Mas7obatRepShow2 extends StatefulWidget {
  const Mas7obatRepShow2({Key? key}) : super(key: key);

  @override
  State<Mas7obatRepShow2> createState() => _Mas7obatRepShow2State();
}

class _Mas7obatRepShow2State extends State<Mas7obatRepShow2> {
  List list2 = [];
  var _mySelection;
  List data = [];
  double? tag;

  Future GetAllMas7obatData() async {
    final prefs = await SharedPreferences.getInstance();
    final String url =
        "http://sales.dynamicsdb2.com/api/Mas7obat/$_mySelection";
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
      data = List<Map<String, dynamic>>.from(jsonDecode(response.body));
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
    tag = prefs.getDouble("tag");
    tagx = tag?.toInt();
    print("$tagx");
    List<Map<String, dynamic>> maps = await dbclient.rawQuery(
        "select * from Organizations where Mandoub1 = $tagx order by orgName ASC");
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

  ///update 30/6/2023///
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: AppColors.mainColor,
              title: Text(
                "حركة صنف",
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'GE SS Two',
                  color: Colors.white,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: Size(double.infinity, w * .19),
                child: Container(
                  margin: EdgeInsets.only(bottom: w * 0.02),
                  padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          height: w * 0.154,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(w * 0.5),
                              color: Colors.white),
                          child: DropdownFormField(
                            onEmptyActionPressed: () async {},
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.mainColor.withOpacity(0.4),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(w * 0.5),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(w * 0.5),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(w * 0.5),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              suffixIcon: Icon(Icons.arrow_drop_down),
                              labelText: "عميل",
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
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
                            findFn: (dynamic str) async => list2,
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
                      ),
                      Padding(
                        padding: EdgeInsets.all(w * 0.02),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: FloatingActionButton(
                            backgroundColor:
                                AppColors.mainColor.withOpacity(0.4),
                            elevation: 0,
                            onPressed: () {
                              setState(() {
                                GetAllMas7obatData();
                              });
                            },
                            child: Icon(
                              Icons.send,
                              color: AppColors.mainColor,
                              size: w * 0.09,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                child: data != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DataTable(
                            border: TableBorder.all(),
                            headingRowColor: MaterialStateProperty.all<Color>(
                              AppColors.mainColor.withOpacity(0.3),),
                            columnSpacing: 20.0,
                            columns: [
                              DataColumn(
                                label: Text(
                                  'اسم الصنف',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'المسحوبات',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'اجمالي ',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'المرتجعات',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'اجمالي',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                            rows: List.generate(data.length, (index) {
                              final b = data[index]["itemName"];
                              final c = double?.tryParse(
                                      data![index]["quantityTake"]) ??
                                  0;
                              final d = double?.tryParse(data![index]["total"]);
                              final e =
                                  double?.tryParse(data![index]["quantityAdd"]);
                              final f =
                                  double?.tryParse(data![index]["total2"]);
                              return DataRow(cells: [
                                DataCell(Container(child: Text(b))),
                                DataCell(Container(child: Text("$c"))),
                                DataCell(Container(child: Text("$d"))),
                                DataCell(Container(child: Text("$e"))),
                                DataCell(Container(child: Text("$f"))),
                              ]);
                            }),
                          ),
                        ],
                      )
                    : Center(child: Text("لا يوجد بيانات")),
              ),
            ),
          ],
        ),
      ),
    );
  }
  ///end update 30/6/2023///
}
