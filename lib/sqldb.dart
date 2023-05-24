// ignore_for_file: avoid_print

import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDb();
      return _db;
    } else {
      return _db;
    }
  }

  initialDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'Dyn.db');
    Database mydb = await openDatabase(path, onCreate: _onCreate, version: 2, onUpgrade: _onUprade);
    return mydb;
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE "notes"(
        id INTEGER NOT NULL PRIMARY KEY,
        note TEXT NOT NULL)
    ''');

    await db.execute('''
        CREATE TABLE "notes"(
        id INTEGER NOT NULL PRIMARY KEY,
        note TEXT NOT NULL)
    ''').then((value) => print("table 2 executed"));
    print(" Create DATABASE AND TABLE =========");
  }

  readData(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  Future<String> deleteDatabase({required String dbname}) async {


    String databasepath=await getDatabasesPath();
    String path = join(databasepath, 'Dyn.db');
    String c=  databaseFactory.deleteDatabase(path).toString();
    return   c;
  }
  deleteTable()async{
    Database? mydb = await db;
    await mydb!.rawQuery("DROP TABLE IF EXISTS notes");
    return print("ok");
  }
  insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  _onUprade(Database db, int oldVersion, int newVersion) {
  }
}
