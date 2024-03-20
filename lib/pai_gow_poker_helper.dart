import 'package:poker_solver/card.dart';
import 'package:poker_solver/game.dart';
import 'package:poker_solver/hand/five_of_a_kind.dart';
import 'package:poker_solver/hand/flush.dart';
import 'package:poker_solver/hand/four_of_a_kind.dart';
import 'package:poker_solver/hand/four_of_a_kind_pair_plus.dart';
import 'package:poker_solver/hand/full_house.dart';
import 'package:poker_solver/hand/one_pair.dart';
import 'package:poker_solver/hand/straight.dart';
import 'package:poker_solver/hand/straight_flush.dart';
import 'package:poker_solver/hand/three_of_a_kind.dart';
import 'package:poker_solver/hand/three_of_a_kind_two_pair.dart';
import 'package:poker_solver/hand/three_pair.dart';
import 'package:poker_solver/hand/two_pair.dart';
import 'package:poker_solver/hand/two_three_of_a_kind.dart';

import 'hand.dart';

class PaiGowPokerHelper {
  late Hand baseHand;
  late Hand hiHand;
  late Hand loHand;
  late Game game;
  Game loGame = Game('paigowpokerlo');
  Game hiGame = Game('paigowpokerhi');

  PaiGowPokerHelper(dynamic hand) {
    baseHand;
    game;
    if (hand is List) {
      baseHand = Hand.solveHand(hand, Game('paigowpokerfull'));
    } else {
      baseHand = hand;
    }

    game = baseHand.game;
  }

