import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:dy_app/Models/cashDetModel.dart';
import 'package:dy_app/Models/cashModel.dart';
import 'package:dy_app/Models/usersModel.dart';
import 'Models/billsDetModel.dart';
import 'Models/billsModel.dart';
import 'databasehelper.dart';
import 'dart:convert';

import 'package:http/http.dart' as htpp;

class SyncronizationData {
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

  final conn = SqfliteDatabaseHelper.instance;

  //get all bills local
  Future<List<Bills>> fetchAllBills()async{
    final dbClient = await conn.db;
    List<Bills> billsList = [];
    try {
      print("x");
      final maps = await dbClient.rawQuery("select * from Bill where Flag = 0 AND Approve=1");
      for (var item in maps) {
        billsList.add(Bills.fromJson(item) );
        print("x");
        print(item);
      }
    } catch (e) {
      print(e.toString());
    }
    print("sfsssssssss");
    print(billsList);
    return billsList;
  }
//sync bills table to online
  Future saveToMysqlBillsWith(List<Bills> billsList)async{
    print("dsfcsdfsdfsdflsdsd");
    print(billsList);
    for (var i = 0; i < billsList.length; i++) {
      Map<String, dynamic> data = {
        "billId": billsList[i].billId,
        "billDate": billsList[i].billDate,
        "customerId":  billsList[i].customerId,
        "storeId": billsList[i].storeId,
        "employeeId": billsList[i].userId,
        "paperId": "string",
        "operationTypeId": 0,
        "mandoob1":  billsList[i].mandoob1,
        "mandoob2": 0,
        "tax": 0,
        "salesTax": 0,
        "discount": 0,
        "discountVal": 0,
        "totalDiscount": 0,
        "totalBonsDiscount": 0,
        "service": 0,
        "costCenterId": 0,
        "naqd":  billsList[i].naqd,
        "approve":  billsList[i].approve,
        "policyId": 0,
        "pointSaleSystemId": 1,
        "shiftId": 0,
        "userId":  billsList[i].userId,
        "bonsPaied": 0,
        "totalPaied":  billsList[i].totalPaied,
        "totalreset":  billsList[i].totalreset,
        "techCom": 0,
        "doctorCom": 0,
        "deliveryCustomer": 0,
        "inoviceType": "string",
        "taghez": "string",
        "paied": true,
        "flag": 1,
        "tayarId": 0,
        "arriveTime": "string",
        "exTime": "string",
        "tbId": 0,
        "saleSystemId": 0,
        "delivary": 0,
        "totalInvoice":  billsList[i].totalInvoice,
        "totalService": 0,
        "totalSalesTax": 0,
        "sended": true,
        "paymenttype2": "string",
        "paymenttype":  billsList[i].paymenttype,
        "visanumber2": "string",
        "visanumber": "string",
        "lastPaied": 0,
        "safeId2": 0,
        "safeId":  billsList[i].safeId,
        "sharh":  billsList[i].sharh,
        "sarfPrice": 0,
        "totaltax": 0,
        "approxValue": 0,
        "reserved": true,
        "billId2": 0,
        "tasleemDate": "2022-10-01T15:34:40.429Z",
        "tasleemHour": "string",
        "tasleemAddress": "string",
        "bd": 0,
        "qed": 0,
        "log": 0,
        "keyprinttagheez": 0,
        "keyprintinvoices": 0,
        "macId": 0,
        "shiftId2": 0,
        "billIdString": "string",
        "billTime": "string",
        "csbillTime": "string",
        "noBigmem": "string",
        "noSmallmem": "string",
        "branchId": 0,
        "twcustname": "string",
        "twcusttime": "string",
        "delsended": true,
        "startdate":  billsList[i].startdate,
        "enddate":  billsList[i].enddate,
        "ordertime": "string",
        "paydate": "2022-10-01T15:34:40.429Z",
        "payaccpt": true,
        "twcusttele": "string",
        "cardId": 0,
        "cardDis": 0,
        "custCarnee": "string",
        "modifytext": "string",
        "interestvalue": 0,
        "custPlaceid": 0,
        "cancelInstallment": true,
        "interestPaied": 0,
        "noPrintmotabaa": 0,
        "areaId": 0,
        "streetId": 0,
        "description": "string",
        "custIdCard": 0,
        "mark": "string",
        "apartment": "string",
        "role": "string",
        "endTime": "string",
        "paydate2": "2022-10-01T15:34:40.429Z",
        "comments": "string",
        "hotelservice": 0,
        "totalhotelser": 0,
        "hotelbillId": 0,
        "endreservDate": "2022-10-01T15:34:40.429Z",
        "endreservHour": "string",
        "reservesala": true,
        "salaId": 0,
        "roomId": 0,
        "sendedonline": "string",
        "recivedonline": "string",
        "servicevalue": 0

      }
      ;String uri ='http://sales2563.dynamicsdb2.com/api/bill';
      final response = await htpp.post(Uri.parse(uri),body:jsonEncode(data) ,headers: {
        'Content-Type': 'application/json',
      },);
      if (response.statusCode==200 || response.statusCode==201) {
        print("Saving Data ");
        for (var i = 0; i < billsList.length; i++) {
          var dbclient = await conn.db;
          try {
            await dbclient.rawQuery("UPDATE Bill Set Flag = 1");
            print ("updated done");
            print(response.statusCode);
            print(response.reasonPhrase);
          } catch (e) {
            print(e.toString());
          }}
      }else{
        print(response.statusCode);
        print(response.reasonPhrase);
        print(response.body);
      }
    }
  }

