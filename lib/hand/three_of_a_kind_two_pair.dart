import 'package:poker_solver/card.dart';
import 'package:poker_solver/game.dart';
import 'package:poker_solver/hand.dart';

class ThreeOfAKindTwoPair extends Hand {
  ThreeOfAKindTwoPair(List<dynamic> cards, Game game, [bool? canDisqualify])
      : super(cards, 'Three of a Kind with Two Pair', game, canDisqualify);

  @override
  bool solve() {
    resetWildCards();

    for (var i = 0; i < values.length; i++) {
      if (getNumCardsByRank(i) == 3) {
        cards = values[i];
        for (var j = 0; j < wilds.length && cards.length < 3; j++) {
          var wild = wilds[j];
          wild.rank = cards.isNotEmpty ? cards[0].rank : values.length - 1;
          wild.wildValue = kValues[wild.rank];
          cards.add(wild);
        }
        break;
      }
    }

    if (cards != null && cards!.length == 3) {
      for (var i = 0; i < values.length; i++) {
        var cardsList = values[i];
        if (cardsList != null &&
            cards![0].wildValue == cardsList[0].wildValue) {
          continue;
        }
        if (cards!.length > 5 && getNumCardsByRank(i) == 2) {
          cards = cards!.followedBy(cardsList ?? []).toList();
          for (var j = 0; j < wilds.length; j++) {
            var wild = wilds[j];
            if (wild.rank != -1) {
              continue;
            }
            wild.rank = cardsList != null
                ? cardsList[0].rank
                : (cards![0].rank == values.length - 1 && game.wildStatus == 1)
                    ? values.length - 2
                    : values.length - 1;
            wild.wildValue = kValues[wild.rank];
            cards!.add(wild);
          }
          cards!.addAll(nextHighest().take(game.cardsInHand - 4));
          break;
        } else if (getNumCardsByRank(i) == 2) {
          cards = cards!.followedBy(cardsList!).toList();
          for (var j = 0; j < wilds.length; j++) {
            var wild = wilds[j];
            if (wild.rank != -1) {
              continue;
            }
            wild.rank = cardsList != null
                ? cardsList[0].rank
                : (cards![0].rank == values.length - 1 && game.wildStatus == 1)
                    ? values.length - 2
                    : values.length - 1;
            wild.wildValue = kValues[wild.rank];
            cards!.add(wild);
          }
        }
      }
    }

    if (cards != null && cards!.length >= 7) {
      var type =
          '${cards![0].toString().substring(0, cards![0].toString().length - 1)}\'s over ${cards![3].toString().substring(0, cards![3].toString().length - 1)}\'s & ${cards![5].value}\'s';
      descr = '$name, $type';
    }

    return cards != null && cards!.length >= 7;
  }
}
