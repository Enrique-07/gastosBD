import 'package:expense_manager/blocs/income_bloc.dart';
import 'package:expense_manager/models/income_model.dart';
import 'package:flutter/material.dart';
import 'package:built_collection/built_collection.dart';
import 'package:expense_manager/models/category_model.dart';
import 'package:expense_manager/blocs/category_bloc.dart';
import 'package:expense_manager/db/services/category_service.dart';


class AddIncome extends StatefulWidget {
  final IncomeBloc incomeBloc;

  const AddIncome({Key key, this.incomeBloc}) : super(key: key);
  @override
  _AddIncomeState createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {
  CategoryBloc categoryBloc;
  FocusNode _focus = new FocusNode();

  @override
  void initState() {
    super.initState();
    widget.incomeBloc.updateCreateIncome(IncomeModel());
    categoryBloc = CategoryBloc(CategoryService());
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {

    });
  }

  int selectedCategoryId = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nuevo ingreso"),
      ),
      body: Container(
          padding: EdgeInsets.all(12.0),
          child: StreamBuilder(
            stream: widget.incomeBloc.createIncomeStream,
            builder: (ctxt, AsyncSnapshot<IncomeModel> incomeSnap) {
              if (!incomeSnap.hasData) return CircularProgressIndicator();
              return Column(
                children: <Widget>[
                  TextField(
                      decoration: InputDecoration(labelText: "Descripción"),
                      onChanged: (String text) {
                        if (text == null || text.trim() == "") return;
                        var income = incomeSnap.data;
                        var upated = income.rebuild((b) => b..title = text);
                        widget.incomeBloc.updateCreateIncome(upated);
                      }),
                  TextField(
                      decoration: InputDecoration(labelText: "Monto"),
                      maxLines: 2,
                      onChanged: (String text) {
                        if (text == null || text.trim() == "") return;
                        var income = incomeSnap.data;
                        var upated = income.rebuild((b) => b..amount = int.parse(text));
                        widget.incomeBloc.updateCreateIncome(upated);
                      }),
                  RaisedButton(
                    child: Text("Registrar ingreso"),
                    onPressed: incomeSnap.data.title == null ? null : () async {
                      var createdId = await widget.incomeBloc.createNewIncome(incomeSnap.data);
                      if(createdId > 0) {
                        Navigator.of(context).pop();
                        widget.incomeBloc.getIncomes();
                      }
                      else {
                        //show error here...
                      }
                    },
                  ),
                ],
              );
            },
          )),
    );
  }
}