  void splitHouseWay() {
    List<Card> hiCards = [];
    List<Card> loCards = [];
    int rank = game.handValues.length - baseHand.rank;
    Type handValue = game.handValues[rank];

    if (handValue == FiveOfAKind) {
      if (baseHand.cards[5].value == 'K' && baseHand.cards[6].value == 'K') {
        loCards = baseHand.cards.sublist(5, 7);
        hiCards = baseHand.cards.sublist(0, 5);
      } else {
        loCards = baseHand.cards.sublist(0, 2);
        hiCards = baseHand.cards.sublist(2, 7);
      }
    } else if (handValue == FourOfAKindPairPlus) {
      if (baseHand.cards[0].wildValue == 'A' &&
          baseHand.cards[4].value != 'K') {
        hiCards = baseHand.cards.sublist(0, 2);
        loCards = baseHand.cards.sublist(2, 4);
        hiCards.addAll(baseHand.cards.sublist(4, 7));
      } else {
        hiCards = baseHand.cards.sublist(0, 4);
        loCards = baseHand.cards.sublist(4, 6);
        hiCards.add(baseHand.cards[6]);
      }
    } else if (handValue == StraightFlush ||
        handValue == Flush ||
        handValue == Straight) {
      late List<List<Card>> sfReturn;
      Game altGame = Game('paigowpokeralt');
      Hand altHand = Hand.solveHand(baseHand.cards, altGame);
      int altRank = altGame.handValues.length - altHand.rank;
      if (altGame.handValues[altRank] == FourOfAKind) {
        sfReturn = getSFData(altHand.cards);
        hiCards = sfReturn[0];
        loCards = sfReturn[1];
      } else if (altGame.handValues[altRank] == FullHouse) {
        hiCards = altHand.cards.sublist(0, 3);
        loCards = altHand.cards.sublist(3, 5);
        hiCards.addAll(altHand.cards.sublist(5, 7));
      } else if (altGame.handValues[altRank] == ThreeOfAKind) {
        sfReturn = getSFData(altHand.cards);
        hiCards = sfReturn[0];
        loCards = sfReturn[1];
      } else if (altGame.handValues[altRank] == ThreePair) {
        loCards = altHand.cards.sublist(0, 2);
        hiCards = altHand.cards.sublist(2, 7);
      } else if (altGame.handValues[altRank] == TwoPair) {
        if (altHand.cards[0].rank < 6) {
          if (altHand.cards[4].wildValue == 'A') {
            hiCards = altHand.cards.sublist(0, 4);
            loCards = altHand.cards.sublist(4, 6);
            hiCards.add(altHand.cards[6]);
          } else {
            sfReturn = getSFData(altHand.cards);
            hiCards = sfReturn[0];
            loCards = sfReturn[1];
          }
        } else if (altHand.cards[0].rank < 10) {
          if (altHand.cards[4].wildValue == 'A') {
            hiCards = altHand.cards.sublist(0, 4);
            loCards = altHand.cards.sublist(4, 6);
            hiCards.add(altHand.cards[6]);
          } else {
            hiCards = altHand.cards.sublist(0, 2);
            loCards = altHand.cards.sublist(2, 4);
            hiCards.addAll(altHand.cards.sublist(4, 7));
          }
        } else if (altHand.cards[0].wildValue != 'A' &&
            altHand.cards[2].rank < 6 &&
            altHand.cards[4].wildValue == 'A') {
          hiCards = altHand.cards.sublist(0, 4);
          loCards = altHand.cards.sublist(4, 6);
          hiCards.add(altHand.cards[6]);
        } else {
          hiCards = altHand.cards.sublist(0, 2);
          loCards = altHand.cards.sublist(2, 4);
          hiCards.addAll(altHand.cards.sublist(4, 7));
        }
      } else if (altGame.handValues[altRank] == OnePair) {
        if (altHand.cards[0].rank >= kValues.indexOf('T') &&
            altHand.cards[0].rank <= kValues.indexOf('K') &&
            altHand.cards[2].wildValue == 'A') {
          List<Card> possibleSF = altHand.cards.sublist(0, 2);
          possibleSF.addAll(altHand.cards.sublist(3, 7));
          sfReturn = getSFData(possibleSF);
          if (sfReturn[0] != null) {
            hiCards = sfReturn[0];
            loCards = sfReturn[1];
            loCards.add(altHand.cards[2]);
          } else {
            hiCards = altHand.cards.sublist(0, 2);
            loCards = altHand.cards.sublist(2, 4);
            hiCards.addAll(altHand.cards.sublist(4, 7));
          }
        } else {
          sfReturn = getSFData(altHand.cards.sublist(2, 7));
          if (sfReturn[0] != null) {
            hiCards = sfReturn[0];
            loCards = altHand.cards.sublist(0, 2);
          } else {
            sfReturn = getSFData(altHand.cards);
            hiCards = sfReturn[0];
            loCards = sfReturn[1];
          }
        }
      } else {
        sfReturn = getSFData(altHand.cards);
        hiCards = sfReturn[0];
        loCards = sfReturn[1];
      }
    } else if (handValue == FourOfAKind) {
      if (baseHand.cards[0].rank < 6) {
        hiCards = baseHand.cards.sublist(0, 4);
        loCards = baseHand.cards.sublist(4, 6);
        hiCards.add(baseHand.cards[6]);
      } else if (baseHand.cards[0].rank < 10 &&
          baseHand.cards[4].wildValue == 'A') {
        hiCards = baseHand.cards.sublist(0, 4);
        loCards = baseHand.cards.sublist(4, 6);
        hiCards.add(baseHand.cards[6]);
      } else {
        hiCards = baseHand.cards.sublist(0, 2);
        loCards = baseHand.cards.sublist(2, 4);
        hiCards.addAll(baseHand.cards.sublist(4, 7));
      }
    } else if (handValue == TwoThreeOfAKind) {
      loCards = baseHand.cards.sublist(0, 2);
      hiCards = baseHand.cards.sublist(3, 6);
      hiCards.add(baseHand.cards[2]);
      hiCards.add(baseHand.cards[6]);
    } else if (handValue == ThreeOfAKindTwoPair) {
      hiCards = baseHand.cards.sublist(0, 3);
      loCards = baseHand.cards.sublist(3, 5);
      hiCards.addAll(baseHand.cards.sublist(5, 7));
    } else if (handValue == FullHouse) {
      if (baseHand.cards[3].wildValue == '2' &&
          baseHand.cards[5].wildValue == 'A' &&
          baseHand.cards[6].wildValue == 'K') {
        hiCards = baseHand.cards.sublist(0, 5);
        loCards = baseHand.cards.sublist(5, 7);
      } else {
        hiCards = baseHand.cards.sublist(0, 3);
        loCards = baseHand.cards.sublist(3, 5);
        hiCards.addAll(baseHand.cards.sublist(5, 7));
      }
    } else if (handValue == ThreeOfAKind) {
      if (baseHand.cards[0].wildValue == 'A') {
        hiCards = baseHand.cards.sublist(0, 2);
        loCards = baseHand.cards.sublist(2, 4);
        hiCards.addAll(baseHand.cards.sublist(4, 7));
      } else {
        hiCards = baseHand.cards.sublist(0, 3);
        loCards = baseHand.cards.sublist(3, 5);
        hiCards.addAll(baseHand.cards.sublist(5, 7));
      }
    } else if (handValue == ThreePair) {
      loCards = baseHand.cards.sublist(0, 2);
      hiCards = baseHand.cards.sublist(2, 7);
    } else if (handValue == TwoPair) {
      if (baseHand.cards[0].rank < 6) {
        hiCards = baseHand.cards.sublist(0, 4);
        loCards = baseHand.cards.sublist(4, 6);
        hiCards.add(baseHand.cards[6]);
      } else if (baseHand.cards[0].rank < 10) {
        if (baseHand.cards[4].wildValue == 'A') {
          hiCards = baseHand.cards.sublist(0, 4);
          loCards = baseHand.cards.sublist(4, 6);
          hiCards.add(baseHand.cards[6]);
        } else {
          hiCards = baseHand.cards.sublist(0, 2);
          loCards = baseHand.cards.sublist(2, 4);
          hiCards.addAll(baseHand.cards.sublist(4, 7));
        }
      } else if (baseHand.cards[0].wildValue != 'A' &&
          baseHand.cards[2].rank < 6 &&
          baseHand.cards[4].wildValue == 'A') {
        hiCards = baseHand.cards.sublist(0, 4);
        loCards = baseHand.cards.sublist(4, 6);
        hiCards.add(baseHand.cards[6]);
      } else {
        hiCards = baseHand.cards.sublist(0, 2);
        loCards = baseHand.cards.sublist(2, 4);
        hiCards.addAll(baseHand.cards.sublist(4, 7));
      }
    } else if (handValue == OnePair) {
      hiCards = baseHand.cards.sublist(0, 2);
      loCards = baseHand.cards.sublist(2, 4);
      hiCards.addAll(baseHand.cards.sublist(4, 7));
    } else {
      hiCards = [baseHand.cards[0]];
      loCards = baseHand.cards.sublist(1, 3);
      hiCards.addAll(baseHand.cards.sublist(3, 7));
    }

    hiHand = Hand.solveHand(hiCards, hiGame);
    loHand = Hand.solveHand(loCards, loGame);
  }

