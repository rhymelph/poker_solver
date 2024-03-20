import 'package:poker_solver/game.dart';
import 'package:poker_solver/hand.dart';

class Flush extends Hand {
  Flush(List<dynamic> cards, Game game, [bool? canDisqualify])
      : super(cards, 'Flush', game, canDisqualify);

  @override
  bool solve() {
    sfLength = 0;
    resetWildCards();

    for (var suit in suits.keys) {
      var cardsList = getCardsForFlush(suit, true);
      if (cardsList.length >= game.sfQualify) {
        cards = cardsList;
        break;
      }
    }

    if (cards != null && cards!.length >= game.sfQualify) {
      descr =
          '$name, ${cards![0].toString().substring(0, cards![0].toString().length - 1)} High';
      sfLength = cards!.length;
      if (cards!.length < game.cardsInHand) {
        cards = cards! +
            nextHighest().take(game.cardsInHand - cards!.length).toList();
      }
    }

    return cards != null && cards!.length >= game.sfQualify;
  }
}
