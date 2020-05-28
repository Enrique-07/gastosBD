import 'package:expense_manager/blocs/expense_bloc.dart';
import 'package:expense_manager/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:built_collection/built_collection.dart';
import 'package:expense_manager/models/category_model.dart';
import 'package:expense_manager/blocs/category_bloc.dart';
import 'package:expense_manager/db/services/category_service.dart';


class AddExpense extends StatefulWidget {
  final ExpenseBloc expenseBloc;

  const AddExpense({Key key, this.expenseBloc}) : super(key: key);
  @override
  _AddExpenseState createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  CategoryBloc categoryBloc;
  FocusNode _focus = new FocusNode();
  bool _showKeyboard = false;
  TextEditingController _amountTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.expenseBloc.updateCreateExpense(ExpenseModel());
    categoryBloc = CategoryBloc(CategoryService());
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _showKeyboard = _focus.hasFocus;
    });
  }

  int selectedCategoryId = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Expense"),
      ),
      body: Container(
          padding: EdgeInsets.all(12.0),
          child: StreamBuilder(
            stream: widget.expenseBloc.createExpenseStream,
            builder: (ctxt, AsyncSnapshot<ExpenseModel> expenseSnap) {
              if (!expenseSnap.hasData) return CircularProgressIndicator();
              return Column(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        "Pick Category",
                        style: Theme.of(context).textTheme.title,
                      )),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                    ),
                    child: StreamBuilder(
                      stream: categoryBloc.categoryListStream,
                      builder: (_, AsyncSnapshot<BuiltList<CategoryModel>> snap) {
                        if (!snap.hasData)
                          return Center(
                            child: CircularProgressIndicator(),
                          );

                        return Wrap(
                            children: List.generate(snap.data.length, (int index) {
                              var categoryModel = snap.data[index];
                              return Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 2.0,
                                ),
                                child: ChoiceChip(
                                  selectedColor: Theme.of(context).accentColor,
                                  selected: categoryModel.id == selectedCategoryId,
                                  label: Text(categoryModel.title),
                                  onSelected: (selected) {
                                    setState(() {
                                      selectedCategoryId = categoryModel.id;
                                    });
                                  },
                                ),
                              );
                            }));
                      },
                    ),
                  ),
                  TextField(
                      decoration: InputDecoration(labelText: "Title"),
                      onChanged: (String text) {
                        if (text == null || text.trim() == "") return;
                        var expense = expenseSnap.data;
                        var upated = expense.rebuild((b) => b..title = text);
                        widget.expenseBloc.updateCreateExpense(upated);
                      }),
                  TextField(
                      decoration: InputDecoration(labelText: "Description"),
                      maxLines: 2,
                      onChanged: (String text) {
                        if (text == null || text.trim() == "") return;
                        var expense = expenseSnap.data;
                        var upated = expense.rebuild((b) => b..notes = text);
                        widget.expenseBloc.updateCreateExpense(upated);
                      }),
                  TextField(
                      decoration: InputDecoration(labelText: "Amount"),
                      maxLines: 2,
                      onChanged: (String text) {
                        if (text == null || text.trim() == "") return;
                        var expense = expenseSnap.data;
                        var upated = expense.rebuild((b) => b..amount = double.parse(text));
                        widget.expenseBloc.updateCreateExpense(upated);
                      }),
                  RaisedButton(
                    child: Text("Create"),
                    onPressed: expenseSnap.data.title == null ? null : () async {
                      var createdId = await widget.expenseBloc.createNewExpense(expenseSnap.data);
                      if(createdId > 0) {
                        Navigator.of(context).pop();
                        widget.expenseBloc.getExpenses();
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
