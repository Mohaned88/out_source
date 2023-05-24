// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
//
// import 'package:dy_app/controller.dart';
// import 'package:dy_app/syncronize.dart';
//
// import 'databasehelper.dart';
//
// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   await SqfliteDatabaseHelper.instance.db;
//   runApp(MyApp());
//   configLoading();
// }
//
// void configLoading() {
//   EasyLoading.instance
//     ..displayDuration = const Duration(milliseconds: 2000)
//     ..indicatorType = EasyLoadingIndicatorType.fadingCircle
//     ..loadingStyle = EasyLoadingStyle.dark
//     ..indicatorSize = 45.0
//     ..radius = 10.0
//     ..progressColor = Colors.yellow
//     ..backgroundColor = Colors.green
//     ..indicatorColor = Colors.yellow
//     ..textColor = Colors.yellow
//     ..maskColor = Colors.blue.withOpacity(0.5)
//     ..userInteractions = true
//     ..dismissOnTap = false;
//     //..customAnimation = CustomAnimation();
// }
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Sync Sqflite to Mysql',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//       debugShowCheckedModeBanner: false,
//       builder: EasyLoading.init(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   Timer ?_timer;
//   TextEditingController name = TextEditingController();
//   TextEditingController email = TextEditingController();
//   TextEditingController gender = TextEditingController();
//
//   List ?list;
//   bool loading = true;
//   Future userList()async{
//     list = await Controller().fetchData();
//     setState(() {loading=false;});
//     //print(list);
//   }
//
//   Future syncToMysql()async{
//       await SyncronizationData().fetchAllInfo().then((userList)async{
//         EasyLoading.show(status: 'Dont close app. we are sync...');
//         await SyncronizationData().saveToMysqlWith(userList);
//         EasyLoading.showSuccess('Successfully save to mysql');
//       });
//   }
//
//   Future isInteret()async{
//     await SyncronizationData.isInternet().then((connection){
//       if (connection) {
//
//         print("Internet connection abailale");
//       }else{
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No Internet")));
//       }
//     });
//   }
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     userList();
//     isInteret();
//     EasyLoading.addStatusCallback((status) {
//       print('EasyLoading Status $status');
//       if (status == EasyLoadingStatus.dismiss) {
//         _timer?.cancel();
//       }
//     });
//
//
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Sync Sqflite to Mysql"),
//         actions: [
//           IconButton(icon: Icon(Icons.refresh_sharp), onPressed: ()async{
//             await SyncronizationData.isInternet().then((connection){
//               if (connection) {
//                 syncToMysql();
//                 print("Internet connection abailale");
//               }else{
//                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No Internet")));
//               }
//             });
//           })
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: name,
//               decoration: InputDecoration(hintText: 'Enter name'),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: email,
//               decoration: InputDecoration(hintText: 'Enter email'),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: gender,
//               decoration: InputDecoration(hintText: 'Enter gender'),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: RaisedButton(
//               onPressed: () async{
//                 ContactinfoModel contactinfoModel = ContactinfoModel(userId: 1,name: name.text,email: email.text,gender: gender.text,createdAt: DateTime.now().toString());
//                 await Controller().addData(contactinfoModel).then((value){
//                   if (value>0) {
//                     print("Success");
//                     userList();
//                   }else{
//                     print("faild");
//                   }
//
//                 });
//               },
//               child: Text("Save"),
//             ),
//           ),
//           loading ?Center(child: CircularProgressIndicator()):Expanded(
//             child: ListView.builder(
//                 itemCount: list?.length ?? 0,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                       Text(list![index]['id'].toString()),
//                       SizedBox( width: 5,),
//                       Text(list![index]['name']),
//                     ],),
//                     subtitle: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                       Text(list![index]['email']),
//                       Text(list![index]['gender']),
//                     ],),
//                     );
//                 },
//               ),
//           ),
//         ],
//       ),
//     );
//   }
// }




////////////////////////////

// import 'dart:convert';
// import 'package:dy_app/sqldb.dart';
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter/foundation.dart';
//
// void main() async {
//   await Hive.initFlutter();
//   runApp(const MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Bill'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   SqlDb sqldb = SqlDb();
//   List<Map> x = [];
//   Box? box;
//   List dataH = [];
//
//   Future openBox() async {
//     var dir = await getApplicationDocumentsDirectory();
//     Hive.init(dir.path);
//     box = await Hive.openBox('items');
//     return;
//   }
//
//   getAllData() async {
//     await openBox();
//     String url = "http://dynamics007-001-site1.atempurl.com/api/items";
//     try {
//       var response = await http.get(Uri.parse(url));
//       var _jsonDecode = jsonDecode(response.body);
//       await putData(_jsonDecode);
//       print(_jsonDecode);
//     } catch (SocketException) {
//       print("No Internet");
//     }
//   }
//
//   Future<bool> putData(data) async {
//     await box!.clear();
//     for (var d in data) {
//       box!.add(d);
//     }
//     var myData = box!.toMap().values.toList();
//       dataH = (myData);
//     return Future.value(true);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final c1 = TextEditingController();
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             FutureBuilder(
//               future: getAllData(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   if (dataH.contains("empty")) {
//                     return const Text("no data ");
//                   } else {
//                     return Expanded(child: ListView.builder(
//                 itemCount: dataH.length,
//                       itemBuilder: (c,index){
//                     return ListTile(
//                       title: Text("${dataH[index]["itemName"]}"),
//                     );
//                       },
//
//                     ));
//                   }
//                 } else {
//                   return const CircularProgressIndicator();
//                 }
//               },
//             ),
//             MaterialButton(
//                 color: Colors.red,
//                 child: const Text("delete DB"),
//                 onPressed: () {
//                   sqldb.deleteDatabase(dbname: 'dyn.db');
//                 }),
//             MaterialButton(
//                 color: Colors.green,
//                 child: const Text("get values"),
//                 onPressed: () async {
//                   x = await sqldb.readData("select  * from notes");
//                   setState(() {
//                     x = this.x;
//                   });
//                 }),
//             TextField(
//               controller: c1,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 hintText: 'Enter a data',
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           getAllData();
//           // int x = await sqldb
//           //     .insertData("insert into 'notes' ('note')values('${c1.text}')");
//           print(x);
//         },
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }