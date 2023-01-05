// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Selection _$SelectionFromJson(Map json) => Selection(
      userId: json['userId'] as String,
      cardSelected: json['cardSelected'] as int,
    );

const _$SelectionFieldMap = <String, String>{
  'userId': 'userId',
  'cardSelected': 'cardSelected',
};

Map<String, dynamic> _$SelectionToJson(Selection instance) => <String, dynamic>{
      'userId': instance.userId,
      'cardSelected': instance.cardSelected,
    };
