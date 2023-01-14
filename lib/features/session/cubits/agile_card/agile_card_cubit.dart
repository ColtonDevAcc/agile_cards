import 'package:agile_cards/features/session/widgets/molecules/participant_card_selection_list.dart';
import 'package:equatable/equatable.dart';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:flip_card/flip_card_controller.dart';
part 'agile_card_state.dart';

class AgileCardCubit extends Cubit<AgileCardState> {
  AgileCardCubit() : super(AgileCardState(controller: FlipCardController(), reveal: false));

  void setReveal({required bool reveal}) {
    if (cardKey.currentState?.isFront == true && reveal == false) {
      cardKey.currentState?.toggleCard();
    } else if (cardKey.currentState?.isFront == false && reveal == true) {
      cardKey.currentState?.toggleCard();
    }
    emit(state.copyWith(reveal: reveal));
  }

  void setController({required FlipCardController controller}) {
    emit(state.copyWith(controller: controller));
  }
}
