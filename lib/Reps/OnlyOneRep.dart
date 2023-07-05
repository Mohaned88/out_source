///10-6-2023

import 'package:flutter/services.dart';

import 'package:flutter/material.dart';

import '../resources/colors.dart';

class OnlyOneRepShow extends StatefulWidget {
  OnlyOneRepShow({Key? key, required this.data}) : super(key: key);
  List data;

  @override
  State<OnlyOneRepShow> createState() => _OnlyOneRepShowState();
}

class _OnlyOneRepShowState extends State<OnlyOneRepShow> {
  List data = [];

  @override
  void initState() {
    data = widget.data;
    super.initState();
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
            "عملاء الصنف الواحد",
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'GE SS Two',
              color: Colors.white,
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: w * 0.1,
                  headingRowColor: MaterialStateProperty.all<Color>(
                    AppColors.mainColor.withOpacity(0.3),
                  ),
                  border: TableBorder.all(),
                  columns: [
                    DataColumn(label: Text('اسم العميل')),
                    DataColumn(label: Text('اسم الصنف')),
                    DataColumn(label: Text('الكمية المأخوذه')),
                  ],
                  rows: List.generate(data.length, (index) {
                    final b = data[index]["customerName"];
                    final d = data[index]["itemName"];
                    final c = double?.tryParse(data[index]["quantityTake"]);
                    return DataRow(cells: [
                      DataCell(Container(child: Text(b))),
                      DataCell(Container(child: Text("$d"))),
                      DataCell(Container(child: Text("$c"))),
                    ]);
                  }),
                ),
              ),
            ),
            Container(
              height: w * 0.1,
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                border: Border.all(
                  color: Colors.black,
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(
                      'اجمالي عدد العملاء',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'GE SS Two',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  VerticalDivider(
                    color: Colors.black,
                    thickness: 1.2,
                  ),
                  Expanded(
                    child: Text(
                      "${data.length}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'GE SS Two',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ///end update 1/7/2023///
}
