// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<IncomeModel> _$incomeModelSerializer = new _$IncomeModelSerializer();

class _$IncomeModelSerializer implements StructuredSerializer<IncomeModel> {
  @override
  final Iterable<Type> types = const [IncomeModel, _$IncomeModel];
  @override
  final String wireName = 'IncomeModel';

  @override
  Iterable<Object> serialize(Serializers serializers, IncomeModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.id != null) {
      result
        ..add('id')
        ..add(serializers.serialize(object.id,
            specifiedType: const FullType(int)));
    }
    if (object.title != null) {
      result
        ..add('title')
        ..add(serializers.serialize(object.title,
            specifiedType: const FullType(String)));
    }
    if (object.amount != null) {
      result
        ..add('amount')
        ..add(serializers.serialize(object.amount,
            specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  IncomeModel deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new IncomeModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'amount':
          result.amount = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$IncomeModel extends IncomeModel {
  @override
  final int id;
  @override
  final String title;
  @override
  final int amount;

  factory _$IncomeModel([void Function(IncomeModelBuilder) updates]) =>
      (new IncomeModelBuilder()..update(updates)).build();

  _$IncomeModel._({this.id, this.title, this.amount}) : super._();

  @override
  IncomeModel rebuild(void Function(IncomeModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  IncomeModelBuilder toBuilder() => new IncomeModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IncomeModel &&
        id == other.id &&
        title == other.title &&
        amount == other.amount;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, id.hashCode), title.hashCode), amount.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('IncomeModel')
          ..add('id', id)
          ..add('title', title)
          ..add('amount', amount))
        .toString();
  }
}

class IncomeModelBuilder implements Builder<IncomeModel, IncomeModelBuilder> {
  _$IncomeModel _$v;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  int _amount;
  int get amount => _$this._amount;
  set amount(int amount) => _$this._amount = amount;

  IncomeModelBuilder();

  IncomeModelBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _title = _$v.title;
      _amount = _$v.amount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(IncomeModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$IncomeModel;
  }

  @override
  void update(void Function(IncomeModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$IncomeModel build() {
    final _$result =
        _$v ?? new _$IncomeModel._(id: id, title: title, amount: amount);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
