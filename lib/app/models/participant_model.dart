import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';

part 'participant_model.g.dart';

@JsonSerializable(anyMap: true, createFieldMap: true)
class Participant extends Equatable {
  final String? id;
  final String? email;
  final String? imageUrl;
  final String? phone;
  final String? name;
  final String? shirtSize;
  final String? session;
  final String? displayName;

  const Participant({
    this.displayName,
    this.id,
    this.email,
    this.name,
    this.imageUrl,
    this.phone,
    this.shirtSize,
    this.session,
  });

  @override
  List<Object?> get props => [id, name, imageUrl, email, phone, shirtSize, session, displayName];

  Participant copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? email,
    String? phone,
    String? shirtSize,
    String? session,
    String? displayName,
  }) {
    return Participant(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      shirtSize: shirtSize ?? this.shirtSize,
      session: session ?? this.session,
      displayName: displayName ?? this.displayName,
    );
  }

  factory Participant.fromJson(Map<String, dynamic> json) => _$ParticipantFromJson(json);
  Map<String, dynamic> toJson() => _$ParticipantToJson(this);

  List<Participant> parseRawList(Object? raw) {
    try {
      raw as Map?;
      if (raw == null || raw.isEmpty) {
        return [];
      }
      final list = raw['Participants'] as List?;
      if (list == null || list.isEmpty) {
        return [];
      }
      return list.map((e) => Participant.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    } catch (e) {
      log("error parsing from rawList $e");
      return [];
    }
  }

  //from firebase user() to participant
  factory Participant.fromUser(User user) {
    return Participant(
      id: user.uid,
      name: user.displayName ?? '',
      imageUrl: user.photoURL ?? '',
      email: user.email ?? '',
      phone: user.phoneNumber ?? '',
      displayName: user.displayName ?? '',
    );
  }

  //empty factory
  factory Participant.empty() {
    return const Participant();
  }
}
