import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'selection_model.g.dart';

@JsonSerializable(anyMap: true, createFieldMap: true)
class Selection extends Equatable {
  final String userId;
  final int cardSelected;

  const Selection({
    required this.userId,
    required this.cardSelected,
  });

  @override
  List<Object?> get props => [userId, cardSelected];

  Selection copyWith({
    String? userId,
    int? cardSelected,
  }) {
    return Selection(
      userId: userId ?? this.userId,
      cardSelected: cardSelected ?? this.cardSelected,
    );
  }

  factory Selection.fromJson(Map<String, dynamic> json) => _$SelectionFromJson(json);
  Map<String, dynamic> toJson() => _$SelectionToJson(this);

  //empty factory
  factory Selection.empty() {
    return const Selection(
      userId: '',
      cardSelected: 0,
    );
  }
}
