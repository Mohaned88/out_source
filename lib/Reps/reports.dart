
///11-6-2023



import 'dart:convert';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:dy_app/Reps/Mas7obatRep2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../databasehelper.dart';
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
    final String url = "http://sales.dynamicsdb2.com/api/Mas7obat/$_mySelection1";
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
  double? tag  = prefs.getDouble("tag");
     int? tagx    = tag?.toInt();
    final String url = "http://sales.dynamicsdb2.com/api/Indebtedness/$tagx";
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
    int?  store  = prefs.getInt("store");

    final String url = "http://sales.dynamicsdb2.com/api/TransLogReport?ItemID=$ItemCode&storeID=$store";
    var response =
    await http.post(Uri.parse(url), headers: {"Accept": "application/json"});
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

    final String url = "http://sales.dynamicsdb2.com/api/GeneralDailyReport/$_mySelection";
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
    double?  tag  = prefs.getDouble("tag");
    int  ? tagx    = tag?.toInt();
      final String url = "http://sales.dynamicsdb2.com/api/OnlyOne/$tagx";
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
    double?  tag  = prefs.getDouble("tag");
    int  ? tagx    = tag?.toInt();
    final String url = "http://sales.dynamicsdb2.com/api/DisContCust/$tagx";
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
    double?  tag  = prefs.getDouble("tag");
    int  ? tagx    = tag?.toInt();
    final String url = "http://sales.dynamicsdb2.com/api/NewCusts/$tagx";
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
    int?  storeId  = prefs.getInt("store");
    print(storeId);
    final String url = "http://sales.dynamicsdb2.com/api/Inventory/$storeId";
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
    double?  tag  = prefs.getDouble("safe_tag");
    int  ? tagx    = tag?.toInt();
    final String url = "http://sales.dynamicsdb2.com/api/GeneralDailyReport/$tagx";
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
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(onTap:(){
        },child: Text("تقارير",style: TextStyle(color: Colors.white),),),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
  //تعديل
            Container(
              width: MediaQuery.of(context).size.width*1,
              child: GestureDetector(onTap:(){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>ItemsLog()));
              },child: Center(
                child: Text("تقرير حركه صنف"  ,textDirection: TextDirection.rtl,
                  style: (TextStyle(fontWeight: FontWeight.bold, fontSize: 25,color: Colors.amber)),),
              )),
            ),

//تعديل
            Container(
              width: MediaQuery.of(context).size.width*1,
              child: GestureDetector(onTap:(){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>Mas7obatRepShow2()));
              },child: Center(
                child: Text("مسحوبات"  ,textDirection: TextDirection.rtl,
                  style: (TextStyle(fontWeight: FontWeight.bold, fontSize: 25,color: Colors.amber)),),
              )),
            ),

            // Container(
            //   padding: EdgeInsets.all(35),
            //   margin: EdgeInsets.all(20),
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.black, width: 4),
            //     borderRadius: BorderRadius.circular(8),
            //     boxShadow: [
            //       new BoxShadow(color: Colors.green, offset: new Offset(6.0, 6.0),),
            //     ],
            //   ),
            //   width: MediaQuery.of(context).size.width,
            //   height: MediaQuery.of(context).size.height * .26,
            //   child:
            //       Container(
            //
            //         child:
            //             Column(
            //               children: [
            //                 Text(
            //                   "اجمالي مسحوبات عملاء المندوب",
            //                   textDirection: TextDirection.rtl,
            //                   style: (TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            //                 ),
            //                 Container(
            //                     height:MediaQuery.of(context).size.height * .072,
            //                   child: DropdownFormField(
            //                     onEmptyActionPressed: () async {},
            //                     decoration: InputDecoration(
            //                         border: OutlineInputBorder(),
            //                         suffixIcon: Icon(Icons.arrow_drop_down),
            //                         labelText: "عميل"),
            //                     onSaved: (dynamic str) {},
            //                     onChanged: (dynamic str) {print(str["org_ID"]);
            //                     _mySelection1=str["org_ID"].toString();
            //                     ;},
            //                     displayItemFn: (dynamic item) => Text(
            //                       (item ?? {})['orgName'] ?? '',
            //                       style: TextStyle(fontSize: 14),
            //                     ),
            //                     findFn: (dynamic str) async => data,
            //                     selectedFn: (dynamic item1, dynamic item2) {
            //                       if (item1 != null && item2 != null) {
            //                         return item1['orgName'] == item2['orgName'];
            //                       }
            //                       return false;
            //                     },
            //                     filterFn: (dynamic item, str) =>
            //                     item['orgName'].toLowerCase().indexOf(str.toLowerCase()) >= 0,
            //                     dropdownItemFn: (dynamic item, int position, bool focused,
            //                         bool selected, Function() onTap) {
            //                       return ListTile(
            //                         title: Text(item['orgName']),
            //                         subtitle: Text(
            //                           item['org_ID'].toString(),
            //                         ),selected: false,
            //                         tileColor:
            //                         focused ? Color.fromARGB(20, 0, 0, 0) : Colors.transparent,
            //                         onTap: onTap,
            //                       );
            //                     },),
            //                 ),
            //                 ElevatedButton(
            //                     onPressed: () async {
            //                       GetAllMas7obatData().then((value) {
            //                         print("before");
            //                         print(value);
            //                         Navigator.push(context, MaterialPageRoute(builder: (_)=>Mas7obatRepShow(data : value)));
            //                       });
            //                     },
            //                     child: Text("استعراض"))
            //               ],
            //             ),
            //         ),
            // ),



        //details


