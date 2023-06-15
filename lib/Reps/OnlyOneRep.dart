

///10-6-2023

import 'package:flutter/services.dart';

import 'package:flutter/material.dart';

class OnlyOneRepShow extends StatefulWidget {
   OnlyOneRepShow({Key? key,required this.data}) : super(key: key);
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

  @override
  Widget build(BuildContext context) {
    return   SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 30.0,
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
          ),  Container(
            color: Colors.blue,
            height: 38,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:

              [ Text(
                  'اجمالي عدد العملاء',
                  style: TextStyle(

                      fontSize: 15, fontWeight: FontWeight.bold)
              ),
                VerticalDivider(color: Colors.black,thickness: 2,),
                Text("${data.length}"),
    ]),
          )
        ],
      ),
    );
    // return MaterialApp(
    //   home: Scaffold(
    //     appBar: AppBar(
    //       title: Text('عملاء الصنف الواحد'),
    //     ),
    //     body: PdfPreview(
    //       build: (format) => _generatePdf(format),
    //     ),
    //   ),
    // );
  }
}
