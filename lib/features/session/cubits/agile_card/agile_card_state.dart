part of 'agile_card_cubit.dart';

class AgileCardState extends Equatable {
  final bool reveal;
  final FlipCardController controller;
  const AgileCardState({required this.controller, required this.reveal});

  @override
  List<Object> get props => [reveal, controller];

  bool get mounted => controller.controller?.isAnimating == true;

  AgileCardState copyWith({bool? reveal, FlipCardController? controller}) {
    return AgileCardState(
      reveal: reveal ?? this.reveal,
      controller: controller ?? this.controller,
    );
  }
}
