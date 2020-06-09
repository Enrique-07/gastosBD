import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:expense_manager/db/services/income2_service.dart';
import 'package:expense_manager/models/income2_model.dart';
import 'package:rxdart/rxdart.dart';

class Income2Bloc {
  final Income2ServiceBase income2Service;

  Income2Bloc(this.income2Service) {
    getIncome2s();
  }

  var _createIncome2Controller = BehaviorSubject<Income2Model>();
  Stream<Income2Model> get createIncome2Stream =>
      _createIncome2Controller.stream;

  updateCreateIncome2(Income2Model cat) =>
      _createIncome2Controller.sink.add(cat);

  var _income2ListController = BehaviorSubject<BuiltList<Income2Model>>();
  Stream<BuiltList<Income2Model>> get income2ListStream =>
      _income2ListController.stream;

  getIncome2s() {
    income2Service.getAllIncome2s().then((cats) {
      _income2ListController.sink.add(cats);
    }).catchError((err) {
      _income2ListController.sink.addError(err);
    });
  }

  Future<int> createNewIncome2(Income2Model income2) async {
    return await income2Service.createIncome2(income2);
  }

  Future<void> deleteIncome2(int income2Id) async {
    await income2Service.deleteIncome2(income2Id).then((value) {
      //re- create list after delete
      getIncome2s();
    });
  }

  dispose() {
    _createIncome2Controller.close();
    _income2ListController.close();
  }
}