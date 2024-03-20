import 'package:poker_solver/card.dart';
import 'package:poker_solver/game.dart';
import 'package:poker_solver/hand.dart';
import 'package:poker_solver/hand/straight.dart';

class StraightFlush extends Hand {
  StraightFlush(List<dynamic> cards, Game game, [bool? canDisqualify])
      : super(cards, 'Straight Flush', game, canDisqualify);

  @override
  bool solve() {
    List<Card>? cards;
    resetWildCards();
    List<Card>? possibleStraight;
    List<Card> nonCards = [];

    for (var suit in suits.keys) {
      cards = getCardsForFlush(suit, false);
      if (cards != null && cards.length >= game.sfQualify) {
        possibleStraight = cards;
        break;
      }
    }

    if (possibleStraight != null) {
      if (game.descr != 'standard') {
        for (var suit in suits.keys) {
          if (possibleStraight[0].suit != suit) {
            nonCards.addAll(suits[suit] ?? []);
            nonCards = Hand.stripWilds(nonCards, game)[1];
          }
        }
      }
      var straight = Straight(possibleStraight, game, true);
      if (straight.isPossible) {
        this.cards = straight.cards;
        this.cards.addAll(nonCards);
        sfLength = straight.sfLength;
      }
    }

    if (this.cards.isNotEmpty && this.cards[0].rank == 13) {
      descr = 'Royal Flush';
    } else if (this.cards.length >= game.sfQualify) {
      descr =
          '${name}, ${this.cards[0].toString().substring(0, this.cards[0].toString().length - 1)}${this.cards[0].suit} High';
    }

    return this.cards.length >= this.game.sfQualify;
  }
}
