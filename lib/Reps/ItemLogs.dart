//6-6-2023


import 'dart:convert';
import 'package:flutter/material.dart';


class ItemLogShow extends StatefulWidget {
  ItemLogShow({Key? key, required this.data}) : super(key: key);
  String data;

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

  @override
  Widget build(BuildContext context) {
    return
      SafeArea(
      child: Column(
        children: [
      Expanded(
      child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child:
         data.length!=1?
         DataTable(
            border: TableBorder.all(),
            columnSpacing: 38.0,
           headingRowColor:  MaterialStateProperty.all<Color>(
               Colors.greenAccent),
            columns: [
              DataColumn(label: Text('نوع')),
              DataColumn(label: Text('تاريخ')),
              DataColumn(label: Text('رقم المعامله')),
              DataColumn(label: Text('العميل')),
              DataColumn(label: Text('مضاف')),
              DataColumn(label: Text('مسحوبات')),
              DataColumn(label: Text('رصيد')),
            ],
            rows: List.generate(data.length, (index) {
              final c = data[index]["TransType"].toString() ?? 0;
              final date = data[index]["TransDate"].toString().substring(0, 10) ?? 0;
              final d = data[index]["QuantityAdd"].toString() ?? 0;
              final e = data[index]["QuantityTake"].toString() ?? 0;
              final f = data[index]["TransId"].toString() ?? 0;
              final tag = data[index]["Tag"].toString() ?? 0;
              final balance = data[index]["balance"].toString() ?? 0;
              // final x = double.tryParse(d)!-double.tryParse(e)!;s
              return DataRow(cells: [
                DataCell(Container(child: Text("$c"))),
                DataCell(Container(child: Text("$date"))),
                DataCell(Container(child: Text("$f"))),
                DataCell(Container(child: Text("$tag"))),
                DataCell(Container(child: Text("$d"))),
                DataCell(Container(child: Text("$e"))),
                DataCell(Container(child: Text("$balance"))),
                //  DataCell(Container( child: Text("$x"))),
              ]);
            }),
          ):Center(child: Text("لا يوجد معاملات",style: (TextStyle(fontSize: 25)),)),
        ),
      ),

    ),])
    ,
    );
  }
}
