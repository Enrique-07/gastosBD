import 'package:built_collection/built_collection.dart';
import 'package:expense_manager/blocs/income2_bloc.dart';
import 'package:expense_manager/db/services/income2_service.dart';
import 'package:expense_manager/models/income2_model.dart';
import 'package:expense_manager/routes/add_income2.dart';
import 'package:flutter/material.dart';

class Income2Page extends StatefulWidget {
  @override
  _Income2PageState createState() => _Income2PageState();
}

class _Income2PageState extends State<Income2Page> {
  Income2Bloc _income2Bloc;
  @override
  initState() {
    super.initState();
    _income2Bloc = Income2Bloc(Income2Service());
  }


  @override
  Widget build(BuildContext context) {
    return _getIncome2Tab();
  }

  Widget _getIncome2Tab() {
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
                MaterialPageRoute(builder: (context) => AddIncome2(income2Bloc: _income2Bloc,)),
              );
            },
          ),
        ),
        StreamBuilder(
          stream: _income2Bloc.income2ListStream,
          builder:
              (_, AsyncSnapshot<BuiltList<Income2Model>> income2ListSnap) {
            if (!income2ListSnap.hasData) return CircularProgressIndicator();

            var lsIncome2s = income2ListSnap.data;

            return Expanded(
              child: ListView.builder(
                itemCount: lsIncome2s.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  var income2 = lsIncome2s[index];
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
                        onPressed: () => _income2Bloc.deleteIncome2(income2.id),
                      ),
                      title: Text(
                        "Ingreso #" + income2.id.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .body2
                            .copyWith(color: Theme.of(context).accentColor),
                      ),
                      subtitle: income2.amount == null ? SizedBox() : Text(
                        income2.title + "\nMonto: " + (income2.amount).toString() + " Bs.",
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
