import 'dart:developer';

import 'package:agile_cards/app/repositories/session_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'selection_model.g.dart';

@JsonSerializable(anyMap: true, createFieldMap: true)
class Selection extends Equatable {
  final String? userId;
  final int? cardSelected;
  final bool? lockedIn;

  const Selection({
    this.userId,
    this.cardSelected,
    this.lockedIn,
  });

  @override
  List<Object?> get props => [userId, cardSelected, lockedIn];

  Selection copyWith({
    String? userId,
    int? cardSelected,
    bool? lockedIn,
  }) {
    return Selection(
      userId: userId ?? this.userId,
      cardSelected: cardSelected ?? this.cardSelected,
      lockedIn: lockedIn ?? this.lockedIn,
    );
  }

  factory Selection.fromJson(Map<String, dynamic> json) => _$SelectionFromJson(json);
  Map<String, dynamic> toJson() => _$SelectionToJson(this);

  List<Selection> parseRawList(Object? raw) {
    try {
      raw as Map?;
      if (raw == null || raw.isEmpty) {
        return [];
      }
      final list = raw['Participants'] as List?;
      if (list == null || list.isEmpty) {
        return [];
      }
      return list.map((e) => Selection.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    } catch (e) {
      log("error parsing from rawList $e");
      return [];
    }
  }

  String cardSelectionToMeasurement({required bool isShirtSizes, required int selection}) {
    if (isShirtSizes) {
      return tShirtSizes[selection > tShirtSizes.length ? tShirtSizes.length - 1 : selection];
    } else {
      return taskSizes[selection > taskSizes.length ? taskSizes.length - 1 : selection];
    }
  }

  //empty factory
  factory Selection.empty() {
    return const Selection(
      userId: '',
      cardSelected: 0,
      lockedIn: false,
    );
  }
}
