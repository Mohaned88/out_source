



import 'dart:convert';

import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../dailySafe.dart';
import '../resources/colors.dart';


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

  ///update 30/6/2023///
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return   Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          title: Text(
            'تفاصيل معاملات عميل محدد',
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
                            GetGeneralDailyData();
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
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: ScrollPhysics(),
                    child: DataTable(
                      border: TableBorder.all(),
                      columnSpacing: w*0.1,
                      headingRowColor: MaterialStateProperty.all<Color>(
                        AppColors.mainColor.withOpacity(0.3),
                      ),
                      columns: [
                        DataColumn(label: Text('الرصيد',textAlign: TextAlign.center,)),
                        DataColumn(label: Text('عليه',textAlign: TextAlign.center,)),
                        DataColumn(label: Text('له',textAlign: TextAlign.center,)),
                        DataColumn(label: Text('تاريخ المعامله',textAlign: TextAlign.center,)),
                        DataColumn(label: Text('شرح المعامله',textAlign: TextAlign.center,)),
                      ],
                      rows: List.generate(data.length, (index) {
                        final b = data[index]["qedId"];
                        final d =data[index]["from"];
                        final e = data[index]["to"];
                        final f = data?[index]["qeddate"].toString().substring(0,10);
                        final g = data[index]["sharh"];
                        final x= double.tryParse(data[index]["balance"].toString())?.round()??0;
                        return DataRow(cells: [
                          DataCell(SizedBox( child: Text("$x"))),
                          DataCell(SizedBox( child: Text("$d"))),
                          DataCell(SizedBox( child: Text("$e"))),
                          DataCell(SizedBox( child: Text("$f"))),
                          DataCell(SizedBox( width: w*0.3, child: Text("$g"))),
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
  ///end update 30/6/2023///
}
