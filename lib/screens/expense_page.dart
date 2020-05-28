import 'package:built_collection/built_collection.dart';
import 'package:expense_manager/blocs/expense_bloc.dart';
import 'package:expense_manager/db/services/expense_service.dart';
import 'package:expense_manager/models/expense_model.dart';
import 'package:expense_manager/routes/add_expense.dart';
import 'package:flutter/material.dart';

class ExpensePage extends StatefulWidget {
  @override
  _ExpensePageState createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  ExpenseBloc _expenseBloc;
  @override
  initState() {
    super.initState();
    _expenseBloc = ExpenseBloc(ExpenseService());
  }


  @override
  Widget build(BuildContext context) {
    return _getExpenseTab();
  }

  Widget _getExpenseTab() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(12.0),
          width: 200.0,
          child: RaisedButton(
            child: Text("Agregar Gasto"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddExpense(expenseBloc: _expenseBloc,)),
              );
            },
          ),
        ),
        StreamBuilder(
          stream: _expenseBloc.expenseListStream,
          builder:
              (_, AsyncSnapshot<BuiltList<ExpenseModel>> expenseListSnap) {
            if (!expenseListSnap.hasData) return CircularProgressIndicator();

            var lsExpenses = expenseListSnap.data;

            return Expanded(
              child: ListView.builder(
                itemCount: lsExpenses.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  var expense = lsExpenses[index];
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        border: new Border.all(
                            width: 1.0,
                            style: BorderStyle.solid,
                            color: Colors.white)),
                    margin: EdgeInsets.all(12.0),
                    child: ListTile(
                      onTap: () {},
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        color: Theme.of(context).primaryColorLight,
                        onPressed: () => _expenseBloc.deleteExpense(expense.id),
                      ),
                      title: Text(
                        expense.title,
                        style: Theme.of(context)
                            .textTheme
                            .body2
                            .copyWith(color: Theme.of(context).accentColor),
                      ),
                      subtitle: expense.amount == null ? SizedBox() : Text(
                        expense.notes,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        )
      ],
    );
  }
}
