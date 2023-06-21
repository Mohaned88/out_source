import 'dart:async';
import 'dart:convert';

import 'package:dy_app/billShows.dart';
import 'package:dy_app/components/send_and_receive_comp.dart';
import 'package:dy_app/databasehelper.dart';
import 'package:dy_app/register.dart';
import 'package:dy_app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:url_launcher/url_launcher.dart';
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
      setState(() {
        _isButtonDisabledBill = false;
      });
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
      setState(() {
        _isButtonDisabledCash = false;
      });
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

  ////////////////10-6-2023

  bool _isButtonDisabledItem = false;
  bool _isButtonDisabledTV = false;
  bool _isButtonDisabledCash = false;
  bool _isButtonDisabledBill = false;

  void _handleButtonTapItem() {
    if (!_isButtonDisabledItem) {
      setState(() {
        _isButtonDisabledItem = true;
      });
      fetchSyncItemsData();
      /*Future.delayed(Duration(seconds: 5), () {
        setState(() {
          _isButtonDisabledItem = false;
        });
      });*/
    }
  }


  void _handleButtonTapTV() {
    if (!_isButtonDisabledTV) {
      setState(() {
        _isButtonDisabledTV = true;
      });
      fetchSyncTVData();
     /* Future.delayed(Duration(seconds: 5), () {
        setState(() {
          _isButtonDisabledTV = false;
        });
      });*/
    }
  }

  void _handleButtonTapCash() async {
    if (!_isButtonDisabledCash) {
      setState(() {
        _isButtonDisabledCash = true;
      });
      await SyncronizationData.isInternet().then((connection) {
        if (connection) {
          syncToMysqlCash();
          syncToMysqlCashDet();

          print("Internet connection available");
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("No Internet")));
        }
      });
      /*Future.delayed(Duration(seconds: 5), () {
        setState(() {
          _isButtonDisabledCash = false;
        });
      });*/
    }
  }

  void _handleButtonTapBill() async {
    if (!_isButtonDisabledBill) {
      setState(() {
        _isButtonDisabledBill = true;
      });
      await SyncronizationData.isInternet().then((connection) {
        if (connection) {
          syncToMysqlBillsDet();
          syncToMysqlBills();

          print("Internet connection available");
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("No Internet")));
        }
      });
      /*Future.delayed(Duration(seconds: 5), () {
        setState(() {
          _isButtonDisabledBill = false;
        });
      });*/
    }
  }

  ////////////////////////////

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
          setState(() {
            _isButtonDisabledItem = false;
          });
        });
      } else {
        dbclient.rawQuery("delete from items").then(
          (value) {
            SyncronizationData().GetAllItemsAndSaveSQlite().then(
              (_) async {
                EasyLoading.show(
                        status: 'من فضلك لا تغلق التطبيق حتي يتم التحديث')
                    .then(
                  (value) =>
                      SyncronizationData().GetAllItemsAndSaveSQlite().then(
                    (value) {
                      EasyLoading.showSuccess('تم التحديث !!  ');
                      setState(
                        () {
                          _isButtonDisabledItem = false;
                        },
                      );
                    },
                  ),
                );
              },
            );
          },
        );
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
          setState(() {
            _isButtonDisabledTV = false;
          });
        });
      } else {
        dbclient.rawQuery("delete from Organizations").then((value) {
          SyncronizationData().GetAllTVAndSaveSQlite(Code).then((_) async {
            EasyLoading.showSuccess(
                    'من فضلك لا تغلق التطبيق حتي يتم التحديث قد يستغرق بعض الوقت')
                .then(
                    (value) => SyncronizationData().GetAllItemsAndSaveSQlite())
                .then((value){
                  EasyLoading.showSuccess('تم التحديث !!  ');
                  setState(() {
                    _isButtonDisabledTV = false;
                  });
                });
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.kMainColor,
        toolbarHeight: w * 0.2,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(w * 0.1),
            bottomLeft: Radius.circular(w * 0.1),
          ),
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: w * 0.04),
          child: Container(
            width: w * 0.12,
            height: w * 0.12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/customer_logo/clogo.jpg',
                ),
              ),
            ),
          ),
        ),
        leadingWidth: w * 0.18,
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => Info(InfoList: newData),
              ),
            );
          },
          child: Text(
            "مرحبا أ/ ${newData[0]["Username"]} ",
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'GE SS Two',
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: w * 0.05),
            child: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const Reg(),
                  ),
                );
              },
              icon: Image.asset(
                'assets/images/logout.png',
                color: Colors.white,
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: w * 0.02),
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
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
                      status: _isButtonDisabledBill,
                      onTap: () async {
                        _handleButtonTapBill();
                      },
                    ),
                    SendAndReceiveComp(
                      color: Colors.green,
                      imagePath: 'assets/images/supplies_icon.png',
                      text: 'ارسال التوريدات',
                      status: _isButtonDisabledCash,
                      onTap: (){
                        _handleButtonTapCash();
                      },
                    ),

                    SendAndReceiveComp(
                      color: Colors.red,
                      imagePath: 'assets/images/file_download_icon.png',
                      text: 'استقبال الحسابات',
                      status: _isButtonDisabledTV,
                      onTap: () {
                        _handleButtonTapTV();
                       // fetchSyncTVData();
                      },
                    ),
                    SendAndReceiveComp(
                            color: Colors.blue,
                            imagePath:
                                'assets/images/category_download_icon.png',
                            text: 'استقبال الأصناف',
                            onTap: () {
                              _handleButtonTapItem();
                            },
                          status: _isButtonDisabledItem,
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
              SizedBox(height: w * 0.01),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                childAspectRatio: 9 / 10,
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
                              width: w * 0.17,
                              height: w * 0.17,
                              padding: EdgeInsets.all(w * 0.02),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blueGrey.withOpacity(0.2),
                              ),
                              child: Image.asset(
                                'assets/images/new/1.jpg',
                                width: 0.1,
                                height: 0.1,
                                color: Colors.indigo,
                                fit: BoxFit.contain,
                              ),
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
                              width: w * 0.17,
                              height: w * 0.17,
                              padding: EdgeInsets.all(w * 0.02),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blueGrey.withOpacity(0.2),
                              ),
                              child: Image.asset(
                                'assets/images/new/bill2.jpg',
                                width: 0.1,
                                height: 0.1,
                                color: Colors.indigo,
                                fit: BoxFit.contain,
                              ),
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
                              width: w * 0.17,
                              height: w * 0.17,
                              padding: EdgeInsets.all(w * 0.02),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blueGrey.withOpacity(0.2),
                              ),
                              child: Image.asset(
                                'assets/images/new/cash.jpg',
                                width: 0.1,
                                height: 0.1,
                                color: Colors.indigo,
                                fit: BoxFit.contain,
                              ),
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
                              width: w * 0.17,
                              height: w * 0.17,
                              padding: EdgeInsets.all(w * 0.02),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blueGrey.withOpacity(0.2),
                              ),
                              child: Image.asset(
                                'assets/images/new/report.jpg',
                                width: 0.1,
                                height: 0.1,
                                color: Colors.indigo,
                                fit: BoxFit.contain,
                              ),
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
                              width: w * 0.17,
                              height: w * 0.17,
                              padding: EdgeInsets.all(w * 0.02),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blueGrey.withOpacity(0.2),
                              ),
                              child: Image.asset(
                                'assets/images/new/target.jpg',
                                width: 0.1,
                                height: 0.1,
                                color: Colors.indigo,
                                fit: BoxFit.contain,
                              ),
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
                              width: w * 0.17,
                              height: w * 0.17,
                              padding: EdgeInsets.all(w * 0.02),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blueGrey.withOpacity(0.2),
                              ),
                              child: Image.asset(
                                'assets/images/new/pay.jpg',
                                width: 0.1,
                                height: 0.1,
                                color: Colors.indigo,
                                fit: BoxFit.contain,
                              ),
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
              ),
              SizedBox(height: w * 0.03),
              InkWell(
                onTap: () {
                  _launchUrl('dynamics-system.com');
                },
                child: Image.asset(
                  'assets/images/full_logo.png',
                  fit: BoxFit.contain,
                  width: w * 0.2,
                  height: w * 0.17,
                ),
              ),
              Center(child: Text("Update 21-6-2023" ,style: TextStyle(fontSize: 10,),),),
            ],
          ),
        ),
      ),
    );
  }

  //external web site
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri(scheme: 'http', host: url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $uri');
    }
  }
}
