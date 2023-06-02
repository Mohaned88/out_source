import 'package:flutter/material.dart';

class GeneralDailyRepShow extends StatefulWidget {
  GeneralDailyRepShow({Key? key, required this.data}) : super(key: key);
  List data;

  @override
  State<GeneralDailyRepShow> createState() => _GeneralDailyRepShowState();
}

class _GeneralDailyRepShowState extends State<GeneralDailyRepShow> {
  List data = [];

  @override
  void initState() {
    data = widget.data;

    super.initState();
  }

  // Future<List<dynamic>> get() async {
  //   return data;
  // }

  @override
  Widget build(BuildContext context) {
    return   SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              child: DataTable(
                border: TableBorder.all(),
                columnSpacing: 10.0,
                dataRowHeight: 100.0,
                columns: [
                  DataColumn(label: Text('الرصيد')),
                  DataColumn(label: Text('عليه')),
                  DataColumn(label: Text('له')),
                  DataColumn(label: Text('تاريخ المعامله')),
                  DataColumn(label: Text('شرح المعامله')),
                ],
                rows: List.generate(data.length, (index) {
                  final b = data[index]["qedId"];
                  final d =data[index]["from"];
                  final e = data[index]["to"];
                  final f = data[index]["qeddate"].toString().substring(0,10);
                  final g = data[index]["sharh"];
                  final x= double.tryParse(data[index]["balance"].toString())!.round();
                  return DataRow(cells: [
                    DataCell(Container(child: Text("$x"))),
                    DataCell(Container(child: Text("$d"))),
                    DataCell(Container( child: Text("$e"))),
                    DataCell(Container( child: Text("$f"))),
                    DataCell(Container( child: Text("$g"))),

                  ]);
                }),
              ),
            ),
          ),
        ],
      ),
    );
    // return FutureBuilder<List<dynamic>>(
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
    //                       "رقم قيد المعامله",
    //                       style: TextStyle(
    //                         fontSize: 16,
    //                         fontWeight: FontWeight.bold,
    //                         fontFamily: 'GE SS Two',
    //                       ),
    //                     ),
    //                     Text(
    //                       "${snapshot.data![index]["qedId"]}",
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
    //                       "تاريخ المعامله",
    //                       style: TextStyle(
    //                         fontSize: 16,
    //                         fontWeight: FontWeight.bold,
    //                         fontFamily: 'GE SS Two',
    //                       ),
    //                     ),
    //                     Text(
    //                       "${snapshot.data![index]["qeddate"]}",
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
    //                       "شرح ",
    //                       style: TextStyle(
    //                         fontSize: 16,
    //                         fontWeight: FontWeight.bold,
    //                         fontFamily: 'GE SS Two',
    //                       ),
    //                     ),
    //                     Text(
    //                       "${snapshot.data![index]["sharh"]}",
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
    //                       "له ",
    //                       style: TextStyle(
    //                         fontSize: 16,
    //                         fontWeight: FontWeight.bold,
    //                         fontFamily: 'GE SS Two',
    //                       ),
    //                     ),
    //                     Text(
    //                       "${snapshot.data![index]["to"]}",
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
    //                       "عليه ",
    //                       style: TextStyle(
    //                         fontSize: 16,
    //                         fontWeight: FontWeight.bold,
    //                         fontFamily: 'GE SS Two',
    //                       ),
    //                     ),
    //                     Text(
    //                       "${snapshot.data![index]["from"]}",
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
    //
  }
}