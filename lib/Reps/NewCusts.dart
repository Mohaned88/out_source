///10-6-2023

import 'package:flutter/services.dart';

import 'package:flutter/material.dart';

import '../resources/colors.dart';

class NewCustsRepShow extends StatefulWidget {
  NewCustsRepShow({Key? key,required this.data}) : super(key: key);
  List data;
  @override
  State<NewCustsRepShow> createState() => _NewCustsRepShowState();
}

class _NewCustsRepShowState extends State<NewCustsRepShow> {

  List data = [];

  @override
  void initState() {
    data = widget.data;
    print("after");
    print(data);
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
            "العملاء الجدد",
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
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columnSpacing: w * 0.1,
                      headingRowColor: MaterialStateProperty.all<Color>(
                        AppColors.mainColor.withOpacity(0.3),
                      ),
                      border: TableBorder.all(),
                      columns: [
                        DataColumn(label: Text('كود العميل')),
                        DataColumn(label: Text('اسم العميل')),
                        DataColumn(label: Text('عنوان العميل')),
                        DataColumn(label: Text('تليفون العميل')),
                      ],
                      rows: List.generate(data.length, (index) {
                        final b = data[index]["customerTag"];
                        final d = data[index]["customerName"];
                        final address = data[index]["address"];
                        final mobile = data[index]["mobile"];
                        return DataRow(cells: [
                          DataCell(Container(child: Text(b))),
                          DataCell(Container(child: Text("$d"))),
                          DataCell(Container(child: Text("$address"))),
                          DataCell(Container(child: Text("$mobile"))),
                        ]);
                      }),
                    ),
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
                        thickness: 2,
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
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
  ///end update 1/7/2023///
}
