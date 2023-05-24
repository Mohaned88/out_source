import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'controller.dart';
import 'databasehelper.dart';

class Printer extends StatefulWidget {
  int id;

  Printer({required this.id, Key? key}) : super(key: key);

  @override
  State<Printer> createState() => _PrinterState();
}

class _PrinterState extends State<Printer> {
  // BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  //
  // List<BluetoothDevice> _devices = [];
  // BluetoothDevice? _device;
  // bool _connected = false;

  @override
  void initState() {
    super.initState();
    billDetList();
    billList().then((value) => setState(list = value));
    // initPlatformState();
  }

  bool loading3 = false;
  List list3 = [];

  Future billDetList() async {
    list3 = await Controller().fetchBillDetailsData(widget.id);
    setState(() {
      loading3 = false;
    });
    print(list3);
  }
  bool loading = true;
  final conn = SqfliteDatabaseHelper.instance;
  List list = [];

  Future billList() async {
    late List ff = [];
    var dbclient = await conn.db;
    List<Map<String, dynamic>> maps = await dbclient
        .rawQuery('select bill_id,bill_date,customer_id,mandoob_1,orgName from Bill INNER JOIN Organizations ON  customer_id = org_ID where bill_id = ${widget.id}');
    for (var item in maps) {
      ff.add(item);
    }
    setState(() {
      loading = false;
    });
    print("billlllllll");
    print(ff);
    return ff;
  }

