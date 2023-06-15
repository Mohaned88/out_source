import 'package:flutter/material.dart';

class GeneralDailyRepShow extends StatefulWidget {
  GeneralDailyRepShow({Key? key, required this.data}) : super(key: key);
  List data;

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
  @override
  Widget build(BuildContext context) {
    return   SafeArea(
      child: Column(
        children: [
          Container(
            color: Colors.blue,
            height: 38,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Text('الرصيد '),
              Text('عليه'),
              Text('   له   '),
            Text( 'تاريخ المعامله'),
    Text('شرح المعامله        '),
            ]),
          ),
          Expanded(
              child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              child: DataTable(
                border: TableBorder.all(),
                columnSpacing: 10.0,
                dataRowHeight: 100.0,
                 headingRowHeight: 0,
                columns: [
                  DataColumn(label: Text('الرصيد')),
                  DataColumn(label: Text('عليه')),
                  DataColumn(label: Text('له')),
                  DataColumn(label: Text('تاريخ المعامله')),
                  DataColumn(label: Text('شرح المعامله')),
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
                    DataCell(Container( child: Text("$g"))),
                  ]);
                }),
              ),

            ),
          ),
        ],
      ),
    );
  }
}