  //Cash
  ///////////////////////////

  //get all Cash local
  Future<List<CashInM>> fetchAllCashIns()async{
    final dbClient = await conn.db;
    List<CashInM> cashList = [];
    try {
      print("inside AllCashIns try");
      final maps = await dbClient.rawQuery("select * from Cash where FlagC = 0 AND Approve=1");
      for (var item in maps) {
        cashList.add(CashInM.fromJson(item) );
        print("get All FlagC = 0 in Cash") ;
        print(item);
      }
    } catch (e) {
      print(e.toString());
    }
    print("End All fetchAllCashIns");
    print(cashList);
    return cashList;
  }
//sync bills table to online
  Future saveToMysqlCashWith(List<CashInM> cashList)async{
    print("saveToMysqlCashWith");
    print(cashList);
    for (var i = 0; i < cashList.length; i++) {
      Map<String, dynamic> data = {
        "transId": cashList[i].transId,
        "transDate": cashList[i].transDate,
        //تعديل
        "transPaper": '0',
        "transSafeId": cashList[i].transSafeId,
        "approve": cashList[i].approve,
        "userId": cashList[i].userId,
        "sended": cashList[i].sended,
        "posId": cashList[i].posId,
        "sarfPrice": cashList[i].sarfPrice,
        "employeeId": cashList[i].employeeId,
        "tenderId": cashList[i].tenderId,
        "shiftId": cashList[i].shiftId,
        "sendedonline": cashList[i].sendedonline,
        "recivedonline": cashList[i].recivedonline,
        "invoicenum": cashList[i].invoicenum
      }
      ;String uri ='http://sales2563.dynamicsdb2.com/api/CashIn';
      final response = await htpp.post(Uri.parse(uri),body:jsonEncode(data) ,headers: {
        'Content-Type': 'application/json',
      },);
      if (response.statusCode==200 || response.statusCode==201) {
        print("Saving Data ");
        for (var i = 0; i < cashList.length; i++) {
          var dbclient = await conn.db;
          try {
            await dbclient.rawQuery("UPDATE Cash Set FlagC = 1");
            print ("updated done");
            print(response.statusCode);
            print(response.reasonPhrase);
          } catch (e) {
            print(e.toString());
          }}
      }else{
        print(response.statusCode);
        print(response.reasonPhrase);
        print(response.body);
      }
    }

  }



/////////////////////////



