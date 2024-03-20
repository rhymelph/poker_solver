import 'package:poker_solver/card.dart';
import 'package:poker_solver/game.dart';
import 'package:poker_solver/hand.dart';

class TwoThreeOfAKind extends Hand {
  TwoThreeOfAKind(List<Card> cards, Game game, [bool? canDisqualify])
      : super(cards, 'Two Three Of a Kind', game, canDisqualify);

  @override
  bool solve() {
    resetWildCards();
    for (var i = 0; i < values.length; i++) {
      var cards = values[i];
      if (this.cards.isNotEmpty && getNumCardsByRank(i) == 3) {
        this.cards.addAll(cards ?? []);
        for (var j = 0; j < wilds.length; j++) {
          var wild = wilds[j];
          if (wild.rank != -1) {
            continue;
          }
          if (cards != null) {
            wild.rank = cards[0].rank;
          } else if (this.cards[0].rank == values.length - 1 &&
              game.wildStatus == 1) {
            wild.rank = values.length - 2;
          } else {
            wild.rank = values.length - 1;
          }
          wild.wildValue = kValues[wild.rank];
          this.cards.add(wild);
        }
        this.cards.addAll(nextHighest().take(game.cardsInHand - 6));
        break;
      } else if (getNumCardsByRank(i) == 3) {
        this.cards.addAll(cards!);
        for (var j = 0; j < wilds.length; j++) {
          var wild = wilds[j];
          if (wild.rank != -1) {
            continue;
          }
          if (cards != null) {
            wild.rank = cards[0].rank;
          } else if (this.cards[0].rank == values.length - 1 &&
              game.wildStatus == 1) {
            wild.rank = values.length - 2;
          } else {
            wild.rank = values.length - 1;
          }
          wild.wildValue = kValues[wild.rank];
          this.cards.add(wild);
        }
      }
    }

    if (this.cards.length >= 6) {
      var type = this.cards[0].toString().substring(0, 1) +
          '\'s & ' +
          this.cards[3].toString().substring(0, 1) +
          '\'s';
      descr = '$name, $type';
    }

    return this.cards.length >= 6;
  }
}
