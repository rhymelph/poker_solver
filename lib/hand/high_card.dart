import 'package:poker_solver/card.dart' hide values;
import 'package:poker_solver/game.dart';
import 'package:poker_solver/hand.dart';

class HighCard extends Hand {
  HighCard(List<dynamic> cards, Game game, [bool? canDisqualify])
      : super(cards, 'High Card', game, canDisqualify);

  @override
  bool solve() {
    cards = cardPool.sublist(0, game.cardsInHand);

    for (var i = 0; i < cards.length; i++) {
      var card = cards[i];
      if (card.value == game.wildValue) {
        card.wildValue = 'A';
        card.rank = kValues.indexOf('A');
      }
    }

    if (game.noKickers == true) {
      cards.length = 1;
    }

    cards.sort(Card.sort);
    descr =
        '${cards[0]?.toString()?.substring(0, cards[0]!.toString()!.length - 1) ?? ''} High';

    return true;
  }
}
