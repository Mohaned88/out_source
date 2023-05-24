import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:dy_app/Models/cashDetModel.dart';
import 'package:dy_app/cashDetails.dart';
import 'package:http/http.dart' as http;


import 'Models/billsDetModel.dart';
import 'Models/billsModel.dart';
import 'Models/usersModel.dart';
import 'databasehelper.dart';

class Controller {
  final conn = SqfliteDatabaseHelper.instance;

  static Future<bool> isInternet()async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      if (await DataConnectionChecker().hasConnection) {
        print("Mobile data detected & internet connection confirmed.");
        return true;
      }else{
        print('No internet :( Reason:');
        return false;
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      if (await DataConnectionChecker().hasConnection) {
        print("wifi data detected & internet connection confirmed.");
        return true;
      }else{
        print('No internet :( Reason:');
        return false;
      }
    }else {
      print("Neither mobile data or WIFI detected, not internet connection found.");
      return false;
    }
  }

  Future<int> addUsersData(Users usersModel)async{
    var dbclient = await conn.db;
   late   int result;
    try {
      result = await dbclient.insert(SqfliteDatabaseHelper.usersTable, usersModel.toJson());
    } catch (e) {
      print(e.toString());
    }
    return  result;
  }
  Future<int> addDetailsData(BillDet BillDetModel)async{
    var dbclient = await conn.db;
    late   int result;
    try {
      result = await dbclient.insert(SqfliteDatabaseHelper.billsDetTable, BillDetModel.toJson());
    } catch (e) {
      print(e.toString());
    }
    return  result;
  }
  Future<int> addCashDetailsData(CashInDetM CashInDet)async{
    var dbclient = await conn.db;
    late   int result;
    try {
      result = await dbclient.insert(SqfliteDatabaseHelper.CashDetTable, CashInDet.toJson());
    } catch (e) {
      print(e.toString());
    }
    return  result;
  }
  Future<int> addBillData(Bills billsModel)async{
    var dbclient = await conn.db;
    late   int result;
    try {
      result = await dbclient.insert(SqfliteDatabaseHelper.billsTable, billsModel.toJson());
    } catch (e) {
      print(e.toString());
    }
    return  result;
  }

  Future<int> updateData(Users usersModel)async{
    var dbclient = await conn.db;
  late  int result;
    try {
      result = await dbclient.update(SqfliteDatabaseHelper.usersTable, usersModel.toJson(),where: 'id=?',whereArgs: [usersModel.id]);
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

  Future fetchData()async{
    var dbclient = await conn.db;
    List userList = [];
    try {
      List<Map<String,dynamic>> maps = await dbclient.rawQuery('select * from users');
      for (var item in maps) {
        userList.add(item);
      }
    } catch (e) {
      print(e.toString());
    }
    return userList;

  }

  Future fetchBillsData()async{
    var dbclient = await conn.db;
    List billList = [];
    try {
      List<Map<String,dynamic>> maps = await dbclient.rawQuery('select * from Bill');
      for (var item in maps) {
        billList.add(item);
      }
    } catch (e) {
      print(e.toString());
    }
    print("get bill done");
    print(billList);
    return billList;

  }
  Future fetchBillDetailsData(int bill_id)async{
    var dbclient = await conn.db;
    List billList = [];
    try {
      List<Map<String,dynamic>> maps = await dbclient.rawQuery('select itemId,unit1Quant,price,finalPrice,total,Item_Name from billsDet  INNER JOIN Items ON itemId = Item_ID where billId = $bill_id  ');
      for (var item in maps) {
        billList.add(item);
      }
    } catch (e) {
      print(e.toString());
    }
    print("get bill details done");
    print(billList);
    return billList;

  }
//all
  Future fetchBillDetailsDataAll()async{
    var dbclient = await conn.db;
    List billList = [];
    try {
      List<Map<String,dynamic>> maps = await dbclient.rawQuery('select * from billsDet');
      for (var item in maps) {
        billList.add(item);
      }
    } catch (e) {
      print(e.toString());
    }
    print("get bill details done");
    print(billList);
    return billList;

  }

  Future fetchCashDetailsData(int transId)async{
    var dbclient = await conn.db;
    List CashDetList = [];
    try {
      List<Map<String,dynamic>> maps = await dbclient.rawQuery('select CashDet.transAccount,CashDet.transId,CashDet.transValue,Organizations.orgName from CashDet inner join Organizations on CashDet.transAccount=Organizations.org_ID where transId = $transId');
      for (var item in maps) {
        CashDetList.add(item);
      }
    } catch (e) {
      print(e.toString());
    }
    print("get Cash details done");
    print(CashDetList);
    return CashDetList;

  }

  Future  fetchItemsData() async{

    var dbclient = await conn.db;
    List itemList = [];
    try {
      List<Map<String,dynamic>> maps = await dbclient.rawQuery('select * from Items');
      for (var item in maps) {
        itemList.add(item);
      }
    } catch (e) {
      print(e.toString());
    }
    print("get items done");
    print(itemList);
    return itemList;
  }

  Future delete()async{
    var dbclient = await conn.db;
    List userList = [];
    try {
      List<Map<String,dynamic>> maps = await dbclient.rawQuery('delete  from users');
      for (var item in maps) {
        userList.add(item);
      }
    } catch (e) {
      print(e.toString());
    }
    return userList;
  }
}

