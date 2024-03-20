import 'package:poker_solver/game.dart';
import 'package:poker_solver/hand.dart';

class FourWilds extends Hand {
  FourWilds(List<dynamic> cards, Game game, [bool? canDisqualify])
      : super(cards, 'Four Wild Cards', game, canDisqualify);

  @override
  bool solve() {
    if (wilds.length == 4) {
      cards = wilds;
      cards!.addAll(nextHighest().take(game.cardsInHand - 4));
    }

    if (cards != null && cards!.length >= 4) {
      if (game.noKickers == true) {
        cards!.length = 4;
      }

      descr = name;
    }

    return cards != null && cards!.length >= 4;
  }
}
