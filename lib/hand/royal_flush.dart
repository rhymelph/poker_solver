import 'package:poker_solver/game.dart';
import 'package:poker_solver/hand/straight_flush.dart';

class RoyalFlush extends StraightFlush {
  RoyalFlush(List<dynamic> cards, Game game, [bool? canDisqualify])
      : super(cards, game, canDisqualify);

  @override
  bool solve() {
    resetWildCards();
    var result = super.solve();
    return result && descr == 'Royal Flush';
  }
}
