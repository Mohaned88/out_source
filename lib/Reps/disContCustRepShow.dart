


import 'package:flutter/material.dart';

class DisContCustRepShow extends StatefulWidget {
   DisContCustRepShow({Key? key,required this.data}) : super(key: key);
  List data ;
  @override
  State<DisContCustRepShow> createState() => _DisContCustRepShowState();
}

class _DisContCustRepShowState extends State<DisContCustRepShow> {

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
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columnSpacing: 30.0,
                columns: [
                  DataColumn(label: Text('اسم العميل')),
                  DataColumn(label: Text('التليفون')),
                  DataColumn(label: Text('العنوان ')),
                ],
                rows: List.generate(data.length, (index) {
                  final b = data[index]["orgName"];
                  final d = data[index]["mobile"];
                  final c = data[index]["address"];
                  return DataRow(cells: [
                    DataCell(Container(child: Text(b))),
                    DataCell(Container(child: Text("$d"))),
                    DataCell(Container(child: Text("$c"))),

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