  List<List<Card>> getSFData(List<Card> cards) {
    List<Card>? hiCards;
    List<Card>? possibleLoCards;
    List<Card>? bestLoCards;
    Hand? bestHand;
    List<Hand> handsToCheck = [
      StraightFlush(cards, Game('paigowpokersf7')),
      StraightFlush(cards, Game('paigowpokersf6')),
      StraightFlush(cards, game),
      Flush(cards, Game('paigowpokersf7')),
      Flush(cards, Game('paigowpokersf6')),
      Flush(cards, game),
      Straight(cards, Game('paigowpokersf7')),
      Straight(cards, Game('paigowpokersf6')),
      Straight(cards, game),
    ];

    for (var hand in handsToCheck) {
      if (hand.isPossible) {
        if (hand.sfLength == 7) {
          possibleLoCards = [hand.cards[0], hand.cards[1]];
        } else if (hand.sfLength == 6) {
          possibleLoCards = [hand.cards[0]];
          if (cards.length > 6) {
            possibleLoCards.add(hand.cards[6]);
          }
        } else if (cards.length > 5) {
          possibleLoCards = [hand.cards[5]];
          if (cards.length > 6) {
            possibleLoCards.add(hand.cards[6]);
          }
        }
        if (possibleLoCards != null) {
          possibleLoCards.sort(Card.sort);
          if (bestLoCards == null ||
              bestLoCards[0].rank < possibleLoCards[0].rank ||
              (bestLoCards.length > 1 &&
                  bestLoCards[0].rank == possibleLoCards[0].rank &&
                  bestLoCards[1].rank < possibleLoCards[1].rank)) {
            bestLoCards = List.from(possibleLoCards);
            bestHand = hand;
          }
        } else if (bestHand == null) {
          bestHand = hand;
          break;
        }
      }
    }

    if (bestHand != null) {
      if (bestHand.sfLength == 7) {
        hiCards = bestHand.cards.sublist(2, 7);
      } else if (bestHand.sfLength == 6) {
        hiCards = bestHand.cards.sublist(1, 6);
      } else {
        hiCards = bestHand.cards.sublist(0, 5);
      }
    }
    return [hiCards!, bestLoCards!];
  }

  bool qualifiesValid() {
    List<Hand?> compareHands = Hand.winners([hiHand, loHand]);

    return !(compareHands.length == 1 && compareHands[0] == loHand);
  }

  static int winners(PaiGowPokerHelper player, PaiGowPokerHelper banker) {
    if (!player.qualifiesValid()) {
      if (banker.qualifiesValid()) {
        return -1;
      }
      return 0;
    }

    if (!banker.qualifiesValid()) {
      return 1;
    }

    List<Hand?> hiWinner = Hand.winners([player.hiHand, banker.hiHand]);
    List<Hand?> loWinner = Hand.winners([player.loHand, banker.loHand]);

    if (hiWinner.length == 1 && hiWinner[0] == player.hiHand) {
      if (loWinner.length == 1 && loWinner[0] == player.loHand) {
        return 1;
      }
      return 0;
    }

    if (loWinner.length == 1 && loWinner[0] == player.loHand) {
      return 0;
    }

    return -1;
  }

  static PaiGowPokerHelper setHands(dynamic hiHand, dynamic loHand) {
    List<Card> fullHand = [];

    if (hiHand is List) {
      hiHand = Hand.solveHand(hiHand, Game('paigowpokerhi'));
    }
    fullHand.addAll(hiHand.cardPool);
    if (loHand is List) {
      loHand = Hand.solveHand(loHand, Game('paigowpokerlo'));
    }
    fullHand.addAll(loHand.cardPool);

    var result = PaiGowPokerHelper(fullHand);
    result.hiHand = hiHand;
    result.loHand = loHand;

    return result;
  }

  static PaiGowPokerHelper solve(dynamic fullHand) {
    var result = PaiGowPokerHelper(fullHand ?? ['']);
    result.splitHouseWay();

    return result;
  }
}