  Future<Uint8List> _generatePdf(
    PdfPageFormat format,
  ) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();
    var data1 = await rootBundle.load("assets/fonts/Cairo-Black.ttf");
    final ttf = pw.Font.ttf(data1);
    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(children: [
            pw.Container(
                child: pw.Column(
                    children: [
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  children: [
                pw.Text("bill Number ", style: pw.TextStyle(fontSize: 15)),
                pw.Text("${list[0]["bill_id"]}",
                    style: pw.TextStyle(fontSize: 15))
              ]),pw.SizedBox(height: 10),
                      pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                      children: [
                        pw.Text("Customer Code ", style: pw.TextStyle(fontSize: 15)),

                        pw.Text("${list[0]["customer_id"]}",
                            style: pw.TextStyle(fontSize: 15))
                      ]),


                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                          children: [
                            pw.Text("Customer Name ", style: pw.TextStyle(fontSize: 15)),

                            pw.Text("${list[0]["orgName"]}",
                                style: pw.TextStyle(fontSize: 13, font: ttf),
                                textAlign: pw.TextAlign.center,
                                textDirection: pw.TextDirection.rtl)
                          ]),
                      pw.Row( mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,children: [pw.SizedBox(height: 10),  pw.Text("bill Date", style: pw.TextStyle(fontSize: 15)),
                        pw.Text("${list[0]["bill_date"]}", style: pw.TextStyle(fontSize: 15))])
            ])),
            pw.SizedBox(height: 25),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Code"),
                  pw.Text("Name"),
                  pw.Text("price"),
                  pw.Text("quantity"),
                  pw.Text("total")
                ]),
            pw.SizedBox(height: 10),
            pw.Table(children: [
              for (var i = 0; i < list3.length; i++)
                pw.TableRow(children: [
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text(list3[i]["itemId"].toString(),
                            style: pw.TextStyle(fontSize: 15)),
                        pw.Divider(thickness: 1)
                      ]),

          pw.Text(list3[i]["Item_Name"].toString(),
              style: pw.TextStyle(fontSize: 13, font: ttf),
              textAlign: pw.TextAlign.center,
              textDirection: pw.TextDirection.rtl),
          pw.Divider(thickness: 1),

                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text(list3[i]["price"].toString(),
                            style: pw.TextStyle(fontSize: 15)),
                        pw.Divider(thickness: 1)
                      ]),
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text(list3[i]["unit1Quant"].toString(),
                            style: pw.TextStyle(fontSize: 15)),
                        pw.Divider(thickness: 1)
                      ]),
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text(list3[i]["total"].toString(),
                            style: pw.TextStyle(fontSize: 15)),
                        pw.Divider(thickness: 1)
                      ])
                ])
            ])
          ]

              // children: [
              //   pw.SizedBox(
              //     width: double.infinity,
              //     child: pw.FittedBox(
              //       child: pw.Text("title", style: pw.TextStyle(font: font)),
              //     ),
              //   ),
              //   pw.SizedBox(height: 20),
              //   pw.Flexible(child: pw.FlutterLogo())
              // ],
              );
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Blue Thermal Printer'),
        ),
        body: PdfPreview(
          build: (format) => _generatePdf(format),
        ),
        // Container(
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: ListView(
        //       children: <Widget>[
        //         Row(
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: <Widget>[
        //             SizedBox(
        //               width: 10,
        //             ),
        //             Text(
        //               'Device:',
        //               style: TextStyle(
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //             SizedBox(
        //               width: 30,
        //             ),
        //             Expanded(
        //               child: DropdownButton(
        //                 items: _getDeviceItems(),
        //                 onChanged: (BluetoothDevice? value) =>
        //                     setState(() => _device = value),
        //                 value: _device,
        //               ),
        //             ),
        //           ],
        //         ),
        //         SizedBox(
        //           height: 10,
        //         ),
        //         Row(
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           mainAxisAlignment: MainAxisAlignment.end,
        //           children: <Widget>[
        //             ElevatedButton(
        //               style: ElevatedButton.styleFrom(primary: Colors.brown),
        //               onPressed: () {
        //                 initPlatformState();
        //               },
        //               child: Text(
        //                 'Refresh',
        //                 style: TextStyle(color: Colors.white),
        //               ),
        //             ),
        //             SizedBox(
        //               width: 20,
        //             ),
        //             ElevatedButton(
        //               style: ElevatedButton.styleFrom(
        //                   primary: _connected ? Colors.red : Colors.green),
        //               onPressed: _connected ? _disconnect : _connect,
        //               child: Text(
        //                 _connected ? 'Disconnect' : 'Connect',
        //                 style: TextStyle(color: Colors.white),
        //               ),
        //             ),
        //           ],
        //         ),
        //         Padding(
        //           padding:
        //           const EdgeInsets.only(left: 10.0, right: 10.0, top: 50),
        //           child: ElevatedButton(
        //             style: ElevatedButton.styleFrom(primary: Colors.brown),
        //             onPressed: () {
        //
        //             },
        //             child: Text('PRINT TEST',
        //                 style: TextStyle(color: Colors.white)),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }

// List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
//   List<DropdownMenuItem<BluetoothDevice>> items = [];
//   if (_devices.isEmpty) {
//     items.add(DropdownMenuItem(
//       child: Text('NONE'),
//     ));
//   } else {
//     _devices.forEach((device) {
//       items.add(DropdownMenuItem(
//         child: Text(device.name ?? ""),
//         value: device,
//       ));
//     });
//   }
//   return items;
// }

// void _connect() {
//   if (_device != null) {
//     bluetooth.isConnected.then((isConnected) {
//       if (isConnected == true) {
//         bluetooth.connect(_device!).catchError((error) {
//           setState(() => _connected = false);
//         });
//         setState(() => _connected = true);
//       }
//     });
//   } else {
//     show('No device selected.');
//   }
// }
//
// void _disconnect() {
//   bluetooth.disconnect();
//   setState(() => _connected = false);
// }

// Future show(
//     String message, {
//       Duration duration: const Duration(seconds: 3),
//     }) async {
//   await new Future.delayed(new Duration(milliseconds: 100));
//   ScaffoldMessenger.of(context).showSnackBar(
//     new SnackBar(
//       content: new Text(
//         message,
//         style: new TextStyle(
//           color: Colors.white,
//         ),
//       ),
//       duration: duration,
//     ),
//   );
// }
}
