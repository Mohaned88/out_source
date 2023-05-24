import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Results extends StatefulWidget {
  const Results({Key? key}) : super(key: key);



  @override
  State<Results> createState() => _ResultsState();
}


Future <List<dynamic>>GetGeneralDailyData() async {
  final prefs = await SharedPreferences.getInstance();
  double?  tag  = prefs.getDouble("tag");
  int  ? tagx    = tag?.toInt();
  final String url = "http://sales2563.dynamicsdb2.com/api/Target_Percent/$tagx";
  var response =
  await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
  if (response.statusCode == 200) {
    print("Saving Data ");
    print(response.body);
  } else {
    print(response.statusCode);
  }

   data = jsonDecode(response.body);

  print("get Report");
  print(data);

  return data;
}

List data=[];
@override
void initState() {


  GetGeneralDailyData().then((value) => data);
}

class _ResultsState extends State<Results> {


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: GetGeneralDailyData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // If the API call was successful, build the ListView
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Card(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "المندوب",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE SS Two',
                          ),
                        ),
                        Text(
                          "${snapshot.data![index]["mandoobName"]}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE SS Two',
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "الشهر",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE SS Two',
                          ),
                        ),
                        Text(
                          "${snapshot.data![index]["monthId"]}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE SS Two',
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "اجمالي المبيعات",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE SS Two',
                          ),
                        ),
                        Text(
                          "${snapshot.data![index]["valueTake"].substring(0,8)}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE SS Two',
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "اجمالي المردودات ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE SS Two',
                          ),
                        ),
                        Text(
                          "${snapshot.data![index]["valueAdd"].substring(0,8)}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE SS Two',
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "صافي المبيعات ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE SS Two',
                          ),
                        ),
                        Text(
                          "${snapshot.data![index]["salesNet"].substring(0,8)}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE SS Two',
                          ),
                        )
                      ],
                    )
                    , SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "قيمه الهدف ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE SS Two',
                          ),
                        ),
                        Text(
                          "${double.tryParse(snapshot.data![index]["targetValue"])!.roundToDouble()}"
                          ,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE SS Two',
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "نسبه الهدف الشهري ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE SS Two',
                          ),
                        ),
                        Text(
                          "${double.tryParse(snapshot.data![index]["valuePercent"])!*100}"
                          ,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE SS Two',
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "نقديه خزينة المندوب  ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE SS Two',
                          ),
                        ),
                        Text(
                          "${snapshot.data![index]["safeTotal"]}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE SS Two',
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "رصيد (مديونيه)  ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE SS Two',
                          ),
                        ),
                        Text(
                          "${snapshot.data![index]["balance"]}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE SS Two',
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "اجمالي الخصومات  ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE SS Two',
                          ),
                        ),
                        Text(
                          "${snapshot.data![index]["totaldis"]}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE SS Two',
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          // If the API call was unsuccessful, display an error message
          return Center(
            child: Text('${snapshot.error}'),
          );
        }

        // If the data is still being loaded, show a loading indicator
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
