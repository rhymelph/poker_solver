import 'package:poker_solver/card.dart';
import 'package:poker_solver/game.dart';
import 'package:poker_solver/hand.dart';

class FourOfAKind extends Hand {
  FourOfAKind(List<dynamic> cards, Game game, [bool? canDisqualify])
      : super(cards, 'Four of a Kind', game, canDisqualify);

  @override
  bool solve() {
    resetWildCards();

    for (var i = 0; i < values.length; i++) {
      if (getNumCardsByRank(i) == 4) {
        cards = values[i] ?? [];
        for (var j = 0; j < wilds.length && cards.length < 4; j++) {
          var wild = wilds[j];
          wild.rank = cards.isNotEmpty ? cards[0].rank : values.length - 1;
          wild.wildValue = kValues[wild.rank];
          cards.add(wild);
        }

        cards!.addAll(nextHighest().take(game.cardsInHand - 4));
        break;
      }
    }

    if (cards != null && cards.length >= 4) {
      if (game.noKickers == true) {
        cards!.length = 4;
      }
      descr =
          '$name, ${cards![0].toString().substring(0, cards![0].toString().length - 1)}\'s';
    }

    return cards != null && cards.length >= 4;
  }
}
