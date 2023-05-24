import 'package:flutter/material.dart';






class ItemLogShow extends StatefulWidget {
   ItemLogShow({Key? key,required this.data}) : super(key: key);
  List data;
  @override
  State<ItemLogShow> createState() => _ItemLogShowState();
}

class _ItemLogShowState extends State<ItemLogShow> {
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
                border: TableBorder.all(),
                columnSpacing: 38.0,
                columns: [
                  DataColumn(label: Text('نوع المعامله')),
                  DataColumn(label: Text('مضاف')),
                  DataColumn(label: Text('مسحوبات')),
               //   DataColumn(label: Text('x')),

                ],
                rows: List.generate(data.length, (index) {
                  final c = data[index]["transType"];
                  final d = data[index]["quantityAdd"].toString();
                  final e = data[index]["quantityTake"].toString();
                  final x = double.tryParse(d)!-double.tryParse(e)!;
                  return DataRow(cells: [
                    DataCell(Container(child: Text(c))),
                    DataCell(Container( child: Text("$d"))),
                    DataCell(Container( child: Text("$e"))),
                 ///   DataCell(Container( child: Text("$x"))),
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