//             Container(
//               padding: EdgeInsets.all(35),
//               margin: EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.black, width: 4),
//                 borderRadius: BorderRadius.circular(8),
//                 boxShadow: [
//                   new BoxShadow(color: Colors.green, offset: new Offset(6.0, 6.0),),
//                 ],
//               ),
//
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height * .28,
//               child:
//               Container(
//
//                 child:
//                 Column(
//                   children: [
//                     Text(
//                       "حركه صنف",
//                       textDirection: TextDirection.rtl,
//                       style: (TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
//                     ),
//                     DropdownFormField(
//                       onEmptyActionPressed: () async {},
//                       decoration: InputDecoration(
//                           border: OutlineInputBorder(),
//                           suffixIcon: Icon(Icons.arrow_drop_down),
//                           labelText: "صنف"),
//                       onSaved: (dynamic str) {},
//                       onChanged: (dynamic str) {
//                         print(str["Item_Name"]);
//                         print(str["Item_ID"]);
//                         _mySelectionItem = str["Item_Name"];
//                         setState(() {
// ItemCode = str["Item_ID"];
//                         });
//                         ;
//                       },
//                       validator: (dynamic str) {},
//                       displayItemFn: (dynamic item) => Text(
//                         (item ?? {})['Item_Name'] ?? '',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       findFn: (dynamic str) async => list2,
//                       selectedFn: (dynamic item1, dynamic item2) {
//                         if (item1 != null && item2 != null) {
//                           return item1['Item_Name'] == item2['Item_Name'];
//                         }
//                         return false;
//                       },
//                       filterFn: (dynamic item, str) =>
//                       item['Item_Name'].toLowerCase().indexOf(str.toLowerCase()) >= 0,
//                       dropdownItemFn: (dynamic item, int position, bool focused,
//                           bool selected, Function() onTap) {
//                         return ListTile(
//                           title: Text(item['Item_Name']),
//                           subtitle: Text(
//                             item['Item_ID']?.toString() ?? '',
//                           ),
//                           selected: false,
//                           tileColor:
//                           focused ? Color.fromARGB(20, 0, 0, 0) : Colors.transparent,
//                           onTap: onTap,
//                         );
//                       },
//                     ),
//
//                     ElevatedButton(
//                         onPressed: () async {
//                           GetItemLog().then((value) {
//                             print("before");
//                             print(value);
//                             Navigator.push(context, MaterialPageRoute(builder: (_)=>ItemLogShow(data : value)));
//                           });
//                         },
//                         child: Text("استعراض"))
//                   ],
//                 ),
//               ),
//             ),
            //end

