import 'package:poker_solver/card.dart' hide values;
import 'package:poker_solver/game.dart';
import 'package:poker_solver/hand.dart';

class OnePair extends Hand {
  OnePair(List<dynamic> cards, Game game, [bool? canDisqualify])
      : super(cards, 'Pair', game, canDisqualify);

  @override
  bool solve() {
    resetWildCards();

    for (var i = 0; i < values.length; i++) {
      if (getNumCardsByRank(i) == 2) {
        cards.addAll(values[i] ?? []);
        for (var j = 0; j < wilds.length && cards.length < 2; j++) {
          var wild = wilds[j];
          if (cards != null) {
            wild.rank = cards[0]!.rank;
          } else {
            wild.rank = values.length - 1;
          }
          wild.wildValue = kValues[wild.rank];
          cards.add(wild);
        }
        cards.addAll(nextHighest().sublist(0, game.cardsInHand - 2));
        break;
      }
    }

    if (cards.length >= 2) {
      if (game.noKickers == true) {
        cards.length = 2;
      }

      descr =
          '$name, ${cards[0].toString().substring(0, cards[0].toString().length - 1) ?? ''}\'s';
    }

    return cards.length >= 2;
  }
}
