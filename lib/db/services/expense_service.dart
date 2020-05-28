import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:expense_manager/db/offline_db_provider.dart';
import 'package:expense_manager/models/expense_model.dart';
import 'package:expense_manager/models/serializers.dart';
import 'package:flutter/material.dart';

abstract class ExpenseServiceBase {
  Future<BuiltList<ExpenseModel>> getAllExpenses();
  Future<int> createExpense(ExpenseModel expense);
  Future<int> deleteExpense(int expenseId);
}

class ExpenseService implements ExpenseServiceBase {

  @override
  Future<int> deleteExpense(int categoryId) async {
    var db = await OfflineDbProvider.provider.database;
    var result = db.delete("Expense", where: "id = ?", whereArgs: [categoryId]);
    return result;
  }

  @override
  Future<BuiltList<ExpenseModel>> getAllExpenses() async {
    var db = await OfflineDbProvider.provider.database;
    var res = await db.query("Expense");
    if (res.isEmpty) return BuiltList();

    var list = BuiltList<ExpenseModel>();
    res.forEach((cat) {
      var category = serializers.deserializeWith<ExpenseModel>(ExpenseModel.serializer, cat);
      list = list.rebuild((b) => b..add(category));
    });

    return list.rebuild((b) => b..sort((a,b) => a.title.compareTo(b.title)));
  }

  @override
  Future<int> createExpense(ExpenseModel expense) async {
    //check if exists already
    var exists = await ExpenseExists(expense.title);

    if(exists) return 0;

    var db = await OfflineDbProvider.provider.database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id) as id FROM Expense");
    int id = table.first["id"] == null ? 1 : table.first["id"] + 1;
    //insert to the table using the new id
    var resultId = await db.rawInsert(
        "INSERT Into Expense (id, categoryId, title, notes, amount)"
            " VALUES (?,?,?,?,?)",
        [id, expense.categoryId, expense.title, expense.notes, double.parse(expense.amount.toString())]);
    return resultId;
  }

  Future<bool> ExpenseExists(String title) async {
    var db = await OfflineDbProvider.provider.database;
    var res = await db.query("Expense");
    if (res.isEmpty) return false;

    var entity = res.firstWhere(
            (b) =>
        b["title"] == title,
        orElse: () => null);

    if (entity == null) return false;

    return entity.isNotEmpty;
  }
}