//كما هو
            Container(
              width: MediaQuery.of(context).size.width*1,
              child: GestureDetector(onTap:(){
                GetAllIndebtednessData().then((value) {
                  print(value);
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>IndebtednessRepShow(data : value)));
                });
              },child: Center(
                child: Text("مديونيات عملاء المندوب"  ,textDirection: TextDirection.rtl,
                  style: (TextStyle(fontWeight: FontWeight.bold, fontSize: 25,color: Colors.amber)),),
              )),
            ),


//تعديل
            Container(
              width: MediaQuery.of(context).size.width*1,
              child: GestureDetector(onTap:(){
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>GeneralDailyShow()));
              },child: Center(
                child: Text("تفاصيل معاملات عميل محدد"  ,textDirection: TextDirection.rtl,
                  style: (TextStyle(fontWeight: FontWeight.bold, fontSize: 25,color: Colors.amber)),),
              )),
            ),

            //   Container(
          //     padding: EdgeInsets.all(35),
          //     margin: EdgeInsets.all(20),
          //     decoration: BoxDecoration(
          //       border: Border.all(color: Colors.black, width: 4),
          //       borderRadius: BorderRadius.circular(8),
          //       boxShadow: [
          //         new BoxShadow(color: Colors.green, offset: new Offset(6.0, 6.0),),
          //       ],
          //     ),
          // width: MediaQuery.of(context).size.width,
          //     height: MediaQuery.of(context).size.height * .19,
          //     child: Column(
          //       children: [
          //         Text(
          //           "اجمالي مديونيات  كل عملاء المندوب",
          //           textDirection: TextDirection.rtl,
          //           style: (TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          //         ),
          //         ElevatedButton(
          //             onPressed: () async {
          //               GetAllIndebtednessData().then((value) {
          //                 print(value);
          //                 Navigator.push(context, MaterialPageRoute(builder: (_)=>IndebtednessRepShow(data : value)));
          //               });
          //             },
          //             child: Text("استعراض"))
          //       ],
          //     ),
          //   ),


            // Container(
            //   padding: EdgeInsets.all(35),
            //   margin: EdgeInsets.all(20),
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.black, width: 4),
            //     borderRadius: BorderRadius.circular(8),
            //     boxShadow: [
            //       new BoxShadow(color: Colors.green, offset: new Offset(6.0, 6.0),),
            //     ],
            //   ),
            //
            //   width: MediaQuery.of(context).size.width,
            //   height: MediaQuery.of(context).size.height * .27,
            //   child: Column(
            //     children: [
            //       Container(
            //         height:MediaQuery.of(context).size.height * .08,
            //
            //         child:
            //         DropdownFormField(
            //           onEmptyActionPressed: () async {},
            //           decoration: InputDecoration(
            //               border: OutlineInputBorder(),
            //               suffixIcon: Icon(Icons.arrow_drop_down),
            //               labelText: "عميل "),
            //           onSaved: (dynamic str) {},
            //           onChanged: (dynamic str) {print(str["org_ID"]);
            //           _mySelection=str["org_ID"].toString();
            //           ;},
            //
            //
            //           displayItemFn: (dynamic item) => Text(
            //             (item ?? {})['orgName'] ?? '',
            //             style: TextStyle(fontSize: 16),
            //           ),
            //           findFn: (dynamic str) async => data,
            //           selectedFn: (dynamic item1, dynamic item2) {
            //             if (item1 != null && item2 != null) {
            //               return item1['orgName'] == item2['orgName'];
            //             }
            //             return false;
            //           },
            //           filterFn: (dynamic item, str) =>
            //           item['orgName'].toLowerCase().indexOf(str.toLowerCase()) >= 0,
            //           dropdownItemFn: (dynamic item, int position, bool focused,
            //               bool selected, Function() onTap) {
            //
            //             return ListTile(
            //
            //               title: Text(item['orgName']),
            //               subtitle: Text(
            //                 item['org_ID'].toString(),
            //               ),selected: false,
            //
            //               tileColor:
            //               focused ? Color.fromARGB(20, 0, 0, 0) : Colors.transparent,
            //               onTap: onTap,
            //             );
            //           },),
            //       ),
            //       Container(
            //         child: Text(
            //           "تفاصيل معاملات عميل محدد",
            //           textDirection: TextDirection.rtl,
            //           style: (TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            //         ),
            //       ),
            //       Container(
            //         child: ElevatedButton(
            //             onPressed: () async {
            //                 GetGeneralDailyData().then((value) {
            //                   print(value);
            //                   Navigator.push(context, MaterialPageRoute(builder: (_)=>GeneralDailyRepShow(data : value)));
            //                 });
            //
            //
            //             },
            //             child: Text("استعراض")),
            //       )
            //     ],
            //   ),
            // ),

