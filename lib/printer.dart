import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controller.dart';
import 'databasehelper.dart';
import 'resources/constants.dart';

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
  double sum = 0.0;

  Future billDetList() async {
    list3 = await Controller().fetchBillDetailsData(widget.id);
    setState(() {
      loading3 = false;
    });
    sum = 0.0;
    for(int i = 0; i< list3.length;i++){
      sum += double.tryParse(list3[i]["total"].toString()) as double;
    }
    print(list3);
  }

  bool loading = true;
  final conn = SqfliteDatabaseHelper.instance;
  List list = [];

  Future billList() async {
    late List ff = [];
    var dbclient = await conn.db;
    List<Map<String, dynamic>> maps = await dbclient.rawQuery(
        'select bill_id,bill_date,customer_id,mandoob_1,orgName from Bill INNER JOIN Organizations ON  customer_id = org_ID where bill_id = ${widget.id}');
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
    final prefs = await SharedPreferences.getInstance();
    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(
              children: [
                pw.SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: pw.Row(
                    mainAxisSize: pw.MainAxisSize.max,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Expanded(
                        flex: 2,
                        child: pw.Column(
                          mainAxisSize: pw.MainAxisSize.max,
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(
                              "التاريخ:",
                              style: pw.TextStyle(
                                fontSize: 8,
                                  font: ttf,
                              ),
                            ),
                            pw.Text(
                              "${list[0]["bill_date"]}",
                              style: pw.TextStyle(
                                fontSize: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                      pw.Expanded(
                        flex: 3,
                        child: pw.Text(
                            AppConstants.customerCompName,
                            style: pw.TextStyle(fontSize: 25, font: ttf),
                            textDirection: pw.TextDirection.rtl,
                          ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Row(
                  mainAxisSize: pw.MainAxisSize.max,
                  children: [
                    pw.Expanded(////////////////////Values
                      child: pw.Column(
                        mainAxisSize: pw.MainAxisSize.max,
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                        children: [
                          pw.Text(
                            "${list[0]["bill_id"]}",
                            style: pw.TextStyle(
                              fontSize: 8,
                            ),
                          ),
                          pw.Text(
                            prefs.getString('mandoub_name') ?? '',
                            style: pw.TextStyle(
                              fontSize: 8,
                              font: ttf,
                            ),
                          ),
                          pw.Text(
                            "${list[0]["orgName"]}",
                            style: pw.TextStyle(fontSize: 6.5, font: ttf),
                            textAlign: pw.TextAlign.center,
                            textDirection: pw.TextDirection.rtl,
                          ),
                        ],
                      ),
                    ),
                    pw.Expanded(/////////////////Names
                      child: pw.Column(
                        mainAxisSize: pw.MainAxisSize.max,
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                        children: [
                          pw.Text(
                            "رقم الفتورة",
                            style: pw.TextStyle(fontSize: 8, font: ttf),
                            textDirection: pw.TextDirection.rtl,
                          ),
                          pw.Text(
                            "اسم المندوب ",
                            style: pw.TextStyle(
                              fontSize: 8,
                              font: ttf,
                            ),
                          ),
                          pw.Text(
                            "اسم العميل ",
                            style: pw.TextStyle(
                              fontSize: 8,
                              font: ttf,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 6),
                pw.Container(
                  color: PdfColors.grey,
                  padding: pw.EdgeInsets.all(3),
                  child: pw.Row(
                    // mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,///////////////////////////
                    mainAxisSize: pw.MainAxisSize.max,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Expanded(
                        flex: 1,
                        child: pw.Text(
                          "Code",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 8,
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          "Name",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 8,
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Text(
                          "price",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 8,
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Text(
                          "quantity",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 8,
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Text(
                          "total",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                pw.Table(
                  border: pw.TableBorder.all(
                    color: PdfColors.black,
                    width: 1,
                  ),
                  children: [
                    for (var i = 0; i < list3.length; i++)
                      pw.TableRow(
                        verticalAlignment: pw.TableCellVerticalAlignment.middle,
                        children: [
                          pw.Expanded(
                            flex: 1,
                            child: pw.Center(
                              child: pw.Text(
                                list3[i]["itemId"].toString(),
                                style: pw.TextStyle(
                                  fontSize: 8,
                                ),
                              ),
                            ),
                          ),

                          pw.Expanded(
                            flex: 2,
                            child: pw.Center(
                              child: pw.Text(
                                list3[i]["Item_Name"].toString(),
                                style: pw.TextStyle(fontSize: 6.5, font: ttf),
                                textAlign: pw.TextAlign.center,
                                textDirection: pw.TextDirection.rtl,
                                maxLines: 3,
                              ),
                            ),
                          ),

                          pw.Expanded(
                            flex: 1,
                            child: pw.Center(
                              child: pw.Text(
                                list3[i]["price"].toString(),
                                style: pw.TextStyle(
                                  fontSize: 8,
                                ),
                              ),
                            ),
                          ),

                          pw.Expanded(
                            flex: 1,
                            child: pw.Center(
                              child: pw.Text(
                                list3[i]["unit1Quant"].toString(),
                                style: pw.TextStyle(
                                  fontSize: 8,
                                ),
                              ),
                            ),
                          ),

                          pw.Expanded(
                            flex: 1,
                            child: pw.Center(
                              child: pw.Text(
                                list3[i]["total"].toString(),
                                style: pw.TextStyle(
                                  fontSize: 8,
                                ),
                              ),
                            ),
                          ),

                          //pw.Divider(thickness: 1),
                        ],
                      ),
                  ],
                ),
                pw.Row(
                  mainAxisSize: pw.MainAxisSize.max,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Expanded(
                      child: pw.Text(
                        '$sum'
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Text(
                          'الاجمالى',
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: ttf,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

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
            ),
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
          canChangePageFormat: true,
          initialPageFormat: PdfPageFormat.roll80,
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
