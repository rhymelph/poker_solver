import 'package:poker_solver/card.dart';
import 'package:poker_solver/game.dart';
import 'package:poker_solver/hand.dart';

class ThreePair extends Hand {
  ThreePair(List<dynamic> cards, Game game, [bool? canDisqualify])
      : super(cards, 'Three Pair', game, canDisqualify);

  @override
  bool solve() {
    resetWildCards();

    for (var i = 0; i < values.length; i++) {
      var cards = values[i];
      if (cards.length > 2 && getNumCardsByRank(i) == 2) {
        cards.addAll(cards ?? []);
        for (var j = 0; j < wilds.length; j++) {
          var wild = wilds[j];
          if (wild.rank != -1) {
            continue;
          }
          if (cards != null) {
            wild.rank = cards[0].rank;
          } else if (cards[0].rank == values.length - 1 &&
              game.wildStatus == 1) {
            wild.rank = values.length - 2;
          } else {
            wild.rank = values.length - 1;
          }
          wild.wildValue = kValues[wild.rank];
          cards.add(wild);
        }
        cards.addAll(nextHighest().sublist(0, game.cardsInHand - 6));
        break;
      } else if (cards.isNotEmpty && getNumCardsByRank(i) == 2) {
        cards.addAll(cards ?? []);
        for (var j = 0; j < wilds.length; j++) {
          var wild = wilds[j];
          if (wild.rank != -1) {
            continue;
          }
          if (cards != null) {
            wild.rank = cards[0].rank;
          } else if (cards[0].rank == values.length - 1 &&
              game.wildStatus == 1) {
            wild.rank = values.length - 2;
          } else {
            wild.rank = values.length - 1;
          }
          wild.wildValue = kValues[wild.rank];
          cards.add(wild);
        }
      } else if (getNumCardsByRank(i) == 2) {
        cards.addAll(cards);
        for (var j = 0; j < wilds.length; j++) {
          var wild = wilds[j];
          if (wild.rank != -1) {
            continue;
          }
          if (cards != null) {
            wild.rank = cards[0].rank;
          } else if (cards[0].rank == values.length - 1 &&
              game.wildStatus == 1) {
            wild.rank = values.length - 2;
          } else {
            wild.rank = values.length - 1;
          }
          wild.wildValue = kValues[wild.rank];
          cards.add(wild);
        }
      }
    }

    if (cards.length >= 6) {
      var type =
          '${cards[0]?.toString()?.substring(0, cards[0].toString().length - 1) ?? ''}\'s & '
          '${cards[2]?.toString()?.substring(0, cards[2].toString().length - 1) ?? ''}\'s & '
          '${cards[4]?.toString()?.substring(0, cards[4].toString().length - 1) ?? ''}\'s';
      descr = '$name, $type';
    }

    return cards.length >= 6;
  }
}
