import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'income_model.g.dart';

abstract class IncomeModel
    implements Built<IncomeModel, IncomeModelBuilder> {
  IncomeModel._();

  factory IncomeModel([updates(IncomeModelBuilder b)]) = _$IncomeModel;

  static Serializer<IncomeModel> get serializer => _$incomeModelSerializer;

  @nullable
  int get id;

  @nullable
  String get title;

  @nullable
  int get amount;
}