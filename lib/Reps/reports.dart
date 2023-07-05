///update 1/7/2023///

import 'dart:convert';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:dy_app/Reps/Mas7obatRep2.dart';
import 'package:dy_app/components/link_preview_comp.dart';
import 'package:dy_app/resources/colors.dart';
import 'package:dy_app/resources/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../databasehelper.dart';
import '../resources/assets.dart';
import 'DeneralDailyRep.dart';
import 'GeneralDailyRep2.dart';
import 'IndebtednessRep.dart';
import 'GeneralSafeRep.dart';
import 'InventoryRep.dart';
import 'ItemLogs.dart';
import 'ItemsLog2.dart';
import 'Mas7obatRep.dart';
import 'NewCusts.dart';
import 'OnlyOneRep.dart';
import 'disContCustRepShow.dart';

class Reports extends StatefulWidget {
  const Reports({Key? key}) : super(key: key);

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  String? _mySelection;
  String? _mySelection1;
  String? _mySelectionItem;
  List data = [];
  List list2 = [];
  final conn = SqfliteDatabaseHelper.instance;

  var ItemCode;

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

  double? tag;

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
      data = ff;
      _mySelection = data[0]["org_ID"].toString();
      _mySelection1 = data[0]["org_ID"].toString();
    });
    print(data);
    return data;
  }

  @override
  void initState() {
    itemList().then((value) {
      _mySelectionItem = value![0]["Item_Name"];
    });

    getSWData().then(
      (value) {
        // setState(data = value);
        _mySelection = value![0]['org_ID'].toString();
        _mySelection1 = value![0]['org_ID'].toString();
      },
    );

    super.initState();
  }

  Future GetAllMas7obatData() async {
    final prefs = await SharedPreferences.getInstance();
    final String url =
        "${AppConstants.mainApiLink}/api/Mas7obat/$_mySelection1";
    var response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      print("Saving Data ");
      print(response.body);
    } else {
      print(response.statusCode);
    }

    List jsonResponse = jsonDecode(response.body);

    print("get Report");
    print(jsonResponse);

    return jsonResponse;
  }

  Future GetAllIndebtednessData() async {
    final prefs = await SharedPreferences.getInstance();
    double? tag = prefs.getDouble("tag");
    int? tagx = tag?.toInt();
    final String url = "${AppConstants.mainApiLink}/api/Indebtedness/$tagx";
    var response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      print("Saving Data ");
      print(response.body);
    } else {
      print(response.statusCode);
    }

    List jsonResponse = jsonDecode(response.body);

    print("get Report");
    print(jsonResponse);

    return jsonResponse;
  }

  Future GetItemLog() async {
    final prefs = await SharedPreferences.getInstance();
    int? store = prefs.getInt("store");

    final String url =
        "${AppConstants.mainApiLink}/api/TransLogReport?ItemID=$ItemCode&storeID=$store";
    var response = await http
        .post(Uri.parse(url), headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      print("Saving Data ");
      print(response.body);
    } else {
      print(response.statusCode);
    }

    String jsonResponse = jsonDecode(response.body);
    print("get Report");
    print(jsonResponse);

    return jsonResponse;
  }

  ///
  Future GetGeneralDailyData() async {
    final String url =
        "${AppConstants.mainApiLink}/api/GeneralDailyReport/$_mySelection";
    var response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      print("Saving Data ");
      print(response.body);
    } else {
      print(response.statusCode);
    }

    List jsonResponse = jsonDecode(response.body);

    print("get Report");
    print(jsonResponse);

    return jsonResponse;
  }

  Future OnlyOne() async {
    final prefs = await SharedPreferences.getInstance();
    double? tag = prefs.getDouble("tag");
    int? tagx = tag?.toInt();
    final String url = "${AppConstants.mainApiLink}/api/OnlyOne/$tagx";
    var response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      print("Saving Data ");
      print(response.body);
    } else {
      print(response.statusCode);
    }

    List jsonResponse = jsonDecode(response.body);

    print("get Report");
    print(jsonResponse);

    return jsonResponse;
  }

  Future DisContCust() async {
    final prefs = await SharedPreferences.getInstance();
    double? tag = prefs.getDouble("tag");
    int? tagx = tag?.toInt();
    final String url = "${AppConstants.mainApiLink}/api/DisContCust/$tagx";
    var response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      print("Saving Data ");
      print(response.body);
    } else {
      print(response.statusCode);
    }

    List jsonResponse = jsonDecode(response.body);

    print("get Report");
    print(jsonResponse);

    return jsonResponse;
  }

  Future NewCusts() async {
    final prefs = await SharedPreferences.getInstance();
    double? tag = prefs.getDouble("tag");
    int? tagx = tag?.toInt();
    final String url = "${AppConstants.mainApiLink}/api/NewCusts/$tagx";
    var response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      print("Saving Data ");
      print(response.body);
    } else {
      print(response.statusCode);
    }

    List jsonResponse = jsonDecode(response.body);

    print("get Report");
    print(jsonResponse);

    return jsonResponse;
  }

  Future Inventory() async {
    final prefs = await SharedPreferences.getInstance();
    int? storeId = prefs.getInt("store");
    print(storeId);
    final String url = "${AppConstants.mainApiLink}/api/Inventory/$storeId";
    var response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      print("Saving Data ");
      print(response.body);
    } else {
      print(response.statusCode);
    }

    List jsonResponse = jsonDecode(response.body);

    print("get Report");
    print(jsonResponse);

    return jsonResponse;
  }

  Future GeneralSafe() async {
    final prefs = await SharedPreferences.getInstance();
    double? tag = prefs.getDouble("safe_tag");
    int? tagx = tag?.toInt();
    final String url =
        "${AppConstants.mainApiLink}/api/GeneralDailyReport/$tagx";
    var response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      print("Saving Data ");
      print(response.body);
    } else {
      print(response.statusCode);
    }

    List jsonResponse = jsonDecode(response.body);

    print("get Report");
    print(jsonResponse);

    return jsonResponse;
  }


  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(w * 0.1),
              bottomLeft: Radius.circular(w * 0.1),
            ),
          ),
          title: Text(
            "التقارير",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'GE SS Two',
              color: Colors.white,
            ),
          ),
        ),
        body:ListView(
          children: [
            //تعديل
            LinkPreviewComp(
              title:  "تقرير حركه صنف",
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ItemsLog()));
              },
              iconPath: AppAssets.repsIcon[0],
            ),
            //تعديل
            LinkPreviewComp(
              title:   "مسحوبات",
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => Mas7obatRepShow2()));
              },
              iconPath: AppAssets.repsIcon[1],
            ),
            //تعديل
            LinkPreviewComp(
              title:   "مديونيات عملاء المندوب",
              onTap: () {
                GetAllIndebtednessData().then((value) {
                  print(value);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              IndebtednessRepShow(data: value)));
                });
              },
              iconPath: AppAssets.repsIcon[2],
            ),
            //تعديل
            LinkPreviewComp(
              title:   "تفاصيل معاملات عميل محدد",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => GeneralDailyShow()));
              },
              iconPath: AppAssets.repsIcon[3],
            ),
            //تعديل
            LinkPreviewComp(
              title:   "عملاء الصنف الواحد",
              onTap: () {
                OnlyOne().then((value) {
                  print(value);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => OnlyOneRepShow(data: value)));
                });
              },
              iconPath: AppAssets.repsIcon[4],
            ),
            //تعديل
            LinkPreviewComp(
              title:"العملاء المنقطعين",
              onTap: () {
                DisContCust().then((value) {
                  print(value);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              DisContCustRepShow(data: value)));
                });
              },
              iconPath: AppAssets.repsIcon[5],
            ),
            //تعديل
            LinkPreviewComp(
              title: "العملاء الجدد",
              onTap: () {
                NewCusts().then((value) {
                  print(value);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => NewCustsRepShow(data: value)));
                });
              },
              iconPath: AppAssets.repsIcon[6],
            ),
            //تعديل
            LinkPreviewComp(
              title: "اصناف مخزن المندوب",
              onTap: () {
                Inventory().then((value) {
                  print(value);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => InventoryRepShow(data: value)));
                });
              },
              iconPath: AppAssets.repsIcon[7],
            ),
            //تعديل
            LinkPreviewComp(
              title: "خزينة المندوب",
              onTap: () {
                GeneralSafe().then((value) {
                  print(value);
                  if (value != null || value != []) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                GeneralSafeRepShow(data: value)));
                  }
                });
              },
              iconPath: AppAssets.repsIcon[8],
            ),
          ],
        ),
      ),
    );
  }
  ///end update 1/7/2023///
}
