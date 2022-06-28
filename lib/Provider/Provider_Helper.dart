import 'package:audit_p/Model/Model_class.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

class SQLHealper extends ChangeNotifier {
  info _informartion_data = info();


  info get info_model => _informartion_data;

  set info_model(info value) {
    _informartion_data = value;
    notifyListeners();
  }

  static Future<sqlite.Database> db() async {
    return sqlite.openDatabase(
        "information_p.db",
        version: 1,
        onCreate: (sqlite.Database database, int version) {
          database.execute(
              "CREATE TABLE information(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,ChamberName TEXT,PartyName TEXT,Mobile TEXT,Address TEXT,Catg TEXT,Degree TEXT,Bus TEXT,Remark TEXT)");
        }
    );
  }

  Future<int> insertData(BuildContext context,
      SQLHealper _ecommerce_Provider,
      info _informartion_data,) async {
    final db = await SQLHealper.db();
    var values = {
      "ChamberName": info_model.ChamberName,
      "PartyName": info_model.PartyName,
      "Mobile": info_model.Mobile,
      "Address": info_model.Address,
      "Catg": info_model.Catg,
      "Degree": info_model.Degree,
      "Bus": info_model.Bus,
      "Remark": info_model.Remark,
    };
    return db.insert("information", values);
  }

  static Future<List<Map<String, dynamic>>> getAlldata() async {
    final db = await SQLHealper.db();
    return db.query("information", orderBy: "id");
  }


  Future<int> updatetData(BuildContext context,
      SQLHealper _ecommerce_Provider,
      info _informartion_data,
      int id,) async {
    final db = await SQLHealper.db();
    var values = {
      "ChamberName": info_model.ChamberName,
      "PartyName": info_model.PartyName,
      "Mobile": info_model.Mobile,
      "Address": info_model.Address,
      "Catg": info_model.Catg,
      "Degree": info_model.Degree,
      "Bus": info_model.Bus,
      "Remark": info_model.Remark,
    };
    return db.update("information", values, where: "id = ?", whereArgs: [id]);
  }

  Future<int> deletData(int id) async {
    final db = await SQLHealper.db();
    return db.delete("information", where: "id = ?", whereArgs: [id]);
  }

}
