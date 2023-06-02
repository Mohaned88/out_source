import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:flutter/material.dart';


class Mas7obatRepShow extends StatefulWidget {
  Mas7obatRepShow({Key? key, required this.data}) : super(key: key);
  List data;

  @override
  State<Mas7obatRepShow> createState() => _Mas7obatRepShowState();
}

class _Mas7obatRepShowState extends State<Mas7obatRepShow> {
  List data = [];
  Future<List<dynamic>> get() async {
    return data;
  }
  @override
  void initState() {
    data = widget.data;
    print("after");
    print(data);
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
  //       // pageTheme: pw.Font.ttf(data1),
  //       // theme: ThemeData.withFont(
  //       //   base: ttf,
  //       // ),
  //       build: (context) {
  //         return pw.Column(
  //             crossAxisAlignment: pw.CrossAxisAlignment.stretch,
  //             children: [
  //               //////headersssssss
  //               pw.Row(
  //                   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     pw.Text("العميل",
  //                         style: pw.TextStyle(fontSize: 13, font: ttf),
  //                         textDirection: pw.TextDirection.rtl),
  //                     pw.Divider(thickness: 1),
  //                     pw.Text("اسم الصنف",
  //                         style: pw.TextStyle(fontSize: 13, font: ttf),
  //                         textDirection: pw.TextDirection.rtl),
  //                     pw.Divider(thickness: 1),
  //                     pw.Text("الكميه ",
  //                         style: pw.TextStyle(fontSize: 13, font: ttf),
  //                         textDirection: pw.TextDirection.rtl),
  //                     pw.Divider(thickness: 1),
  //                     pw.Text("المرتجع",
  //                         style: pw.TextStyle(fontSize: 13, font: ttf),
  //                         textDirection: pw.TextDirection.rtl),
  //                     pw.Divider(thickness: 1),
  //                     pw.Text("الاجمالي",
  //                         style: pw.TextStyle(fontSize: 13, font: ttf),
  //                         textDirection: pw.TextDirection.rtl),
  //
  //                     pw.Divider(thickness: 1),
  //                   ]),
  //
  //               /////dataaaaaaaaa
  //               pw.Row(
  //                   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     pw.Table(children: [
  //                       for (var i = 0; i < data.length; i++)
  //                         pw.TableRow(children: [
  //                           pw.Column(
  //                               crossAxisAlignment: pw.CrossAxisAlignment.center,
  //                               mainAxisAlignment: pw.MainAxisAlignment.center,
  //                               children: [
  //                                 pw.Text(data[i]["name"].toString(),
  //                                     style:
  //                                     pw.TextStyle(fontSize: 13, font: ttf),
  //                                     textDirection: pw.TextDirection.rtl),
  //                                 pw.Divider(thickness: 1)
  //                               ]),
  //                           pw.SizedBox(width: 10),
  //                           pw.Column(
  //                               crossAxisAlignment: pw.CrossAxisAlignment.center,
  //                               mainAxisAlignment: pw.MainAxisAlignment.center,
  //                               children: [
  //                                 pw.Text(data[i]["name"].toString(),
  //                                     style:
  //                                     pw.TextStyle(fontSize: 14, font: ttf),
  //                                     textDirection: pw.TextDirection.rtl),
  //                                 pw.Divider(thickness: 1)
  //                               ]), pw.SizedBox(width: 10),
  //                           pw.Column(
  //                               crossAxisAlignment: pw.CrossAxisAlignment.center,
  //                               mainAxisAlignment: pw.MainAxisAlignment.center,
  //                               children: [
  //                                 pw.Text(data[i]["name"].toString(),
  //                                     style:
  //                                     pw.TextStyle(fontSize: 17, font: ttf),
  //                                     textDirection: pw.TextDirection.rtl),
  //                                 pw.Divider(thickness: 1)
  //                               ]), pw.SizedBox(width: 10),
  //                           pw.Column(
  //                               crossAxisAlignment: pw.CrossAxisAlignment.center,
  //                               mainAxisAlignment: pw.MainAxisAlignment.center,
  //                               children: [
  //
  //                                 pw.Text(data[i]["name"].toString(),
  //                                     style:
  //                                     pw.TextStyle(fontSize: 13, font: ttf),
  //                                     textDirection: pw.TextDirection.rtl),
  //                                 pw.Divider(thickness: 1)
  //                               ]), pw.SizedBox(width: 10),
  //                           pw.SizedBox(width: 10),
  //                           pw.Column(
  //                               crossAxisAlignment: pw.CrossAxisAlignment.center,
  //                               mainAxisAlignment: pw.MainAxisAlignment.center,
  //                               children: [
  //                                 pw.Text(data[i]["name"].toString(),
  //                                     style:
  //                                     pw.TextStyle(fontSize: 13, font: ttf),
  //                                     textDirection: pw.TextDirection.rtl),
  //                                 pw.Divider(thickness: 1)
  //                               ]), pw.SizedBox(width: 20),
  //
  //                         ])
  //                     ])
  //
  //                   ])
  //
  //             ]);
  //       },
  //     ),
  //   );
  //
  //   return pdf.save();
  // }
  //

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   home: Scaffold(
    //     appBar: AppBar(
    //       title: Text('اجمالي مسحوبات عملاء المندوب'),
    //     ),
    //     body: PdfPreview(
    //       build: (format) => _generatePdf(format),
    //     ),
    //   ),
    // );
    return   SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                border: TableBorder.all(),
                columnSpacing: 20.0,
                columns: [
                  DataColumn(label: Text('اسم الصنف')),
                  DataColumn(label: Text('المسحوبات')),
                  DataColumn(label: Text('اجمالي قيمه',style: (TextStyle(fontSize: 10)),)),
                  DataColumn(label: Text('المرتجعات')),
                  DataColumn(label: Text('اجمالي قيمه',style: (TextStyle(fontSize: 10)),)),
                ],
                rows: List.generate(data.length, (index) {
                  final b = data[index]["itemName"];
                  final c = double?.tryParse(data[index]["quantityTake"]);
                  final d =double?.tryParse(data[index]["total"]);
                  final e = double?.tryParse(data[index]["quantityAdd"]);
                  final f = double?.tryParse(data[index]["total2"]);
                  return DataRow(cells: [
                    DataCell(Container(child: Text(b))),
                    DataCell(Container(child: Text("$c"))),
                    DataCell(Container(child: Text("$d"))),
                    DataCell(Container( child: Text("$e"))),
                    DataCell(Container( child: Text("$f"))),

                  ]);
                }),
              ),
            ),
          ),
        ],
      ),
    );

    //   FutureBuilder<List<dynamic>>(
    //   future: get(),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       // If the API call was successful, build the ListView
    //       return ListView.builder(
    //         itemCount: data.length,
    //         itemBuilder: (context, index) {
    //           return Card(
    //             child: Column(
    //               children: [
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Text(
    //                       "اسم العميل",
    //                       style: TextStyle(
    //                         fontSize: 16,
    //                         fontWeight: FontWeight.bold,
    //                         fontFamily: 'GE SS Two',
    //                       ),
    //                     ),
    //                     Text(
    //                       "${snapshot.data![index]["name"]}",
    //                       style: TextStyle(
    //                         fontSize: 16,
    //                         fontWeight: FontWeight.bold,
    //                         fontFamily: 'GE SS Two',
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //                 SizedBox(height: 10,),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Text(
    //                       "الصنف",
    //                       style: TextStyle(
    //                         fontSize: 16,
    //                         fontWeight: FontWeight.bold,
    //                         fontFamily: 'GE SS Two',
    //                       ),
    //                     ),
    //                     Text(
    //                       "${snapshot.data![index]["itemName"]}",
    //                       style: TextStyle(
    //                         fontSize: 16,
    //                         fontWeight: FontWeight.bold,
    //                         fontFamily: 'GE SS Two',
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //                 SizedBox(height: 10,),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Text(
    //                       "محسوبات ",
    //                       style: TextStyle(
    //                         fontSize: 16,
    //                         fontWeight: FontWeight.bold,
    //                         fontFamily: 'GE SS Two',
    //                       ),
    //                     ),
    //                     Text(
    //                       "${snapshot.data![index]["quantityTake"]}",
    //                       style: TextStyle(
    //                         fontSize: 16,
    //                         fontWeight: FontWeight.bold,
    //                         fontFamily: 'GE SS Two',
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //
    //                 SizedBox(height: 10,),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Text(
    //                       "مرتجعات ",
    //                       style: TextStyle(
    //                         fontSize: 16,
    //                         fontWeight: FontWeight.bold,
    //                         fontFamily: 'GE SS Two',
    //                       ),
    //                     ),
    //                     Text(
    //                       "${snapshot.data![index]["quantityAdd"]}",
    //                       style: TextStyle(
    //                         fontSize: 16,
    //                         fontWeight: FontWeight.bold,
    //                         fontFamily: 'GE SS Two',
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //                 SizedBox(height: 10,),
    //
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Text(
    //                       "اجمالي مرتجعات ",
    //                       style: TextStyle(
    //                         fontSize: 16,
    //                         fontWeight: FontWeight.bold,
    //                         fontFamily: 'GE SS Two',
    //                       ),
    //                     ),
    //                     Text(
    //                       "${snapshot.data![index]["total2"]}",
    //                       style: TextStyle(
    //                         fontSize: 16,
    //                         fontWeight: FontWeight.bold,
    //                         fontFamily: 'GE SS Two',
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //                 SizedBox(height: 10,),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Text(
    //                       "اجمالي محسوبات ",
    //                       style: TextStyle(
    //                         fontSize: 16,
    //                         fontWeight: FontWeight.bold,
    //                         fontFamily: 'GE SS Two',
    //                       ),
    //                     ),
    //                     Text(
    //                       "${snapshot.data![index]["total"]}",
    //                       style: TextStyle(
    //                         fontSize: 16,
    //                         fontWeight: FontWeight.bold,
    //                         fontFamily: 'GE SS Two',
    //                       ),
    //                     )
    //                   ],
    //                 )
    //               ],
    //             ),
    //           );
    //         },
    //       );
    //     } else if (snapshot.hasError) {
    //       // If the API call was unsuccessful, display an error message
    //       return Center(
    //         child: Text('${snapshot.error}'),
    //       );
    //     }
    //
    //     // If the data is still being loaded, show a loading indicator
    //     return Center(
    //       child: CircularProgressIndicator(),
    //     );
    //   },
    // );
  }
}