import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:expense_manager/db/offline_db_provider.dart';
import 'package:expense_manager/models/income_model.dart';
import 'package:expense_manager/models/serializers.dart';
import 'package:flutter/material.dart';

abstract class IncomeServiceBase {
  Future<BuiltList<IncomeModel>> getAllIncomes();
  Future<int> createIncome(IncomeModel income);
  Future<int> deleteIncome(int incomeId);
}

class IncomeService implements IncomeServiceBase {

  @override
  Future<int> deleteIncome(int incomeId) async {
    var db = await OfflineDbProvider.provider.database;
    var result = db.delete("Income", where: "id = ?", whereArgs: [incomeId]);
    return result;
  }

  @override
  Future<BuiltList<IncomeModel>> getAllIncomes() async {
    var db = await OfflineDbProvider.provider.database;
    var res = await db.query("Income");
    if (res.isEmpty) return BuiltList();

    var list = BuiltList<IncomeModel>();
    res.forEach((cat) {
      var income = serializers.deserializeWith<IncomeModel>(IncomeModel.serializer, cat);
      list = list.rebuild((b) => b..add(income));
    });

    return list.rebuild((b) => b..sort((a,b) => a.amount.compareTo(b.amount)));
  }

  @override
  Future<int> createIncome(IncomeModel income) async {
    //check if exists already
    var exists = await incomeExists(income.id);

    if(exists) return 0;

    var db = await OfflineDbProvider.provider.database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id) as id FROM Income");
    int id = table.first["id"] == null ? 1 : table.first["id"] + 1;
    //insert to the table using the new id
    var resultId = await db.rawInsert(
        "INSERT Into Income (id, title, amount)"
            " VALUES (?,?,?)",
        [id, income.title, income.amount]);
    return resultId;
  }

  Future<bool> incomeExists(int id) async {
    var db = await OfflineDbProvider.provider.database;
    var res = await db.query("Income");
    if (res.isEmpty) return false;

    var entity = res.firstWhere(
            (b) =>
        b["amount"] == id,
        orElse: () => null);

    if (entity == null) return false;

    return entity.isNotEmpty;
  }
}