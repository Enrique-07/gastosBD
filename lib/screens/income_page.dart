import 'package:built_collection/built_collection.dart';
import 'package:expense_manager/blocs/income_bloc.dart';
import 'package:expense_manager/db/services/income_service.dart';
import 'package:expense_manager/models/income_model.dart';
import 'package:expense_manager/routes/add_income.dart';
import 'package:flutter/material.dart';

class IncomePage extends StatefulWidget {
  @override
  _IncomePageState createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  IncomeBloc _incomeBloc;
  @override
  initState() {
    super.initState();
    _incomeBloc = IncomeBloc(IncomeService());
  }


  @override
  Widget build(BuildContext context) {
    return _getIncomeTab();
  }

  Widget _getIncomeTab() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(12.0),
          width: 200.0,
          child: RaisedButton(
            child: Text("Registrar nuevo ingreso"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddIncome(incomeBloc: _incomeBloc,)),
              );
            },
          ),
        ),
        StreamBuilder(
          stream: _incomeBloc.incomeListStream,
          builder:
              (_, AsyncSnapshot<BuiltList<IncomeModel>> incomeListSnap) {
            if (!incomeListSnap.hasData) return CircularProgressIndicator();

            var lsIncomes = incomeListSnap.data;

            return Expanded(
              child: ListView.builder(
                itemCount: lsIncomes.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  var income = lsIncomes[index];
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        border: new Border.all(
                            width: 1.0,
                            style: BorderStyle.solid,
                            color: Colors.white)),
                    margin: EdgeInsets.all(12.0),
                    child: ListTile(
                      isThreeLine: true,
                      onTap: () {},
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        color: Theme.of(context).primaryColorLight,
                        onPressed: () => _incomeBloc.deleteIncome(income.id),
                      ),
                      title: Text(
                        "Ingreso #" + income.id.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .body2
                            .copyWith(color: Theme.of(context).accentColor),
                      ),
                      subtitle: income.amount == null ? SizedBox() : Text(
                        income.title + "\nMonto: " + (income.amount).toString() + " Bs.",
                      )
                      ,
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
