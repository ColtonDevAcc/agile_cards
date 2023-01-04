// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Participant _$ParticipantFromJson(Map<String, dynamic> json) => Participant(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      shirtSize: json['shirtSize'] as String?,
      session: json['session'] as String?,
    );

Map<String, dynamic> _$ParticipantToJson(Participant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'email': instance.email,
      'phone': instance.phone,
      'shirtSize': instance.shirtSize,
      'session': instance.session,
    };
