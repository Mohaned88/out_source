// import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
//import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:flutter/services.dart';
// import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'dart:async';

// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'controller.dart';
import 'databasehelper.dart';
import 'resources/constants.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

class Printer extends StatefulWidget {
  int id;

  Printer({required this.id, Key? key}) : super(key: key);

  @override
  State<Printer> createState() => _PrinterState();
}

class _PrinterState extends State<Printer> {
 BluetoothManager bluetoothManager = BluetoothManager.instance;
  PrinterBluetoothManager _printerManager = PrinterBluetoothManager();

  //BluetoothDevice _device;
  List<PrinterBluetooth> _devices = [];
  String? _devicesMsg;

//////////////////////////////////////////////////////////////////////////////////////

  void initPrinter() {
    _printerManager.startScan(Duration(seconds: 5));
    _printerManager.scanResults.listen((val) {
      if (!mounted) return;
      setState(() => _devices = val);
      if (_devices.isEmpty) {
        setState(() => _devicesMsg = 'No Devices');
      }
    });
  }

  @override
  void initState() {
    //initPrinter();
    bluetoothManager.state.listen((val) {
      if (!mounted) return;
      if(val == 12){
        print('on');
        initPrinter();
      }
      else if(val ==10){
        print('off');
        setState(() {
          _devicesMsg = 'Bluetooth Disconnected!';
        });
      }
    });
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
    for (int i = 0; i < list3.length; i++) {
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

/*
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
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('esc_pos_bluetooth'),
      ),
      body: _devices.isEmpty
          ? Center(
              child: Text(_devicesMsg ?? ''),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                    leading: Icon(Icons.print),
                    title: Text(_devices[index].name!),
                    subtitle: Text(_devices[index].address!),
                    onTap: () {
                      //////////////
                      _startPrinter(_devices[index]);
                    });
              },
            ),
    );
  }

  Future<void> _startPrinter(PrinterBluetooth printer) async {
    _printerManager.selectPrinter(printer);
    final result = await _printerManager.printTicket(await _ticket(PaperSize.mm80));
    showDialog(context: context, builder: (_)=> AlertDialog(
      content: Text(result.msg),
    ),);
  }

  Future<List<int>> _ticket(PaperSize paper) async {
    final profile = await CapabilityProfile.load();
    final Generator ticket = Generator(paper, profile);
    final prefs = await SharedPreferences.getInstance();
    final formatter = DateFormat('MM/dd/yyyy H:m');
    final String timestamp = formatter.format(list[0]["bill_date"]);
    List<int> bytes = [];
    bytes += ticket.row([
      PosColumn(
        text: AppConstants.customerCompName,
        width: 2,
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
      ),
      PosColumn(
        text: '$timestamp التاريخ: \n ',
        width: 2,
        styles: PosStyles(align: PosAlign.right),
      ),
    ]);
    //////////////////////////////////////////
    bytes += ticket.row([
      PosColumn(
        text: list[0]['bill_id'],
        width: 2,
        styles: PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: 'رقم الفتورة',
        width: 2,
        styles: PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += ticket.row([
      PosColumn(
        text: prefs.getString('mandoub_name') ?? '',
        width: 2,
        styles: PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: "اسم المندوب ",
        width: 2,
        styles: PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += ticket.row([
      PosColumn(
        text: list[0]['orgName'],
        width: 2,
        styles: PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: "اسم العميل ",
        width: 2,
        styles: PosStyles(align: PosAlign.right),
      ),
    ]);
    /////////////////////////////////////
    bytes += ticket.hr();
    bytes += ticket.row([
      PosColumn(text: 'Code', width: 2),
      PosColumn(text: 'Name', width: 5),
      PosColumn(
          text: 'Price', width: 2, styles: PosStyles(align: PosAlign.right)),
      PosColumn(
          text: 'Qty', width: 2, styles: PosStyles(align: PosAlign.right)),
      PosColumn(
          text: 'Total', width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);
    bytes += ticket.hr();
    //////////////////////////////////////
    for(int i=0;i < list3.length;i++){
      bytes += ticket.row([
        PosColumn(text: list3[i]["itemId"].toString(), width: 2),
        PosColumn(text:  list3[i]["Item_Name"].toString(), width: 5),
        PosColumn(
            text: list3[i]["price"].toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
        PosColumn(
            text: list3[i]["unit1Quant"].toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
        PosColumn(
            text:  list3[i]["total"].toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
      ]);
    }
    bytes += ticket.hr();
    bytes += ticket.hr();
    ///////////////////////////////////
    bytes += ticket.row([
      PosColumn(text: '$sum', width: 6,
          styles: PosStyles(
            height: PosTextSize.size2,
            width: PosTextSize.size2,
            align: PosAlign.left,
          )),
      PosColumn(text:  'الاجمالى:', width: 6,
          styles: PosStyles(
            height: PosTextSize.size2,
            width: PosTextSize.size2,
            align: PosAlign.right,
          )),
    ]);
    bytes += ticket.hr();
    bytes += ticket.feed(2);
    ticket.cut();
    return bytes;

    /*final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    return generator;*/
  }

  @override
  void dispose() {
    _printerManager.stopScan();
    super.dispose();
  }
}

/*
* Widget build(BuildContext context) {
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
* */
