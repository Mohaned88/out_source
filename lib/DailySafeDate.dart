import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'dailySafe.dart';

class dailySafeDate extends StatefulWidget {
  const dailySafeDate({Key? key}) : super(key: key);

  @override
  State<dailySafeDate> createState() => _dailySafeDateState();
}

class _dailySafeDateState extends State<dailySafeDate> {
  String? date2;
  String? getDate;

  Future<String?> pickdate() async {
    DateTime? time = await showDatePicker(
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2050),
        context: context);
    print(time);
    date2 = time.toString().substring(0, 10);
    return date2;
  }

  @override
  void initState() {
    final DateTime now = DateTime.now();
    final intl.DateFormat formatter = intl.DateFormat('yyyy-MM-dd');
    final String time = formatter.format(now);
    getDate = time.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    return Scaffold(
      appBar: AppBar(title: Text("اختر تاريخ ")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "من فضلك ادخل تاريخ اليوم ",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'GE SS Two',
            ),
            textDirection: TextDirection.rtl,
          ),
          Center(
            child: Container(
              child: StatefulBuilder(
                key: _scaffoldKey,
                builder: (BuildContext context, StateSetter set) {
                  return Padding(
                    padding: EdgeInsets.all(5),
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
                        SizedBox(width: 1),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: IconButton(
                            onPressed: () async {
                              pickdate().then((String? value) {
                                set(() {
                                  getDate = value!.toString();
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
                          child: Text("${getDate}"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DailySafe(date: getDate)));
              },
              child: Text("اعرض"))
        ],
      ),
    );
  }
}