//كما هو
            Container(
              width: MediaQuery.of(context).size.width*1,
              child: GestureDetector(onTap:(){
                OnlyOne().then((value) {
                  print(value);
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>OnlyOneRepShow(data: value)));
                });
              },child: Center(
                child: Text("عملاء الصنف الواحد"  ,textDirection: TextDirection.rtl,
                  style: (TextStyle(fontWeight: FontWeight.bold, fontSize: 25,color: Colors.amber)),),
              )),
            ),
//كما هو
            // Container(
            //   padding: EdgeInsets.all(35),
            //   margin: EdgeInsets.all(20),
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.black, width: 4),
            //     borderRadius: BorderRadius.circular(8),
            //     boxShadow: [
            //       new BoxShadow(color: Colors.green, offset: new Offset(6.0, 6.0),),
            //     ],
            //   ),
            //
            //   width: MediaQuery.of(context).size.width,
            //   height: MediaQuery.of(context).size.height * .21,
            //   child: Column(
            //     children: [
            //       Text(
            //         "عملاءالصنف الواحد ",
            //         textDirection: TextDirection.rtl,
            //         style: (TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            //       ),
            //       ElevatedButton(
            //           onPressed: () async {
            //             OnlyOne().then((value) {
            //               print(value);
            //               Navigator.push(context, MaterialPageRoute(builder: (_)=>OnlyOneRepShow(data : value)));
            //             });
            //           },
            //           child: Text("استعراض"))
            //     ],
            //   ),
            // ),
            Container(
              width: MediaQuery.of(context).size.width*1,
              child: GestureDetector(onTap:(){
                DisContCust().then((value) {
                  print(value);
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>DisContCustRepShow(data : value)));
                });
              },child: Center(
                child: Text("العملاء المنقطعين"  ,textDirection: TextDirection.rtl,
                  style: (TextStyle(fontWeight: FontWeight.bold, fontSize: 25,color: Colors.amber)),),
              )),
            ),

            // Container(
            //   padding: EdgeInsets.all(35),
            //   margin: EdgeInsets.all(20),
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.black, width: 4),
            //     borderRadius: BorderRadius.circular(8),
            //     boxShadow: [
            //       new BoxShadow(color: Colors.green, offset: new Offset(6.0, 6.0),),
            //     ],
            //   ),
            //
            //   width: MediaQuery.of(context).size.width,
            //   height: MediaQuery.of(context).size.height * .21,
            //   child: Column(
            //     children: [
            //       Text(
            //         "العملاء المنقطعين ",
            //         textDirection: TextDirection.rtl,
            //         style: (TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            //       ),
            //       ElevatedButton(
            //           onPressed: () async {
            //             DisContCust().then((value) {
            //               print(value);
            //               Navigator.push(context, MaterialPageRoute(builder: (_)=>DisContCustRepShow(data : value)));
            //             });
            //           },
            //           child: Text("استعراض"))
            //     ],
            //   ),
            // ),
