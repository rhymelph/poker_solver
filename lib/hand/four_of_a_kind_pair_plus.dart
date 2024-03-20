import 'package:poker_solver/card.dart';
import 'package:poker_solver/game.dart';
import 'package:poker_solver/hand.dart';

class FourOfAKindPairPlus extends Hand {
  FourOfAKindPairPlus(List<dynamic> cards, Game game, [bool? canDisqualify])
      : super(cards, 'Four of a Kind with Pair or Better', game, canDisqualify);

  @override
  bool solve() {
    List<Card>? cards;
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
        break;
      }
    }

    if (cards != null && cards.length == 4) {
      for (var i = 0; i < values.length; i++) {
        cards = values[i];
        if (cards != null && this.cards![0].wildValue == cards[0].wildValue) {
          continue;
        }
        if (getNumCardsByRank(i) >= 2) {
          cards = cards ?? [];
          this.cards!.addAll(cards);
          for (var j = 0; j < wilds.length; j++) {
            var wild = wilds[j];
            if (wild.rank != -1) {
              continue;
            }
            wild.rank = cards != null
                ? cards[0].rank
                : (this.cards![0].rank == values.length - 1 &&
                        game.wildStatus == 1)
                    ? values.length - 2
                    : values.length - 1;
            wild.wildValue = kValues[wild.rank];
            this.cards!.add(wild);
          }
          this.cards!.addAll(nextHighest().take(game.cardsInHand - 6));
          break;
        }
      }
    }

    if (cards != null && cards.length >= 6) {
      var type =
          '${this.cards![0].toString().substring(0, this.cards![0].toString().length - 1)}\'s over ${this.cards![4].toString().substring(0, this.cards![4].toString().length - 1)}\'s';
      descr = '$name, $type';
    }

    return cards != null && cards.length >= 6;
  }
}
