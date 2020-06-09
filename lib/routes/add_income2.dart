import 'package:expense_manager/blocs/income2_bloc.dart';
import 'package:expense_manager/models/income2_model.dart';
import 'package:flutter/material.dart';
import 'package:built_collection/built_collection.dart';
import 'package:expense_manager/models/category_model.dart';
import 'package:expense_manager/blocs/category_bloc.dart';
import 'package:expense_manager/db/services/category_service.dart';


class AddIncome2 extends StatefulWidget {
  final Income2Bloc income2Bloc;

  const AddIncome2({Key key, this.income2Bloc}) : super(key: key);
  @override
  _AddIncome2State createState() => _AddIncome2State();
}

class _AddIncome2State extends State<AddIncome2> {
  CategoryBloc categoryBloc;
  FocusNode _focus = new FocusNode();

  @override
  void initState() {
    super.initState();
    widget.income2Bloc.updateCreateIncome2(Income2Model());
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
            stream: widget.income2Bloc.createIncome2Stream,
            builder: (ctxt, AsyncSnapshot<Income2Model> income2Snap) {
              if (!income2Snap.hasData) return CircularProgressIndicator();
              return Column(
                children: <Widget>[
                  TextField(
                      decoration: InputDecoration(labelText: "Descripción"),
                      onChanged: (String text) {
                        if (text == null || text.trim() == "") return;
                        var income2 = income2Snap.data;
                        var upated = income2.rebuild((b) => b..title = text);
                        widget.income2Bloc.updateCreateIncome2(upated);
                      }),
                  TextField(
                      decoration: InputDecoration(labelText: "Monto"),
                      maxLines: 2,
                      onChanged: (String text) {
                        if (text == null || text.trim() == "") return;
                        var income2 = income2Snap.data;
                        var upated = income2.rebuild((b) => b..amount = int.parse(text));
                        widget.income2Bloc.updateCreateIncome2(upated);
                      }),
                  RaisedButton(
                    child: Text("Registrar ingreso"),
                    onPressed: income2Snap.data.title == null ? null : () async {
                      var createdId = await widget.income2Bloc.createNewIncome2(income2Snap.data);
                      if(createdId > 0) {
                        Navigator.of(context).pop();
                        widget.income2Bloc.getIncome2s();
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