//كما هو
            Container(
              width: MediaQuery.of(context).size.width*1,
              child: GestureDetector(onTap:(){
                NewCusts().then((value) {
                  print(value);
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>NewCustsRepShow(data : value)));
                });
              },child: Center(
                child: Text("العملاء الجدد"  ,textDirection: TextDirection.rtl,
                  style: (TextStyle(fontWeight: FontWeight.bold, fontSize: 25,color: Colors.amber)),),
              )),
            ),
            // Container(
            //   padding: EdgeInsets.all(35),
            //   margin: EdgeInsets.all(20),
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.black, width: 4),
            //     borderRadius: BorderRadius.circular(8),
            //     boxShadow: [
            //       new BoxShadow(color: Colors.green, offset: new Offset(6.0, 6.0),),
            //     ],
            //   ),
            //
            //   width: MediaQuery.of(context).size.width,
            //   height: MediaQuery.of(context).size.height * .21,
            //   child: Column(
            //     children: [
            //       Text(
            //         "العملاء الجدد ",
            //         textDirection: TextDirection.rtl,
            //         style: (TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            //       ),
            //       ElevatedButton(
            //           onPressed: () async {
            //             NewCusts().then((value) {
            //               print(value);
            //               Navigator.push(context, MaterialPageRoute(builder: (_)=>NewCustsRepShow(data : value)));
            //             });
            //           },
            //           child: Text("استعراض"))
            //     ],
            //   ),
            // ),
//كما هو
            Container(
              width: MediaQuery.of(context).size.width*1,
              child: GestureDetector(onTap:(){
                Inventory().then((value) {
                  print(value);
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>InventoryRepShow(data : value)));
                });
              },child: Center(
                child: Text("اصناف مخزن المندوب"  ,textDirection: TextDirection.rtl,
                  style: (TextStyle(fontWeight: FontWeight.bold, fontSize: 25,color: Colors.amber)),),
              )),
            ),

            // Container(
            //   padding: EdgeInsets.all(35),
            //   margin: EdgeInsets.all(20),
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.black, width: 4),
            //     borderRadius: BorderRadius.circular(8),
            //     boxShadow: [
            //       new BoxShadow(color: Colors.green, offset: new Offset(6.0, 6.0),),
            //     ],
            //   ),
            //
            //   width: MediaQuery.of(context).size.width,
            //   height: MediaQuery.of(context).size.height * .21,
            //   child: Column(
            //     children: [
            //       Text(
            //         "اصناف مخزن المندوب ",
            //         textDirection: TextDirection.rtl,
            //         style: (TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            //       ),
            //       ElevatedButton(
            //           onPressed: () async {
            //             Inventory().then((value) {
            //               print(value);
            //               Navigator.push(context, MaterialPageRoute(builder: (_)=>InventoryRepShow(data : value)));
            //             });
            //           },
            //           child: Text("استعراض"))
            //     ],
            //   ),
            // ),

            Container(
              width: MediaQuery.of(context).size.width*1,
              child: GestureDetector(onTap:(){
                GeneralSafe().then((value) {

                  print(value);
                  if(value !=null|| value !=[]){ Navigator.push(context, MaterialPageRoute(builder: (_)=>GeneralSafeRepShow(data : value)));
                  }
                });
              },child: Center(
                child: Text("خزينة المندوب"  ,textDirection: TextDirection.rtl,
                  style: (TextStyle(fontWeight: FontWeight.bold, fontSize: 25,color: Colors.amber)),),
              )),
            ),

            // Container(
            //   padding: EdgeInsets.all(35),
            //   margin: EdgeInsets.all(20),
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.black, width: 4),
            //     borderRadius: BorderRadius.circular(8),
            //     boxShadow: [
            //       new BoxShadow(color: Colors.green, offset: new Offset(6.0, 6.0),),
            //     ],
            //   ),
            //
            //   width: MediaQuery.of(context).size.width,
            //   height: MediaQuery.of(context).size.height * .21,
            //   child: Column(
            //     children: [
            //       Text(
            //         "خزينة المندوب ",
            //         textDirection: TextDirection.rtl,
            //         style: (TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            //       ),
            //       ElevatedButton(
            //           onPressed: () async {
            //             GeneralSafe().then((value) {
            //
            //               print(value);
            //               if(value !=null|| value !=[]){ Navigator.push(context, MaterialPageRoute(builder: (_)=>GeneralSafeRepShow(data : value)));
            //               }
            //             });
            //           },
            //           child: Text(" استعراض"))
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
