
import 'package:flutter/material.dart';



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
  //                     pw.Text("كود المعامله",
  //                         style: pw.TextStyle(fontSize: 13, font: ttf),
  //                         textDirection: pw.TextDirection.rtl),
  //                     pw.Divider(thickness: 1),
  //                     pw.Text("مدين",
  //                         style: pw.TextStyle(fontSize: 13, font: ttf),
  //                         textDirection: pw.TextDirection.rtl),
  //                     pw.Divider(thickness: 1),
  //                     pw.Text("دائن",
  //                         style: pw.TextStyle(fontSize: 13, font: ttf),
  //                         textDirection: pw.TextDirection.rtl),
  //                     pw.Divider(thickness: 1),
  //                     pw.Text("تاريخ العامله",
  //                         style: pw.TextStyle(fontSize: 13, font: ttf),
  //                         textDirection: pw.TextDirection.rtl),
  //                     pw.Divider(thickness: 1),
  //                     pw.Text("شرح المعامله",
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
  //                                 pw.Text(data[i]["qedId"].toString(),
  //                                     style:
  //                                     pw.TextStyle(fontSize: 17, font: ttf),
  //                                     textDirection: pw.TextDirection.rtl),
  //                                 pw.Divider(thickness: 1)
  //                               ]),
  //                           pw.SizedBox(width: 35),
  //                           pw.Column(
  //                               crossAxisAlignment: pw.CrossAxisAlignment.center,
  //                               mainAxisAlignment: pw.MainAxisAlignment.center,
  //                               children: [
  //                                 pw.Text(data[i]["from"].toString(),
  //                                     style:
  //                                     pw.TextStyle(fontSize: 17, font: ttf),
  //                                     textDirection: pw.TextDirection.rtl),
  //                                 pw.Divider(thickness: 1)
  //                               ]), pw.SizedBox(width: 30),
  //                           pw.Column(
  //                               crossAxisAlignment: pw.CrossAxisAlignment.center,
  //                               mainAxisAlignment: pw.MainAxisAlignment.center,
  //                               children: [
  //                                 pw.Text(data[i]["to"].toString(),
  //                                     style:
  //                                     pw.TextStyle(fontSize: 17, font: ttf),
  //                                     textDirection: pw.TextDirection.rtl),
  //                                 pw.Divider(thickness: 1)
  //                               ]), pw.SizedBox(width: 25),
  //                           pw.Column(
  //                               crossAxisAlignment: pw.CrossAxisAlignment.center,
  //                               mainAxisAlignment: pw.MainAxisAlignment.center,
  //                               children: [
  //
  //                                 pw.Text(data[i]["qeddate"].toString().substring(0,10),
  //                                     style:
  //                                     pw.TextStyle(fontSize: 17, font: ttf),
  //                                     textDirection: pw.TextDirection.rtl),
  //                                 pw.Divider(thickness: 1)
  //                               ]), pw.SizedBox(width: 10),
  //                           pw.SizedBox(width: 20),
  //                           pw.Column(
  //                               crossAxisAlignment: pw.CrossAxisAlignment.center,
  //                               mainAxisAlignment: pw.MainAxisAlignment.center,
  //                               children: [
  //                                 pw.Text(data[i]["sharh"].toString(),
  //                                     style:
  //                                     pw.TextStyle(fontSize: 13, font: ttf),
  //                                     textDirection: pw.TextDirection.rtl),
  //                                 pw.Divider(thickness: 1)
  //                               ]), pw.SizedBox(width: 80),
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
                columnSpacing: 10.0,
                dataRowHeight: 100.0,
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
                    DataCell(Container(child: Text("$x"))),
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
    // return MaterialApp(
    //   home: Scaffold(
    //     appBar: AppBar(
    //       title: Text('تقرير خزينة المندوب'),
    //     ),
    //     body: PdfPreview(
    //       build: (format) => _generatePdf(format),
    //     ),
    //   ),
    // );
  }
}
