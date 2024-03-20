import 'package:poker_solver/card.dart';
import 'package:poker_solver/game.dart';
import 'package:poker_solver/hand.dart';

/// As Ac 2s 2c
class TwoPair extends Hand {
  TwoPair(List<dynamic> cards, Game game, [bool? canDisqualify])
      : super(cards, 'Two Pair', game, canDisqualify);

  @override
  bool solve() {
    resetWildCards();
    for (var i = 0; i < values.length; i++) {
      var cards = this.values[i];
      if (this.cards.isNotEmpty && getNumCardsByRank(i) == 2) {
        this.cards.addAll(cards ?? []);
        for (var j = 0; j < wilds.length; j++) {
          var wild = wilds[j];
          if (wild.rank != -1) {
            continue;
          }
          if (cards != null) {
            wild.rank = cards[0].rank;
          } else if (this.cards[0].rank == values.length - 1 &&
              this.game.wildStatus == 1) {
            wild.rank = values.length - 2;
          } else {
            wild.rank = values.length - 1;
          }
          wild.wildValue = kValues[wild.rank];
          this.cards.add(wild);
        }
        this.cards.addAll(nextHighest().sublist(0, game.cardsInHand - 4));
        break;
      } else if (getNumCardsByRank(i) == 2) {
        this.cards.addAll(cards ?? []);
        for (var j = 0; j < wilds.length; j++) {
          var wild = wilds[j];
          if (wild.rank != -1) {
            continue;
          }
          if (cards != null) {
            wild.rank = cards[0].rank;
          } else if (this.cards[0].rank == values.length - 1 &&
              this.game.wildStatus == 1) {
            wild.rank = values.length - 2;
          } else {
            wild.rank = values.length - 1;
          }
          wild.wildValue = kValues[wild.rank];
          this.cards.add(wild);
        }
      }
    }

    if (cards.length >= 4) {
      if (game.noKickers == true) {
        this.cards.length = 4;
      }

      var type = this
              .cards[0]
              .toString()
              .substring(0, this.cards[0].toString().length - 1) +
          '\'s & ' +
          this
              .cards[2]
              .toString()
              .substring(0, this.cards[2].toString().length - 1) +
          '\'s';
      descr = this.name + ', ' + type;
    }

    return this.cards.length >= 4;
  }
}
