import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
  //                     pw.Text('كود العميل', style:
  //                     pw.TextStyle(fontSize: 12, font: ttf),
  //                         textDirection: pw.TextDirection.rtl),
  //                   ]),
  //                   for (var i = 0; i < data.length; i++)
  //                     pw.Column(children: [
  //                       pw.Text(data[i]["customerTag"].toString(),
  //                           style: pw.TextStyle(fontSize: 13, font: ttf),
  //                           textDirection: pw.TextDirection.rtl),
  //                       pw.Divider(thickness: 1)
  //                     ])
  //                 ]),
  //                 pw.Column(children: [
  //                   pw.Column(children: [
  //                     pw.Text('اسم العميل', style:
  //                     pw.TextStyle(fontSize: 12, font: ttf),
  //                         textDirection: pw.TextDirection.rtl),
  //                   ]),
  //                   pw.Column(children: [
  //                     for (var x = 0; x < data.length; x++)
  //                       pw.Text(data[x]["customerName"].toString(),
  //                           style: pw.TextStyle(fontSize: 13, font: ttf),
  //                           textDirection: pw.TextDirection.rtl),
  //                     pw.Divider(thickness: 1)
  //                   ])
  //                 ]),
  //                 pw.Column(children: [
  //                   pw.Column(children: [
  //                     pw.Text('اسم الصنف',
  //                         style: pw.TextStyle(fontSize: 12, font: ttf),
  //                         textDirection: pw.TextDirection.rtl),
  //                   ]),
  //                   pw.Column(children: [
  //                     for (var x = 0; x < data.length; x++)
  //                       pw.Text(data[x]["itemName"].toString(),
  //                           style: pw.TextStyle(fontSize: 13, font: ttf),
  //                           textDirection: pw.TextDirection.rtl),
  //                     pw.Divider(thickness: 1)
  //                   ])
  //                 ]),
  //                 pw.Column(children: [
  //                   pw.Column(children: [
  //                     pw.Text('الكميئة المأخوذة',
  //                         style: pw.TextStyle(fontSize: 12, font: ttf),
  //                         textDirection: pw.TextDirection.rtl),
  //                   ]),
  //                   pw.Column(children: [
  //                     for (var x = 0; x < data.length; x++)
  //                       pw.Text(data[x]["quantityTake"].toString(),
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
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 30.0,
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