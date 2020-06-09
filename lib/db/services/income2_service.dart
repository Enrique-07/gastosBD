import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:expense_manager/db/offline_db_provider.dart';
import 'package:expense_manager/models/income2_model.dart';
import 'package:expense_manager/models/serializers.dart';
import 'package:flutter/material.dart';

abstract class Income2ServiceBase {
  Future<BuiltList<Income2Model>> getAllIncome2s();
  Future<int> createIncome2(Income2Model income2);
  Future<int> deleteIncome2(int income2Id);
}

class Income2Service implements Income2ServiceBase {

  @override
  Future<int> deleteIncome2(int income2Id) async {
    var db = await OfflineDbProvider.provider.database;
    var result = db.delete("Income2", where: "id = ?", whereArgs: [income2Id]);
    return result;
  }

  @override
  Future<BuiltList<Income2Model>> getAllIncome2s() async {
    var db = await OfflineDbProvider.provider.database;
    var res = await db.query("Income2");
    if (res.isEmpty) return BuiltList();

    var list = BuiltList<Income2Model>();
    res.forEach((cat) {
      var income2 = serializers.deserializeWith<Income2Model>(Income2Model.serializer, cat);
      list = list.rebuild((b) => b..add(income2));
    });

    return list.rebuild((b) => b..sort((a,b) => a.amount.compareTo(b.amount)));
  }

  @override
  Future<int> createIncome2(Income2Model income2) async {
    //check if exists already
    var exists = await income2Exists(income2.id);

    if(exists) return 0;

    var db = await OfflineDbProvider.provider.database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id) as id FROM Income2");
    int id = table.first["id"] == null ? 1 : table.first["id"] + 1;
    //insert to the table using the new id
    var resultId = await db.rawInsert(
        "INSERT Into Income2 (id, title, amount)"
            " VALUES (?,?,?)",
        [id, income2.title, income2.amount]);
    return resultId;
  }

  Future<bool> income2Exists(int id) async {
    var db = await OfflineDbProvider.provider.database;
    var res = await db.query("Income2");
    if (res.isEmpty) return false;

    var entity = res.firstWhere(
            (b) =>
        b["amount"] == id,
        orElse: () => null);

    if (entity == null) return false;

    return entity.isNotEmpty;
  }
}