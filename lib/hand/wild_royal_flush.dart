import 'package:poker_solver/game.dart';
import 'package:poker_solver/hand/royal_flush.dart';

class WildRoyalFlush extends RoyalFlush {
  WildRoyalFlush(List<dynamic> cards, Game game, [bool? canDisqualify])
      : super(cards, game, canDisqualify);

  @override
  bool solve() {
    var i = 0;
    resetWildCards();
    var result = super.solve();
    if (result && cards != null) {
      for (i = 0; i < game.sfQualify && i < cards!.length; i++) {
        if (cards![i].value == game.wildValue) {
          descr = 'Wild Royal Flush';
          break;
        }
      }
      if (i == game.sfQualify) {
        result = false;
        descr = 'Royal Flush';
      }
    }
    return result;
  }
}
