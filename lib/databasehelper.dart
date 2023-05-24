import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqfliteDatabaseHelper {
  SqfliteDatabaseHelper.internal();

  static final SqfliteDatabaseHelper instance =
      new SqfliteDatabaseHelper.internal();

  factory SqfliteDatabaseHelper() => instance;
  static final billsTable = 'Bill';
  static final usersTable = 'users';
  static final itemsTable = 'Items';
  static final billsDetTable = 'billsDet';
  static final OrganizationsTable = 'Organizations';
  static final CashTable = 'Cash';
  static final CashDetTable = 'CashDet';
  static final _version = 1;
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, 'syncdatabasebeta1.db');
    print(dbPath);
    var openDb = await openDatabase(dbPath, version: _version,
        onCreate: (Database db, int version) async {
      //usersTable
      await db.execute("""
        CREATE TABLE $usersTable (
	Id INTEGER PRIMARY KEY NOT NULL,
	LastName TEXT,
	FirstName TEXT,
	City TEXT,
	Role TEXT,
	mac INT)
""");
      //   default (datetime(current_timestamp)),
      //BillTable
      await db.execute("""
               CREATE TABLE $billsTable (       
	bill_id	INTEGER NOT NULL UNIQUE,
	bill_date	TEXT NOT NULL ,
	customer_id	INTEGER NOT NULL DEFAULT 0,
	store_id	INTEGER NOT NULL DEFAULT 0,
	mandoob_1	INTEGER NOT NULL DEFAULT 0,
	naqd	INTEGER NOT NULL DEFAULT 1,
	approve	INTEGER NOT NULL DEFAULT 0,
	user_id	INTEGER NOT NULL DEFAULT 0,
	totalPaid	REAL NOT NULL DEFAULT 0,
	totalReset	REAL NOT NULL DEFAULT 0,
	totalInvoice	REAL NOT NULL DEFAULT 0,
	paymenttype	TEXT NOT NULL DEFAULT 'نقدي',
	safe	INTEGER NOT NULL DEFAULT 0,
	sharh	TEXT NOT NULL DEFAULT 'فاتورة رقم',
	startdate	TEXT NOT NULL default (datetime(current_timestamp)),
	enddate	TEXT  NOT NULL default (datetime(current_timestamp)),
	flag TEXT  NOT NULL default 0,
	PRIMARY KEY("bill_id" AUTOINCREMENT))
      """);
      //ItemsTable
      await db.execute("""
      CREATE TABLE $itemsTable (
	Item_ID	INTEGER NOT NULL UNIQUE,
	Item_Name	TEXT NOT NULL,
	Group_ID	INTEGER NOT NULL,
	Link_ID	TEXT NOT NULL,
	SalesPrice	REAL NOT NULL,
	costprice	REAL NOT NULL)

      """).then((value) => print("Item table done"));
//BillDetails

      await db.execute("""
   CREATE TABLE $billsDetTable (
   "transId"	INTEGER NOT NULL UNIQUE ,
	"billId"	REAL NOT NULL,
	"itemId"	REAL NOT NULL,
	"unit1Quant"	REAL,
	"price"	REAL NOT NULL,
	"total"	REAL NOT NULL,
	"finalPrice"	REAL NOT NULL,
	"billdate"	TEXT NOT NULL,
	"storeId"	INTEGER NOT NULL,
	"userId"	INTEGER NOT NULL,
	flag TEXT  NOT NULL default 0,
	PRIMARY KEY("transId" AUTOINCREMENT)
)
      """).then((value) => print("bills details table done"));

      //Tv
      await db.execute("""
      CREATE TABLE $OrganizationsTable (
  "org_ID"	INTEGER  ,
	"orgName"	TEXT  ,
	"Mandoub1"	REAL  ,
	"address"	TEXT,
	"mobile"	TEXT ,
	"govId"	TEXT ,
	"areaId" TEXT
)
      """).then((value) => print("Organization table done"));

      await db.execute("""
               CREATE TABLE $CashTable (       
  "transId"  INTEGER NOT NULL UNIQUE,
  "transDate" TEXT NOT NULL,
  "transPaper" TEXT NOT NULL DEFAULT 0,
  "transSafeId" INTEGER NOT NULL DEFAULT 0,
  "approve" INTEGER NOT NULL DEFAULT 0,
  "userId" INTEGER NOT NULL DEFAULT 0,
  "sended" INTEGER NOT NULL DEFAULT 0,
  "posId" INTEGER NOT NULL DEFAULT 1,
  "sarfPrice" INTEGER NOT NULL DEFAULT 0,
  "employeeId" INTEGER NOT NULL DEFAULT 0,
  "tenderId" INTEGER NOT NULL DEFAULT 0 ,
  "shiftId" INTEGER NOT NULL DEFAULT 0,
  "sendedonline"  TEXT NOT NULL,
  "recivedonline"  TEXT NOT NULL,
  "invoicenum"  TEXT NOT NULL,
  flagC TEXT  NOT NULL default 0
  )
      """).then((value) => print("CashIn table done"));

      await db.execute("""
               CREATE TABLE $CashDetTable (       
  "transId" INTEGER NOT NULL DEFAULT 0,
  "transAccount"  INTEGER NOT NULL DEFAULT 0,
  "transText" TEXT NOT NULL,
  "transValue" INTEGER NOT NULL DEFAULT 0,
  "transCostCenter"  INTEGER NOT NULL DEFAULT 0,
  "transPaperId" TEXT NOT NULL,
  "operationId" INTEGER NOT NULL DEFAULT 0,
  "fileId" INTEGER NOT NULL DEFAULT 0,
  "userId" INTEGER NOT NULL DEFAULT 0,
  "invoiceId" INTEGER NOT NULL DEFAULT 0,
  "costControlId" INTEGER NOT NULL DEFAULT 0,
  "blockId" INTEGER NOT NULL DEFAULT 0,
  "cheqNumber" TEXT NOT NULL,
  "installmentNumber" INTEGER NOT NULL DEFAULT 0,
  "costTime" TEXT NOT NULL,
  flagCD TEXT  NOT NULL default 0
  )
   """).then((value) => print("CashInDetails table done"));
    }, onUpgrade: (Database db, int oldversion, int newversion) async {
      if (oldversion < newversion) {
        print("Version Upgrade");
      }
    });
    print('db initialize');
    return openDb;
  }
}
