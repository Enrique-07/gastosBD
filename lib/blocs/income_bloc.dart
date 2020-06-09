import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:expense_manager/db/services/income_service.dart';
import 'package:expense_manager/models/income_model.dart';
import 'package:rxdart/rxdart.dart';

class IncomeBloc {
  final IncomeServiceBase incomeService;

  IncomeBloc(this.incomeService) {
    getIncomes();
  }

  var _createIncomeController = BehaviorSubject<IncomeModel>();
  Stream<IncomeModel> get createIncomeStream =>
      _createIncomeController.stream;

  updateCreateIncome(IncomeModel cat) =>
      _createIncomeController.sink.add(cat);

  var _incomeListController = BehaviorSubject<BuiltList<IncomeModel>>();
  Stream<BuiltList<IncomeModel>> get incomeListStream =>
      _incomeListController.stream;

  getIncomes() {
    incomeService.getAllIncomes().then((cats) {
      _incomeListController.sink.add(cats);
    }).catchError((err) {
      _incomeListController.sink.addError(err);
    });
  }

  Future<int> createNewIncome(IncomeModel income) async {
    return await incomeService.createIncome(income);
  }

  Future<void> deleteIncome(int incomeId) async {
    await incomeService.deleteIncome(incomeId).then((value) {
      //re- create list after delete
      getIncomes();
    });
  }

  dispose() {
    _createIncomeController.close();
    _incomeListController.close();
  }
}