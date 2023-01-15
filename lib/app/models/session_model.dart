import 'dart:developer';

import 'package:agile_cards/app/models/participant_model.dart';
import 'package:agile_cards/app/models/selection_model.dart';
import 'package:agile_cards/app/repositories/session_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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

  String get sessionMeasurementAverage {
    if (isShirtSizes == false) {
      return taskSizes.length < sessionAverageValue ? taskSizes.last : taskSizes[sessionAverageValue];
    } else {
      return tShirtSizes.length < sessionAverageValue ? tShirtSizes.last : tShirtSizes[sessionAverageValue];
    }
  }

  int get selectionsNotLockedIn {
    if (selections == null || selections!.isEmpty) return 0;
    return selections!.where((selection) => selection.lockedIn != true).length;
  }

  int get sessionAverageValue {
    final List<int> values = (selections ?? []).map((selection) => selection.cardSelected ?? 0).toList();
    final int avg = (values.reduce((value, element) => value + element) / values.length).round();
    return avg;
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

  factory Session.fromDocument(DataSnapshot snapshot) {
    if (snapshot.value == null) {
      log('Session.fromDocument: snapshot.value is null');
      return Session.empty();
    }

    // ignore: cast_nullable_to_non_nullable
    final Map<String, dynamic> document = Map<String, dynamic>.from(snapshot.value as Map);
    final selections = List<Map<String, Selection>>.from(
      (document['selections'] ?? {}).entries.map(
        (entry) {
          final Map<String, Selection> selection = {
            entry.key: Selection.fromJson(Map<String, dynamic>.from(entry.value as Map)),
          };
          return selection;
        },
      ).toList(),
    );

    final participants = List<Map<String, Participant>>.from(
      (document['participants'] ?? {}).entries.map(
        (entry) {
          final Map<String, Participant> selection = {
            entry.key: Participant.fromJson(Map<String, dynamic>.from(entry.value as Map)),
          };
          return selection;
        },
      ).toList(),
    );

    return Session(
      id: document['id'],
      name: document['name'],
      description: document['description'],
      imageUrl: document['imageUrl'],
      owner: document['owner'],
      isShirtSizes: document['isShirtSizes'],
      selections: selections.map((selection) => selection.values.single).toList(),
      participants: participants.map((participant) => participant.values.single).toList(),
      cardsRevealed: document['cardsRevealed'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'owner': owner,
      'isShirtSizes': isShirtSizes,
      'selections': selections?.map((selection) => {selections?.single.userId: selection.toJson()}).toList(),
      'cardsRevealed': cardsRevealed,
    };
  }
}
