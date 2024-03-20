import 'package:poker_solver/card.dart';
import 'package:poker_solver/game.dart';
import 'package:poker_solver/hand.dart';

class FullHouse extends Hand {
  FullHouse(List<dynamic> cards, Game game, [bool? canDisqualify])
      : super(cards, 'Full House', game, canDisqualify);

  bool solve() {
    List<Card> cards = [];
    resetWildCards();

    for (var i = 0; i < this.values.length; i++) {
      if (getNumCardsByRank(i) == 3) {
        this.cards = this.values[i] ?? [];
        for (var j = 0; j < this.wilds.length && this.cards.length < 3; j++) {
          var wild = this.wilds[j];
          if (this.cards != null) {
            wild.rank = this.cards[0].rank;
          } else {
            wild.rank = values.length - 1;
          }
          wild.wildValue = kValues[wild.rank];
          this.cards.add(wild);
        }
        break;
      }
    }

    if (this.cards.length == 3) {
      for (var i = 0; i < this.values.length; i++) {
        cards = this.values[i];
        if (cards.isNotEmpty && this.cards[0].wildValue == cards[0].wildValue) {
          continue;
        }
        if (getNumCardsByRank(i) >= 2) {
          this.cards.addAll(cards ?? []);
          for (var j = 0; j < this.wilds.length; j++) {
            var wild = this.wilds[j];
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
          this
              .cards
              .addAll(this.nextHighest().sublist(0, this.game.cardsInHand - 5));
          break;
        }
      }
    }

    if (this.cards.length >= 5) {
      var type = this
              .cards[0]
              .toString()
              .substring(0, this.cards[0].toString().length - 1) +
          '\'s over ' +
          this
              .cards[3]
              .toString()
              .substring(0, this.cards[3].toString().length - 1) +
          '\'s';
      descr = this.name + ', ' + type;
    }

    return this.cards.length >= 5;
  }
}
