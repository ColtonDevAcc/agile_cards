import 'package:agile_cards/app/models/participant_model.dart';
import 'package:agile_cards/app/models/selection_model.dart';
import 'package:agile_cards/app/repositories/session_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'session_model.g.dart';

@JsonSerializable(anyMap: true, createFieldMap: true, explicitToJson: true)
class Session extends Equatable {
  final String? id;
  final String? name;
  final List<Participant>? participants;
  final bool? cardsRevealed;
  final String? description;
  final String? owner;
  final String? imageUrl;
  final bool? isShirtSizes;
  final List<Selection>? selections;

  const Session({
    this.id,
    this.cardsRevealed,
    this.selections,
    this.name,
    this.description,
    this.participants,
    this.owner,
    this.imageUrl,
    this.isShirtSizes,
  });

  @override
  List<Object?> get props => [id, name, description, imageUrl, owner, participants, isShirtSizes, selections, cardsRevealed];

  Session copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? owner,
    bool? isShirtSizes,
    List<Participant>? participants,
    List<Selection>? selections,
    bool? cardsRevealed,
  }) {
    return Session(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      owner: owner ?? this.owner,
      participants: participants ?? this.participants,
      isShirtSizes: isShirtSizes ?? this.isShirtSizes,
      selections: selections ?? this.selections,
      cardsRevealed: cardsRevealed ?? this.cardsRevealed,
    );
  }

  String sessionMeasurementAverage({required int average, required bool shirtSizes}) {
    if (shirtSizes) {
      return tShirtSizes.length < average ? tShirtSizes.last : tShirtSizes[average];
    } else {
      return taskSizes.length < average ? taskSizes.last : taskSizes[average];
    }
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
      isShirtSizes: false,
      selections: [],
      participants: [],
      cardsRevealed: false,
    );
  }
}
