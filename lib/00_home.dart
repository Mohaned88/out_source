import 'dart:async';
import 'dart:convert';

import 'package:dy_app/billShows.dart';
import 'package:dy_app/components/send_and_receive_comp.dart';
import 'package:dy_app/databasehelper.dart';
import 'package:dy_app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'DailySafeDate.dart';
import 'bill.dart';
import 'cashIn.dart';
import 'dailySafe.dart';
import '01_mandoub_info.dart';
import 'Reps/reports.dart';
import 'results.dart';
import 'syncronize.dart';

// ignore: must_be_immutable
class Login extends StatefulWidget {
  Login({Key? key, required this.value, required this.personid})
      : super(key: key);
  String value;
  int personid;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final conn = SqfliteDatabaseHelper.instance;
  Timer? _timer;
  String? Code;

  Future syncToMysqlBills() async {
    await SyncronizationData().fetchAllBills().then((billList) async {
      EasyLoading.show(status: 'Don`t close app. we are sync...');
      await SyncronizationData().saveToMysqlBillsWith(billList);
      EasyLoading.showSuccess('Successfully save to mysql');
    });
  }

  Future syncToMysqlBillsDet() async {
    await SyncronizationData().fetchAllBillsDet().then((billDetList) async {
      EasyLoading.show(status: 'Don`t close app. we are sync...');
      await SyncronizationData().saveToMysqlBillDetWith(billDetList);
      EasyLoading.showSuccess('Successfully save to mysql');
    });
  }

  Future syncToMysqlCash() async {
    await SyncronizationData().fetchAllCashIns().then((cashList) async {
      EasyLoading.show(status: 'من فضلك لا تغلق التطبيق جاري رفع البيانات');
      await SyncronizationData().saveToMysqlCashWith(cashList);
      EasyLoading.showSuccess('تم ارسال التوريدات الي الاون لاين');
    });
  }

  Future syncToMysqlCashDet() async {
    await SyncronizationData().fetchAllCashInDet().then((billList) async {
      EasyLoading.show(status: 'من فضلك لا تغلق التطبيق جاري رفع البيانات');
      await SyncronizationData().saveToMysqlCashDetWith(billList);
      EasyLoading.showSuccess('تم ارسال التوريدات الي الاون لاين');
    });
  }

