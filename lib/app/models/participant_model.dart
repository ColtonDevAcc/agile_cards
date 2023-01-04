import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';

part 'participant_model.g.dart';

@JsonSerializable(anyMap: true, createFieldMap: true)
class Participant extends Equatable {
  final String id;
  final String name;
  final String? imageUrl;
  final String? email;
  final String? phone;
  final String? shirtSize;
  final String? session;

  const Participant({
    required this.id,
    required this.name,
    this.imageUrl,
    this.email,
    this.phone,
    this.shirtSize,
    this.session,
  });

  @override
  List<Object?> get props => [id, name, imageUrl, email, phone, shirtSize, session];

  Participant copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? email,
    String? phone,
    String? shirtSize,
    String? session,
  }) {
    return Participant(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      shirtSize: shirtSize ?? this.shirtSize,
      session: session ?? this.session,
    );
  }

  factory Participant.fromJson(Map<String, dynamic> json) => _$ParticipantFromJson(json);
  Map<String, dynamic> toJson() => _$ParticipantToJson(this);

  //from firebase user() to participant
  factory Participant.fromUser(User user) {
    return Participant(
      id: user.uid,
      name: user.displayName ?? '',
      imageUrl: user.photoURL ?? '',
      email: user.email ?? '',
      phone: user.phoneNumber ?? '',
    );
  }

  @override
  String toString() {
    return 'Participant(id: $id, name: $name, imageUrl: $imageUrl, email: $email, phone: $phone, shirtSize: $shirtSize, session: $session)';
  }
}
