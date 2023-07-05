import 'package:flutter/material.dart';

import '../resources/colors.dart';

class GeneralDailyRepShow extends StatefulWidget {
  ///update 30/6/2023///
  GeneralDailyRepShow({Key? key, required this.data, required this.title,}) : super(key: key);
  List data;
  String title;
  ///end update 30/6/2023///
  @override
  State<GeneralDailyRepShow> createState() => _GeneralDailyRepShowState();
}

class _GeneralDailyRepShowState extends State<GeneralDailyRepShow> {
  List data = [];

  @override
  void initState() {
    data = widget.data;

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
            widget.title,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 20,
              overflow:TextOverflow.ellipsis,
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
                    physics: ScrollPhysics(),
                    child: DataTable(
                      border: TableBorder.all(),
                      columnSpacing: w*0.1,
                      headingRowColor: MaterialStateProperty.all<Color>(
                        AppColors.mainColor.withOpacity(0.3),
                      ),
                      columns: [
                        DataColumn(label: Text('الرصيد')),
                        DataColumn(label: Text('عليه')),
                        DataColumn(label: Text('له')),
                        DataColumn(label: Text('تاريخ المعامله')),
                        DataColumn(label: Text('شرح المعامله',maxLines: 2,)),
                      ],
                      rows: List.generate(data.length, (index) {
                        final b = data[index]["qedId"];
                        final d =data[index]["from"];
                        final e = data[index]["to"];
                        final f = data?[index]["qeddate"].toString().substring(0,10);
                        final g = data[index]["sharh"];
                        final x= double.tryParse(data[index]["balance"].toString())?.round()??0;
                        return DataRow(cells: [
                          DataCell(Container(child: Text("$x"))),
                          DataCell(Container(child: Text("$d"))),
                          DataCell(Container( child: Text("$e"))),
                          DataCell(Container( child: Text("$f"))),
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