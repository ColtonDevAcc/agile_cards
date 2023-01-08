// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Session _$SessionFromJson(Map json) => Session(
      id: json['id'] as String,
      cardsRevealed: json['cardsRevealed'] as bool?,
      selections: (json['selections'] as List<dynamic>?)
          ?.map((e) => Selection.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      participants: (json['participants'] as List<dynamic>?)
          ?.map(
              (e) => Participant.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      owner: json['owner'] as String?,
      imageUrl: json['imageUrl'] as String?,
      isShirtSizes: json['isShirtSizes'] as bool?,
    );

const _$SessionFieldMap = <String, String>{
  'id': 'id',
  'name': 'name',
  'participants': 'participants',
  'cardsRevealed': 'cardsRevealed',
  'description': 'description',
  'owner': 'owner',
  'imageUrl': 'imageUrl',
  'isShirtSizes': 'isShirtSizes',
  'selections': 'selections',
};

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'participants': instance.participants?.map((e) => e.toJson()).toList(),
      'cardsRevealed': instance.cardsRevealed,
      'description': instance.description,
      'owner': instance.owner,
      'imageUrl': instance.imageUrl,
      'isShirtSizes': instance.isShirtSizes,
      'selections': instance.selections?.map((e) => e.toJson()).toList(),
    };
