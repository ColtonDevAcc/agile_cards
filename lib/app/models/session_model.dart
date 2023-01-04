import 'package:agile_cards/app/models/participant_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'session_model.g.dart';

@JsonSerializable(anyMap: true, createFieldMap: true)
class Session extends Equatable {
  final String id;
  final String name;
  final String description;
  final String? owner;
  final String? imageUrl;
  final List<Participant>? participants;
  final bool? isShirtSizes;

  const Session({
    required this.id,
    required this.name,
    required this.description,
    this.participants,
    this.owner,
    this.imageUrl,
    this.isShirtSizes,
  });

  @override
  List<Object?> get props => [id, name, description, imageUrl, owner, participants, isShirtSizes];

  Session copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? owner,
    List<Participant>? participants,
    bool? isShirtSizes,
  }) {
    return Session(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      owner: owner ?? this.owner,
      participants: participants ?? this.participants,
      isShirtSizes: isShirtSizes ?? this.isShirtSizes,
    );
  }

  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);
  Map<String, dynamic> toJson() => _$SessionToJson(this);

  //empty factory
  factory Session.empty() {
    return const Session(
      id: '',
      name: '',
      description: '',
      imageUrl: '',
      owner: '',
      participants: [],
      isShirtSizes: false,
    );
  }
}
