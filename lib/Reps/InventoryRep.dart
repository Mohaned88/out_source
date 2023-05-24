
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:flutter/material.dart';

class InventoryRepShow extends StatefulWidget {
   InventoryRepShow({Key? key,required this.data}) : super(key: key);
List data ;
  @override
  State<InventoryRepShow> createState() => _InventoryRepShowState();
}

class _InventoryRepShowState extends State<InventoryRepShow> {

  List data = [];

  @override
  void initState() {
    data = widget.data;
    super.initState();
  }
  //
  // Future<Uint8List> _generatePdf(
  //     PdfPageFormat format,
  //     ) async {
  //   final pdf = pw.Document(
  //     version: PdfVersion.pdf_1_5,
  //     compress: true,
  //   );
  //   var data1 = await rootBundle.load("assets/fonts/Cairo-Black.ttf");
  //   final ttf = pw.Font.ttf(data1);
  //   pdf.addPage(
  //     pw.Page(
  //       pageFormat: format,
  //       build: (context) {
  //         return pw.Table(
  //             defaultColumnWidth: pw.FixedColumnWidth(200.0),
  //             border: pw.TableBorder.all(
  //                 color: PdfColor.fromInt(23323),
  //                 style: pw.BorderStyle.solid,
  //                 width: 1),
  //             children: [
  //               pw.TableRow(children: [
  //                 pw.Column(children: [
  //                   pw.Column(children: [
  //                     pw.Text('اسم الصنف ', style:
  //                     pw.TextStyle(fontSize: 12, font: ttf),
  //                         textDirection: pw.TextDirection.rtl),
  //                   ]),
  //                   for (var i = 0; i < data.length; i++)
  //                     pw.Column(children: [
  //                       pw.Text(data[i]["itemName"].toString(),
  //                           style: pw.TextStyle(fontSize: 10, font: ttf),
  //                           textDirection: pw.TextDirection.rtl),
  //                       pw.Divider(thickness: 1)
  //                     ])
  //                 ]),
  //                 pw.Column(children: [
  //                   pw.Column(children: [
  //                     pw.Text('الكميه', style:
  //                     pw.TextStyle(fontSize: 12, font: ttf),
  //                         textDirection: pw.TextDirection.rtl),
  //                   ]),
  //                   pw.Column(children: [
  //                     for (var x = 0; x < data.length; x++)
  //                       pw.Text(data[x]["quantity"].toString(),
  //                           style: pw.TextStyle(fontSize: 13, font: ttf),
  //                           textDirection: pw.TextDirection.rtl),
  //                     pw.Divider(thickness: 1)
  //                   ])
  //                 ]),
  //                 pw.Column(children: [
  //                   pw.Column(children: [
  //                     pw.Text('سعر الشراء',
  //                         style: pw.TextStyle(fontSize: 12, font: ttf),
  //                         textDirection: pw.TextDirection.rtl),
  //                   ]),
  //                   pw.Column(children: [
  //                     for (var x = 0; x < data.length; x++)
  //                       pw.Text(data[x]["costPrice"].toString(),
  //                           style: pw.TextStyle(fontSize: 13, font: ttf),
  //                           textDirection: pw.TextDirection.rtl),
  //                     pw.Divider(thickness: 1)
  //                   ])
  //                 ]),
  //                 pw.Column(children: [
  //                   pw.Column(children: [
  //                     pw.Text('سعر البيع',
  //                         style: pw.TextStyle(fontSize: 12, font: ttf),
  //                         textDirection: pw.TextDirection.rtl),
  //                   ]),
  //                   pw.Column(children: [
  //                     for (var x = 0; x < data.length; x++)
  //                       pw.Text(data[x]["salesPrice"].toString(),
  //                           style: pw.TextStyle(fontSize: 13, font: ttf),
  //                           textDirection: pw.TextDirection.rtl),
  //                     pw.Divider(thickness: 1)
  //                   ])
  //                 ]),
  //               ]),
  //             ]);
  //       },
  //     ),
  //   );
  //
  //   return pdf.save();
  // }


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
                columnSpacing: 5.0,
                columns: [
                  DataColumn(label: Text('كود')),
                  DataColumn(label: Text('اسم الصنف')),
                  DataColumn(label: Text('المنصرف')),
                  DataColumn(label: Text('الوارد')),
                  DataColumn(label: Text('الكميه')),
                  DataColumn(label: Text('سعر ')),
                ],
                rows: List.generate(data.length, (index) {
                  final b = data[index]["itemId"];
                  final c = data[index]["itemName"];
                  final z = double.tryParse(data[index]["qTake"]);
                  final x = double.tryParse(data[index]["qAdd"])!.roundToDouble();
                  final d =data[index]["quantity"];
                  final e = data[index]["salesPrice"];
                  return DataRow(cells: [
                    DataCell(Container(child: Text("$b"))),
                    DataCell(Container(child: Text("$c"))),
                    DataCell(Container(child: Text("$z"))),
                    DataCell(Container(child: Text("$x"))),
                    DataCell(Container(child: Text("$d"))),
                    DataCell(Container( child: Text("$e"))),
                  ]);
                }),
              ),
            ),
          ),
        ],
      ),
    );

    // return MaterialApp(
    //   home: Scaffold(
    //     appBar: AppBar(
    //       title: Text('مخزن المندوب'),
    //     ),
    //     body: PdfPreview(
    //       build: (format) => _generatePdf(format),
    //     ),
    //   ),
    // );
  }
}
