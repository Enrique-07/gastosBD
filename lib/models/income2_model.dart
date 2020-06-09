import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'income2_model.g.dart';

abstract class Income2Model
    implements Built<Income2Model, Income2ModelBuilder> {
  Income2Model._();

  factory Income2Model([updates(Income2ModelBuilder b)]) = _$Income2Model;

  static Serializer<Income2Model> get serializer => _$income2ModelSerializer;

  @nullable
  int get id;

  @nullable
  String get title;

  @nullable
  int get amount;
}