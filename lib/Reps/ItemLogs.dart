//6-6-2023

import 'dart:convert';
import 'package:flutter/material.dart';

import '../resources/colors.dart';

class ItemLogShow extends StatefulWidget {
  ///update 1/7/2023///
  ItemLogShow({Key? key, required this.data, required this.title})
      : super(key: key);
  String data;
  String title;

  ///end update 1/7/2023///

  @override
  State<ItemLogShow> createState() => _ItemLogShowState();
}

class _ItemLogShowState extends State<ItemLogShow> {
  List data = [];

  @override
  void initState() {
    data = json.decode(widget.data);
    super.initState();
    print(data.length);
  }

  ///update 1/7/2023///
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          title: Text(
            widget.title,
            textDirection: TextDirection.rtl,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'GE SS Two',
              color: Colors.white,
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
                    child: data.length != 1
                        ? DataTable(
                            columnSpacing: w * 0.1,
                            headingRowColor: MaterialStateProperty.all<Color>(
                              AppColors.mainColor.withOpacity(0.3),
                            ),
                            border: TableBorder.all(),
                            columns: [
                              DataColumn(label: Text('نوع')),
                              DataColumn(label: Text('تاريخ')),
                              DataColumn(label: Text('رقم المعامله')),
                              DataColumn(label: Text('العميل')),
                              DataColumn(label: Text('مضاف')),
                              DataColumn(label: Text('مسحوبات')),
                              DataColumn(label: Text('رصيد')),
                            ],
                            rows: List.generate(
                              data.length,
                              (index) {
                                final c =
                                    data[index]["TransType"].toString() ?? 0;
                                final date = data[index]["TransDate"]
                                        .toString()
                                        .substring(0, 10) ??
                                    0;
                                final d =
                                    data[index]["QuantityAdd"].toString() ?? 0;
                                final e =
                                    data[index]["QuantityTake"].toString() ?? 0;
                                final f =
                                    data[index]["TransId"].toString() ?? 0;
                                final tag = data[index]["Tag"].toString() ?? 0;
                                final balance =
                                    data[index]["balance"].toString() ?? 0;
                                return DataRow(
                                  cells: [
                                    DataCell(SizedBox(width: double.infinity, child: Text("$c", textAlign: TextAlign.center,))),
                                    DataCell(SizedBox(width: double.infinity, child: Text("$date", textAlign: TextAlign.center,))),
                                    DataCell(SizedBox(width: double.infinity, child: Text("$f", textAlign: TextAlign.center,))),
                                    DataCell(SizedBox(width: double.infinity, child: Text("$tag", textAlign: TextAlign.center,))),
                                    DataCell(SizedBox(width: double.infinity, child: Text("$d", textAlign: TextAlign.center,))),
                                    DataCell(SizedBox(width: double.infinity, child: Text("$e", textAlign: TextAlign.center,))),
                                    DataCell(SizedBox(width: double.infinity, child: Text("$balance", textAlign: TextAlign.center,))),
                                    //  DataCell(Container( child: Text("$x"))),
                                  ],
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Text(
                              "لا يوجد معاملات",
                              style: TextStyle(fontSize: 25),
                            ),
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

  ///end update 1/7/2023///
}