  //Cash det
  ///////////////////////////

//get all Cash local
  Future<List<CashInDetM>> fetchAllCashInDet()async{
    final dbClient = await conn.db;
    List<CashInDetM> cashDetList = [];
    try {
      print("Inside fetchAllCashInDet try ");
      final maps = await dbClient.rawQuery("select * from CashDet where FlagCD = 0");
      for (var item in maps) {
        cashDetList.add(CashInDetM.fromJson(item) );
        print("get All FlagCD = 0 in CashDet") ;
        print(item);
      }
    } catch (e) {
      print(e.toString());
    }

    print(cashDetList);
    return cashDetList;
  }


//sync saveCashDet table to online
  Future saveToMysqlCashDetWith(List<CashInDetM> cashDetList)async{
    print("saveToMysqlCashDetWith");
    print(cashDetList);
    for (var i = 0; i < cashDetList.length; i++) {
      Map<String, dynamic> data = {
        "transId": cashDetList[i].transId,
        "transAccount": cashDetList[i].transAccount,
        "transText": cashDetList[i].transText,
        "transValue": cashDetList[i].transValue,
        "transCostCenter":cashDetList[i].transCostCenter,
        "transPaperId": cashDetList[i].transPaperId,
        "operationId": cashDetList[i].operationId,
        "fileId": cashDetList[i].fileId,
        "userId": cashDetList[i].userId,
        "invoiceId": cashDetList[i].invoiceId,
        "costControlId": cashDetList[i].costControlId,
        "blockId": cashDetList[i].blockId,
        "cheqNumber": cashDetList[i].cheqNumber,
        "installmentNumber": cashDetList[i].installmentNumber,
        "costTime": cashDetList[i].costTime
      }
      ;String uri ='http://sales2563.dynamicsdb2.com/api/CashInDet';
      final response = await htpp.post(Uri.parse(uri),body:jsonEncode(data) ,headers: {
        'Content-Type': 'application/json',
      },);
      if (response.statusCode==200 || response.statusCode==201) {
        print("Saving Data ");
        for (var i = 0; i < cashDetList.length; i++) {
          var dbclient = await conn.db;
          try {
            await dbclient.rawQuery("UPDATE CashDet Set FlagCD = 1");
            print ("updated done");
            print(response.statusCode);
            print(response.reasonPhrase);
          } catch (e) {
            print(e.toString());
          }}
      }else{
        print(response.statusCode);
        print(response.reasonPhrase);
        print(response.body);
      }
    }


  }



/////////////////////////
  //get all bills details local
  Future<List<BillDet>> fetchAllBillsDet()async{
    final dbClient = await conn.db;
    List<BillDet> billsList = [];
    try {
      print("x details");
      final maps = await dbClient.rawQuery("select * from billsDet where Flag = 0 ");
      for (var item in maps) {
        billsList.add(BillDet.fromJson(item) );
        print("x");
        print(item);
      }
    } catch (e) {
      print(e.toString());
    }
    print("end all fetchAllBillsDet");
    print(billsList.length);
    return billsList;
  }
//sync bills details table to online
  Future saveToMysqlBillDetWith(List<BillDet> billsList)async{
    print("saveToMysqlBillDetWith");
    print(billsList.length);
    for (var i = 0; i < billsList.length; i++) {
      Map<String, dynamic> data = {
        "transId": billsList[i].transId,
        "billId": billsList[i].billId.toDouble(),
        "itemId": billsList[i].itemId.toDouble(),
        "unit1Id": 0,
        "unit1Quant": billsList[i].unit1Quant,
        "unit2Id": 0,
        "unit2Quant": 0,
        "unit3Id": 0,
        "unit3Quant": 0,
        "costCenterId": 0,
        "price": billsList[i].price,
        "total": billsList[i].total,
        "discountPercItem": 0,
        "discountValueItem": 0,
        "totalDiscount": 0,
        "service": 0,
        "finalPrice": billsList[i].finalPrice,
        "serial": 0,
        "explain": "string",
        "techCommission": 0,
        "doctorCommission": 0,
        "costPlus": 0,
        "userId": billsList[i].userId,
        "dataNumber": 0,
        "dataText": "string",
        "storeId": 0,
        "orderTime": "string",
        "macId": 0,
        "modify": "string",
        "caseId": 0,
        "mosId": 0,
        "branchId":1 ,
        "cardId": 0,
        "mosdis": 0,
        "finishedmosid": true,
        "billdate": billsList[i].billdate ,
        "taghezzPrintoff": true,
        "callcentertransid": 0,
        "callcenterbillid": 0
    }
      ;String uri ='http://sales2563.dynamicsdb2.com/api/BillDetail';
      final response = await htpp.post(Uri.parse(uri),body:jsonEncode(data) ,headers: {
        'Content-Type': 'application/json',
      },);
      if (response.statusCode==200 || response.statusCode==201) {
        print("Saving Data ");
        for (var i = 0; i < billsList.length; i++) {
          var dbclient = await conn.db;
          try {
            await dbclient.rawQuery("UPDATE billsDet Set Flag = 1");
            print ("updated done");
            print(response.statusCode);
            print(response.reasonPhrase);
          } catch (e) {
            print(e.toString());
          }}
      }else{
        print(response.statusCode);
        print(response.reasonPhrase);
        print(response.body);
      }
    }
  }
///////////////////

  Future <List> GetAllItemsAndSaveSQlite()async{
    String uri ='http://sales2563.dynamicsdb2.com/api/Items/itemSalable';
    final response = await htpp.get(Uri.parse(uri) ,headers: {
      'Content-Type': 'application/json',
    });
    if (response.statusCode==200) {
      print("Saving Data ");
      print(response.body);
    }else{
      // print(response.statusCode);
    }

    List jsonResponse  = jsonDecode(response.body);
    print("GetAllItemsAndSaveSQlite");
    print(jsonResponse);
    final dbclient = await conn.db;
    var sql ="insert into Items (Item_ID,Item_Name,Group_ID,Link_ID,SalesPrice,costprice) Values (?,?,?,?,?,?)";
    jsonResponse.forEach((element) {
      dbclient.rawInsert(sql, [element["itemId"],element["itemName"],element["groupId"],element["linkId"],element["salesPrice"],element["costprice"]]).then((value) => print("done"));
    });

    return jsonResponse;
  }