  Future isInteret() async {
    await SyncronizationData.isInternet().then((connection) {
      if (connection) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Internet connection available")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("No Internet")));
      }
    });
  }

  Future fetchSyncItemsData() async {
    var dbclient = await conn.db;
    List itemList = [];
    try {
      List<Map<String, dynamic>> maps =
          await dbclient.rawQuery('select * from Items');
      for (var item in maps) {
        itemList.add(item);
      }
      if (itemList.isEmpty) {
        await SyncronizationData().GetAllItemsAndSaveSQlite().then((_) async {
          EasyLoading.show(status: 'من فضلك لا تغلق التطبيق حتي يتم التحديث');
          await SyncronizationData().GetAllItemsAndSaveSQlite();
          EasyLoading.showSuccess('تم التحديث !!  ');
        });
      } else {
        dbclient.rawQuery("delete from items").then((value) {
          SyncronizationData().GetAllItemsAndSaveSQlite().then((_) async {
            EasyLoading.show(status: 'من فضلك لا تغلق التطبيق حتي يتم التحديث')
                .then((value) => SyncronizationData()
                    .GetAllItemsAndSaveSQlite()
                    .then(
                        (value) => EasyLoading.showSuccess('تم التحديث !!  ')));
          });
        });
      }
    } catch (e) {
      print(e.toString());
    }
    print("get items done");
    print(itemList);
    return itemList;
  }

  late List<dynamic> newData;

  Future fetchSyncTVData() async {
    var dbclient = await conn.db;
    List itemList = [];
    try {
      List<Map<String, dynamic>> maps = await dbclient
          .rawQuery('select * from Organizations  where Mandoub1 = "$Code"');
      for (var item in maps) {
        itemList.add(item);
      }
      if (itemList.isEmpty) {
        await SyncronizationData().GetAllTVAndSaveSQlite(Code).then((_) async {
          EasyLoading.showSuccess(
              'من فضلك لا تغلق التطبيق حتي يتم التحديث قد يستغرق بعض الوقت');
          await SyncronizationData().GetAllItemsAndSaveSQlite();
          EasyLoading.showSuccess('تم التحديث !!  ');
        });
      } else {
        dbclient.rawQuery("delete from Organizations").then((value) {
          SyncronizationData().GetAllTVAndSaveSQlite(Code).then((_) async {
            EasyLoading.showSuccess(
                    'من فضلك لا تغلق التطبيق حتي يتم التحديث قد يستغرق بعض الوقت')
                .then(
                    (value) => SyncronizationData().GetAllItemsAndSaveSQlite())
                .then((value) => EasyLoading.showSuccess('تم التحديث !!  '));
          });
        });
      }
    } catch (e) {
      print(e.toString());
    }
    print("get items done");
    print(itemList);
    return itemList;
  }

  @override
  void initState() {
    isInteret();
    newData = (json.decode(widget.value));
    print("in login");
    print(newData[0]["PersonName"]);
    Code = newData[0]["Mandoubtag"].toString();

    print(Code);
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        toolbarHeight: w * 0.2,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(w * 0.1),
            bottomLeft: Radius.circular(w * 0.1),
          ),
        ),
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => Info(InfoList: newData),
              ),
            );
          },
          child: Text("مرحبا أ/ ${newData[0]["PersonName"]} ",
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'GE SS Two',
              )),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: w * 0.05),
            child: CircleAvatar(
              backgroundColor: Colors.green.withOpacity(0.8),
              radius: w * 0.06,
              child: Center(
                child: Text(
                  '${newData[0]["PersonName"].toString().split(' ')[0].split('')[0]}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Container(
        /*decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.center,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.blueGrey],
          ),
        ),*/
        padding: EdgeInsets.symmetric(horizontal: w * 0.02),
        child: ListView(
          children: [
/*            GestureDetector(
              onTap: () async {},
              /////////////////////////////////////////////////////////////
              child: Container(
                width: MediaQuery.of(context).size.width * .2,
                height: MediaQuery.of(context).size.height * .3,
                child: Image.asset("assets/images/mand.jpg"),
              ),
            ),*/
            SizedBox(height: w * 0.02),
            Text(
              "التحديثات",
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'GE SS Two',
              ),
            ),
            SizedBox(height: w * 0.02),
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SendAndReceiveComp(
                    color: Colors.amber,
                    imagePath: 'assets/images/transaction_icon.png',
                    text: 'ارسال المعاملات',
                    onTap: () async {
                      await SyncronizationData.isInternet().then(
                        (connection) {
                          if (connection) {
                            //syncToMysql();
                            syncToMysqlBillsDet();
                            syncToMysqlBills();

                            print("Internet connection available");
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("No Internet"),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                  SendAndReceiveComp(
                    color: Colors.green,
                    imagePath: 'assets/images/supplies_icon.png',
                    text: 'ارسال التوريدات',
                    onTap: () async {
                      await SyncronizationData.isInternet().then((connection) {
                        if (connection) {
                          syncToMysqlCash();
                          syncToMysqlCashDet();

                          print("Internet connection available");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("No Internet")));
                        }
                      });
                    },
                  ),
                  SendAndReceiveComp(
                    color: Colors.red,
                    imagePath: 'assets/images/file_download_icon.png',
                    text: 'استقبال الحسابات',
                    onTap: () {
                      fetchSyncTVData();
                    },
                  ),
                  SendAndReceiveComp(
                    color: Colors.blue,
                    imagePath: 'assets/images/category_download_icon.png',
                    text: 'استقبال الأصناف',
                    onTap: () {
                      fetchSyncItemsData();
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: w * 0.02),
            Text(
              "الخدمات",
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'GE SS Two',
              ),
            ),
            SizedBox(height: w * 0.02),
            /*Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    await SyncronizationData.isInternet().then(
                      (connection) {
                        if (connection) {
                          //syncToMysql();
                          syncToMysqlBillsDet();
                          syncToMysqlBills();

                          print("Internet connection available");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("No Internet"),
                            ),
                          );
                        }
                      },
                    );
                  },
                  child: Text(
                    "ارسال المعاملات الي الاون لاين  ",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'GE SS Two',
                    ),
                  ),
                ),
             GestureDetector(
                    child: Text(
                      "ارسال التوريدات الي الاون لاين  ",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GE SS Two',
                      ),
                    ),
                    onTap: () async {
                      await SyncronizationData.isInternet().then((connection) {
                        if (connection) {
                          syncToMysqlCash();
                          syncToMysqlCashDet();

                          print("Internet connection available");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("No Internet")));
                        }
                      });
                    }),
                Container(
                  width: MediaQuery.of(context).size.width * .9,
                  child: ElevatedButton(
                    onPressed: () {
                      fetchSyncItemsData();
                    },
                    child: Text(
                      "تحديث واستقبال بيانات الاصناف الاون لاين ",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.cyan,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GE SS Two',
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .9,
                  child: ElevatedButton(
                    onPressed: () {
                      fetchSyncTVData();
                    },
                    child: Text(
                      "تحديث واستقبال بيانات الدليل الاون لاين ",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GE SS Two',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .1,
            ),*/
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              childAspectRatio: 9 / 11,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Bill()));
                    },
                    child: Container(
                      //decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage("assets/images/1.jpg"))),
                            height: w * 0.18,
                            width: w * 0.18,
                          ),
                          Text(
                            "فواتير \n البيع",
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'GE SS Two',
                            ),
                          ),
                        ],
                      ),
                      //color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BillShows()));
                    },
                    child: Container(
                      //decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: w * 0.18,
                            height: w * 0.18,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage("assets/images/bill.jpg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            // child: Image.asset("assets/images/bill.jpg"),
                          ),
                          Text(
                            "استعراض \n الفواتير",
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'GE SS Two',
                            ),
                          ),
                        ],
                      ),
                      //color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CashIn()));
                    },
                    child: Container(
                      // decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  "assets/images/cash.jpg",
                                ),
                              ),
                            ),
                           width: w*0.18,
                            height: w*0.18,
                          ),
                          Text(
                            "توريدات \n نقديه",
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'GE SS Two',
                            ),
                          ),
                        ],
                      ),
                      //color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Reports()));
                    },
                    child: Container(
                      // decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        "assets/images/report.jpg"))),
                            width: w*0.18,
                            height: w*0.18,
                          ),
                          Text(
                            "تقارير \n ",
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'GE SS Two',
                            ),
                          ),
                        ],
                      ),
                      //color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Results()));
                    },
                    child: Container(
                      // decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        "assets/images/target.jpg"))),
                            width: w*0.18,
                            height: w*0.18,
                          ),
                          Text(
                            "مستهدف \n المندوب",
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'GE SS Two',
                            ),
                          ),
                        ],
                      ),
                      //color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const dailySafeDate()));
                    },
                    child: Container(
                      // decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        AssetImage("assets/images/pay.jpg"))),
                            width: w*0.18,
                            height: w*0.18,
                          ),
                          Text(
                            "تحصيلات \n اليوم ",
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'GE SS Two',
                            ),
                          ),
                        ],
                      ),
                      //color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
