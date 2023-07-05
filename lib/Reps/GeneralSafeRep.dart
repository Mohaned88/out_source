
import 'package:flutter/material.dart';

import '../resources/colors.dart';



class GeneralSafeRepShow extends StatefulWidget {
   GeneralSafeRepShow({Key ?key,required this.data}) : super(key: key);
List data;
  @override
  State<GeneralSafeRepShow> createState() => _GeneralSafeRepShowState();
}

class _GeneralSafeRepShowState extends State<GeneralSafeRepShow> {

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
            "خزينة المندوب",
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
                        DataColumn(label: Text('رصيد')),
                        DataColumn(label: Text('مدين')),
                        DataColumn(label: Text('دائن')),
                        DataColumn(label: Text('تاريخ المعامله')),
                        DataColumn(label: Text('شرح ')),
                      ],
                      rows: List.generate(data.length, (index) {
                        final b = data[index]["qedId"];
                        final c = data[index]["from"];
                        final d =double.tryParse(data[index]["to"].toString())!.roundToDouble();
                        final e = data[index]["qeddate"].toString().substring(0,10);
                        final f = data[index]["sharh"];
                        final x= double.tryParse(data[index]["balance"].toString())!.round();
                        return DataRow(cells: [
                          DataCell(SizedBox(
                              width: double.infinity,
                              child: Text(
                                "$x",
                                textAlign: TextAlign.center,
                              ))),
                          DataCell(SizedBox(
                              width: double.infinity,
                              child: Text(
                                "$c",
                                textAlign: TextAlign.center,
                              ))),
                          DataCell(SizedBox(
                              width: double.infinity,
                              child: Text(
                                "$d",
                                textAlign: TextAlign.center,
                              ))),
                          DataCell(SizedBox(
                              width: double.infinity,
                              child: Text(
                                "$e",
                                textAlign: TextAlign.center,
                              ))),
                          DataCell(Container( child: Text("$f"))),

                        ],);
                      },),
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
