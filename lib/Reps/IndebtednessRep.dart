import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'DeneralDailyRep.dart';

class IndebtednessRepShow extends StatefulWidget {
  IndebtednessRepShow({Key? key, required this.data}) : super(key: key);
  List data;

  @override
  State<IndebtednessRepShow> createState() => _IndebtednessRepShowState();
}

class _IndebtednessRepShowState extends State<IndebtednessRepShow> {
  List data = [];

  @override
  void initState() {
    data = widget.data;
    super.initState();
  }

  // Future<Uint8List> _generatePdf(
  //   PdfPageFormat format,
  // ) async {
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
  //         pw.TextStyle(fontSize: 12, font: ttf),
  //             textDirection: pw.TextDirection.rtl),
  //                   ]),
  //                   for (var i = 0; i < data.length; i++)
  //                     pw.Column(children: [
  //                       pw.Text(data[i]["orgId"].toString(),
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
  //                     pw.Text('مدين',
  //                         style: pw.TextStyle(fontSize: 12, font: ttf),
  //                         textDirection: pw.TextDirection.rtl),
  //                   ]),
  //                   pw.Column(children: [
  //                     for (var x = 0; x < data.length; x++)
  //                       pw.Text(data[x]["totalCreditor"].toString(),
  //                           style: pw.TextStyle(fontSize: 13, font: ttf),
  //                           textDirection: pw.TextDirection.rtl),
  //                     pw.Divider(thickness: 1)
  //                   ])
  //                 ]),
  //                 pw.Column(children: [
  //                   pw.Column(children: [
  //                     pw.Text('دائن',
  //                         style: pw.TextStyle(fontSize: 12, font: ttf),
  //                         textDirection: pw.TextDirection.rtl),
  //                   ]),
  //                   pw.Column(children: [
  //                     for (var x = 0; x < data.length; x++)
  //                       pw.Text(data[x]["totalDebtor"].toString(),
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
  // Calculate the total values for each column
  Widget build(BuildContext context) {
    // Calculate the total values for each column
    final totalCreditor = data.fold<double>(
            0,
            (previous, current) =>
                previous +
                (double.tryParse(current["totalCreditor"]) ?? 0.0)) ??
        0;
    final totalDebtor = data.fold<double>(
            0,
            (previous, current) =>
                previous + (double.tryParse(current["totalDebtor"]) ?? 0.0)) ??
        0;
    final totalNet = data.fold<double>(
            0,
            (previous, current) =>
                previous +
                ((double.tryParse(current["totalCreditor"]) ?? 0.0) -
                    (double.tryParse(current["totalDebtor"]) ?? 0.0))) ??
        0;
    return SafeArea(
      child: Column(
        children: [
          Container(
            color: Colors.blue,
            height: 38,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [Text("العميل "),Text("مسحوبات"),Text("المرتجعات "),Text("الصافي")],),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                border: TableBorder.all(),
                columnSpacing: 38.0,
                headingRowHeight: 0.0,
                columns: [
                  DataColumn(label: Text('العميل')),
                  DataColumn(label: Text('مسحوبات')),
                  DataColumn(label: Text('المرتجعات')),
                  DataColumn(label: Text('الصافي')),
                ],headingRowColor:  MaterialStateProperty.all<Color>(
                  Colors.greenAccent),
                rows: List.generate(data.length, (index) {
                      final c = data[index]["customerName"];
                      final d = double.tryParse(data[index]["totalCreditor"]);
                      final e = double.tryParse(data[index]["totalDebtor"]);
                      final x = d! - e!;
                      return DataRow(cells: [
                        DataCell(GestureDetector(
                            onTap: () async {
                              String tag = data[index]["orgId"];

                              final String url =
                                  "http://sales.dynamicsdb2.com/api/GeneralDailyReport/$tag";
                              var response = await http.get(Uri.parse(url),
                                  headers: {"Accept": "application/json"});
                              if (response.statusCode == 200) {
                                print("Saving Data ");
                                print(response.body);
                              } else {
                                print(response.statusCode);
                              }

                              List jsonResponse = jsonDecode(response.body);

                              print("get Report");
                              print(jsonResponse);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => GeneralDailyRepShow(
                                          data: jsonResponse)));
                            },
                            child: Container(
                                child: Text(
                              c,
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue),
                            )))),
                        DataCell(Container(child: Text("$d"))),
                        DataCell(Container(child: Text("$e"))),
                        DataCell(Container(child: Text("$x"))),
                      ]);
                     })
//                     +
//                     [
// // Add a new DataRow with the total values for each column
//                       DataRow(
//                           cells: [
//                             DataCell(Text(
//                               'الإجمالي',
//                               style: TextStyle(
//                                   fontSize: 15, fontWeight: FontWeight.bold),
//                             )),
//                             DataCell(Text(totalCreditor.toStringAsFixed(2))),
//                             DataCell(Text(totalDebtor.toStringAsFixed(2))),
//                             DataCell(Text(totalNet.toStringAsFixed(2))),
//                           ],
//                           color: MaterialStateProperty.all<Color>(
//                               Colors.greenAccent)),
               //     ],
              ),
            ),
          ),
          Container(
            color: Colors.blue,
            height: 38,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:

            [ Text(
              'الإجمالي',
              style: TextStyle(

                  fontSize: 15, fontWeight: FontWeight.bold)
            ),
              VerticalDivider(color: Colors.black,thickness: 2,),
              Text(totalCreditor.toStringAsFixed(2)),
              VerticalDivider(color: Colors.black,thickness: 2,),
              Text(totalDebtor.toStringAsFixed(2)),
              VerticalDivider(color: Colors.black,thickness: 2,),
             Text(totalNet.toStringAsFixed(2)),],),
          )
        ],
      ),
    );
  }
}