  Future <List> GetAllTVAndSaveSQlite(String?  ID)async{
    String uri ='http://sales2563.dynamicsdb2.com/api/Organization/$ID';
    final response = await htpp.get(Uri.parse(uri) ,headers: {
      'Content-Type': 'application/json',
    });
    if (response.statusCode==200) {
      print("Saving Data GetAllTVAndSaveSQlite ");
      print(response.body);
    }else{
      // print(response.statusCode);
    }
    List jsonResponse   = jsonDecode(response.body);
    print(jsonResponse);
    final dbclient = await conn.db;
    ////x///////
    var sql ="insert into Organizations ('org_ID',orgName,Mandoub1,address,mobile,govId,areaId) Values (?,?,?,?,?,?,?)";
    jsonResponse.forEach((element) {
      dbclient.rawInsert(sql, [element["orgId"],element["orgName"],element["mandoub1"],element["address"],element["mobile"],element["govId"],element["areaId"]]).then((value) => print("done Org"));
    });
    return jsonResponse;
  }
  Future<List> fetchAllCustomerInfo()async{
    final dbClient = await conn.db;
    List contactList = [];
    try {
      final maps = await dbClient.query(SqfliteDatabaseHelper.usersTable);
      print(maps);
      for (var item in maps) {
        contactList.add(item);
      }
    } catch (e) {
      print(e.toString());
    }
    return contactList;
  }
  Future<List> fetchAllItems()async{
    final dbClient = await conn.db;
    List itemList = [];
    try {
      final maps = await dbClient.rawQuery("select * from items");
      for (var item in maps) {
        itemList.add(item );
      }
    } catch (e) {
      print(e.toString());
    }
    print("called0");
    print(itemList);
    return itemList;
  }

  Future<List> fetchAllItemsByName(String name)async{
    final dbClient = await conn.db;
    List itemList = [];
    try {
      final maps = await dbClient.rawQuery("select * from Items where Item_Name Like '%${name}%'");
      for (var item in maps) {
        itemList.add(item );
      }
    } catch (e) {
      print(e.toString());
    }
    print("called");
    print(itemList);
    return itemList;
  }
  Future<List<Users>> fetchAllInfo()async{
    final dbClient = await conn.db;
    List<Users> contactList = [];
    try {
      final maps = await dbClient.rawQuery("select * from users");
      for (var item in maps) {
        contactList.add(Users.fromJson(item) );
      }
    } catch (e) {
      print(e.toString());
    }
    return contactList;
  }


  // //Sync all users
  // Future saveToMysqlWith(List<Users> usersList)async{
  //   for (var i = 0; i < usersList.length; i++) {
  //     Map<String, dynamic> data = {
  //       "Id":usersList[i].id,
  //       "FirstName":usersList[i].firstName.toString(),
  //       "LastName":usersList[i].firstName.toString(),
  //       "mac":usersList[i].mac,
  //       "Role":usersList[i].role.toString(),
  //       "City":usersList[i].city.toString(),
  //     };String uri ='http://sales2563.dynamicsdb2.com/api/Users';
  //     final response = await htpp.post(Uri.parse(uri),body:jsonEncode(data) ,headers: {
  //       'Content-Type': 'application/json',
  //     },);
  //     if (response.statusCode==200) {
  //       print("Saving Data ");
  //     }else{
  //       print(response.statusCode);
  //     }
  //   }
  // }

//   Future <List> GetAllUsersAndSaveSQlite()async{
//     String uri ='http://sales2563.dynamicsdb2.com/api/Users';
//       final response = await htpp.get(Uri.parse(uri) ,headers: {
//         'Content-Type': 'application/json',
//       });
//       if (response.statusCode==200) {
//         print("Saving Data ");
//         //print(response.body);
//       }else{
//        // print(response.statusCode);
//       }
//    List jsonResponse   = jsonDecode(response.body);
// print(jsonResponse);
// print ("Cc");
//     final dbclient = await conn.db;
//     var sql ="insert into users (id,lastName,firstName,city,role,mac) Values (?,?,?,?,?,?)";
//     jsonResponse.forEach((element) {
//       dbclient.rawInsert(sql, [element["id"],element["lastName"],element["firstName"],element["city"],element["mac"]]).then((value) => print("done"));
//     });
//
//     return jsonResponse;
//   }



}