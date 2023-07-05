import 'dart:convert';

import 'package:dy_app/resources/colors.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'DeneralDailyRep.dart';

class IndebtednessRepShow extends StatefulWidget {
  IndebtednessRepShow({Key? key, required this.data}) : super(key: key);
  List data;

  @override
  State<IndebtednessRepShow> createState() => _IndebtednessRepShowState();
}

class _IndebtednessRepShowState extends State<IndebtednessRepShow> {
  List data = [];

  @override
  void initState() {
    data = widget.data;
    super.initState();
  }

  @override
  // Calculate the total values for each column
  Widget build(BuildContext context) {
    // Calculate the total values for each column
    final totalCreditor = data.fold<double>(
            0,
            (previous, current) =>
                previous +
                (double.tryParse(current["totalCreditor"]) ?? 0.0)) ??
        0;
    final totalDebtor = data.fold<double>(
            0,
            (previous, current) =>
                previous + (double.tryParse(current["totalDebtor"]) ?? 0.0)) ??
        0;
    final totalNet = data.fold<double>(
            0,
            (previous, current) =>
                previous +
                ((double.tryParse(current["totalCreditor"]) ?? 0.0) -
                    (double.tryParse(current["totalDebtor"]) ?? 0.0))) ??
        0;

    ///update 30/6/2023///
    var w = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          title: Text(
            'مديونيات عملاء المندوب',
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'GE SS Two',
              color: Colors.white,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      border: TableBorder.all(),
                      columnSpacing: w * 0.4,
                      columns: [
                        DataColumn(
                          label: Text(
                            'العميل',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'الصافي',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                      headingRowColor: MaterialStateProperty.all<Color>(
                        AppColors.mainColor.withOpacity(0.3),
                      ),
                      rows: List.generate(
                        data.length,
                        (index) {
                          final c = data[index]["customerName"];
                          final x =
                              double.tryParse(data[index]["totalCreditor"])! -
                                  double.tryParse(data[index]["totalDebtor"])!;
                          return DataRow(
                            cells: [
                              DataCell(
                                GestureDetector(
                                  onTap: () async {
                                    String tag = data[index]["orgId"];

                                    final String url =
                                        "http://sales.dynamicsdb2.com/api/GeneralDailyReport/$tag";
                                    var response = await http.get(
                                      Uri.parse(url),
                                      headers: {"Accept": "application/json"},
                                    );
                                    if (response.statusCode == 200) {
                                      print("Saving Data ");
                                      print(response.body);
                                    } else {
                                      print(response.statusCode);
                                    }

                                    List jsonResponse =
                                        jsonDecode(response.body);

                                    print("get Report");
                                    print(jsonResponse);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => GeneralDailyRepShow(
                                          title: c,
                                          data: jsonResponse,
                                        ),
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      c,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    "${x.toStringAsFixed(2)}",
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  border: Border.all(
                    width: 1.2,
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(w * 0.02),
                    topLeft: Radius.circular(w * 0.02),
                  ),
                ),
                height: w * 0.13,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'الإجمالي',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    VerticalDivider(
                      color: Colors.black,
                      thickness: 1.2,
                    ),
                    Text(
                      totalNet.toStringAsFixed(2),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
    ///end update 30/6/2023///
  }
}
