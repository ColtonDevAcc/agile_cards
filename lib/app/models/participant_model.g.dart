// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Participant _$ParticipantFromJson(Map json) => Participant(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      imageUrl: json['imageUrl'] as String?,
      phone: json['phone'] as String?,
      shirtSize: json['shirtSize'] as String?,
      session: json['session'] as String?,
    );

const _$ParticipantFieldMap = <String, String>{
  'id': 'id',
  'email': 'email',
  'imageUrl': 'imageUrl',
  'phone': 'phone',
  'name': 'name',
  'shirtSize': 'shirtSize',
  'session': 'session',
};

Map<String, dynamic> _$ParticipantToJson(Participant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'imageUrl': instance.imageUrl,
      'phone': instance.phone,
      'name': instance.name,
      'shirtSize': instance.shirtSize,
      'session': instance.session,
    };
