import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'databasehelper.dart';
import 'package:http/http.dart' as http;

class InsertBill extends StatefulWidget {
  const InsertBill({Key? key}) : super(key: key);

  @override
  State<InsertBill> createState() => _InsertBillState();
}

class _InsertBillState extends State<InsertBill> {
  String? _mySelection;
  final conn = SqfliteDatabaseHelper.instance;
  String? getDate;
  String? date2;
  List data = [];

  Future getSWData() async {
    final String url =
        "http://dynamics007-001-site1.atempurl.com/api/tvs/40000";
    var response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      print("Saving Data ");
      //   print(response.body);
    } else {
      // print(response.statusCode);
    }
    List jsonResponse = jsonDecode(response.body);
    print("get custs");
    print(jsonResponse);

    setState(() {
      data = jsonResponse;

      _mySelection = data[0]['tag'].toString();
    });

    print(response.body);

    return jsonResponse;
  }

  @override
  void initState() {
    getSWData().then(
      (value) {
        setState(data = value);
        _mySelection = value[0]['tag'];
      },
    );
    final DateTime now = DateTime.now();
    final intl.DateFormat formatter = intl.DateFormat('yyyy-MM-dd');
    final String time = formatter.format(now);
    getDate = time;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<DateTime?> pickdate() async {
      DateTime? time = await showDatePicker(
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2050),
          context: context);
      print(time);

      date2 = time.toString().substring(0, 10);
      return time;
    }

    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    final GlobalKey<ScaffoldState> _scaffoldKey1 =
        new GlobalKey<ScaffoldState>();

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          StatefulBuilder(
            key: _scaffoldKey,
            builder: (BuildContext context, StateSetter set) {
              return Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      child: Text(
                        "تاريخ الفاتورة",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'GE SS Two',
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    Container(
                      child: Icon(Icons.date_range),
                    ),
                    SizedBox(width: 2),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: IconButton(
                        onPressed: () async {
                          pickdate().then((DateTime? value) {
                            set(() {
                              getDate = value.toString();
                            });
                          });
                        },
                        icon: Icon(Icons.timer),
                        color: Colors.blueAccent,
                        tooltip: 'تاريخ الفاتورة ',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 1.0),
                      child: Text(getDate!),
                    )
                  ],
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: StatefulBuilder(
              key: _scaffoldKey1,
              builder: (BuildContext context, StateSetter set) {
                return Row(
                  children: <Widget>[
                    Text(
                      'اسم العميل: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GE SS Two',
                      ),
                    ),
                    Container(
                      child: Icon(Icons.person),
                    ),
                    SizedBox(width: 6),
                    Center(
                      child:
                      DropdownButton(
                        value: _mySelection,
                        onChanged: (value) {
                          setState(() {
                            _mySelection = value.toString();
                            print(_mySelection);
                          });
                        },
                        items: data.map(
                          (item) {
                            return DropdownMenuItem(
                              value: item["tag"].toString(),
                              child: new Text(item['text'].toString()),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            child: MaterialButton(
              child: Text("gghhh"),
              onPressed: () async {},
            ),
          ),
        ],
      ),
    );
  }
}
