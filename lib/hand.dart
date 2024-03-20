import 'package:poker_solver/game.dart';
import 'package:poker_solver/hand/five_of_a_kind.dart';
import 'package:poker_solver/hand/flush.dart';
import 'package:poker_solver/hand/four_of_a_kind.dart';
import 'package:poker_solver/hand/four_of_a_kind_pair_plus.dart';
import 'package:poker_solver/hand/four_wilds.dart';
import 'package:poker_solver/hand/full_house.dart';
import 'package:poker_solver/hand/high_card.dart';
import 'package:poker_solver/hand/natural_royal_flush.dart';
import 'package:poker_solver/hand/one_pair.dart';
import 'package:poker_solver/hand/royal_flush.dart';
import 'package:poker_solver/hand/straight.dart';
import 'package:poker_solver/hand/straight_flush.dart';
import 'package:poker_solver/hand/three_of_a_kind.dart';
import 'package:poker_solver/hand/three_of_a_kind_two_pair.dart';
import 'package:poker_solver/hand/three_pair.dart';
import 'package:poker_solver/hand/two_pair.dart';
import 'package:poker_solver/hand/two_three_of_a_kind.dart';
import 'package:poker_solver/hand/wild_royal_flush.dart';
import 'card.dart';

class Hand {
  late List<Card> cardPool;
  late List<Card> cards;
  late Map<String, List<Card>> suits;
  late List<List<Card>> values;
  late List<Card> wilds;
  late String name;
  late Game game;
  late int sfLength;
  late bool alwaysQualifies;
  late int rank;
  late bool isPossible;

  String? descr;

  Hand(List<dynamic> cards, this.name, this.game, bool? canDisqualify) {
    cardPool = [];
    this.cards = [];
    suits = {};
    values = List.generate(14, (index) => []);
    wilds = [];
    sfLength = 0;
    alwaysQualifies = true;

    if (canDisqualify == true && game.lowestQualified != null) {
      alwaysQualifies = false;
    }

    if (game.descr == 'standard' && Set.from(cards).length != cards.length) {
      throw Error();
    }

    var handRank = game.handValues.length;
    var i = 0;
    for (; i < game.handValues.length; i++) {
      if (game.handValues[i] == runtimeType) {
        break;
      }
    }
    rank = handRank - i;

    cardPool = cards.map((c) => (c is String) ? Card(c) : c as Card).toList();

    for (var i = 0; i < cardPool.length; i++) {
      var card = cardPool[i];
      if (card.value == game.wildValue) {
        card.rank = -1;
      }
    }
    cardPool.sort((a, b) => Card.sort(a, b));

    for (var i = 0; i < cardPool.length; i++) {
      var card = cardPool[i];
      if (card.rank == -1) {
        wilds.add(card);
      } else {
        suits.putIfAbsent(card.suit, () => []);
        suits[card.suit]!.add(card);
        values[card.rank].add(card);
      }
    }

    values = List.from(values.reversed);
    isPossible = solve();
  }

  int compare(Hand a) {
    if (rank < a.rank) {
      return 1;
    } else if (rank > a.rank) {
      return -1;
    }

    int result = 0;
    for (int i = 0; i <= 4; i++) {
      if (cards[i].rank < a.cards[i].rank) {
        result = 1;
        break;
      } else if (cards[i].rank > a.cards[i].rank) {
        result = -1;
        break;
      }
    }
    return result;
  }

  bool loseTo(Hand hand) {
    return (compare(hand) > 0);
  }

  int getNumCardsByRank(int val) {
    var cards = values[val];
    var checkCardsLength = cards?.length ?? 0;

    for (var wild in wilds) {
      if (wild.rank > -1) {
        continue;
      } else if (cards != null) {
        if (game.wildStatus == 1 || cards[0].rank == values.length - 1) {
          checkCardsLength += 1;
        }
      } else if (game.wildStatus == 1 || val == values.length - 1) {
        checkCardsLength += 1;
      }
    }

    return checkCardsLength;
  }

  List<Card> getCardsForFlush(String suit, bool setRanks) {
    var cards = (suits[suit] ?? []).toList()..sort(Card.sort);

    for (var wild in wilds) {
      if (setRanks) {
        var j = 0;
        while (j < values.length && j < cards.length) {
          if (cards[j].rank == values.length - 1 - j) {
            j += 1;
          } else {
            break;
          }
        }
        wild.rank = values.length - 1 - j;
        wild.wildValue = kValues[wild.rank];
      }

      cards.add(wild);
      cards.sort(Card.sort);
    }

    return cards;
  }

  void resetWildCards() {
    for (var wild in wilds) {
      wild.rank = -1;
      wild.wildValue = wild.value;
    }
  }

  List<Card> nextHighest() {
    var picks;
    var excluding = List.from(cards);

    picks = cardPool.where((card) => !excluding.contains(card)).toList();

    if (game.wildStatus == 0) {
      for (var card in picks) {
        if (card.rank == -1) {
          card.wildValue = 'A';
          card.rank = values.length - 1;
        }
      }
      picks.sort(Card.sort);
    }

    return picks;
  }

  @override
  String toString() {
    var cards = this.cards.map((c) => c.toString()).toList();
    return cards.join(', ');
  }

  List<String> toArray() {
    return cards.map((c) => c.toString()).toList();
  }

  bool qualifiesHigh() {
    if (game.lowestQualified == null || alwaysQualifies) {
      return true;
    }

    return (compare(Hand.solveHand(game.lowestQualified, game)) <= 0);
  }

  static List<Hand> winners(List<Hand> hands) {
    hands = hands.where((h) => h.qualifiesHigh()).toList();

    var highestRank = hands.map((h) => h.rank).reduce((a, b) => a > b ? a : b);

    hands = hands.where((h) => h.rank == highestRank).toList();

    hands = hands.where((h) {
      var lose = false;
      for (var hand in hands) {
        lose = h.loseTo(hand);
        if (lose) {
          break;
        }
      }
      return !lose;
    }).toList();

    return hands;
  }

  bool solve() => true;

  static Hand solveHand(List<dynamic>? cards,
      [Game? game, bool canDisqualify = true]) {
    game = game ?? Game('standard');
    cards = cards ?? [''];

    var hands = game.handValues;
    late Hand result;

    for (var handType in hands) {
      result = solveHandType(handType, cards, game, canDisqualify);
      if (result.isPossible) {
        break;
      }
    }

    return result;
  }

  static Hand solveHandType(Type type, cards, game, canDisqualify) {
    switch (type) {
      case FullHouse:
        return FullHouse(cards, game, canDisqualify);
      case FiveOfAKind:
        return FiveOfAKind(cards, game, canDisqualify);
      case Flush:
        return Flush(cards, game, canDisqualify);
      case FourOfAKind:
        return FourOfAKind(cards, game, canDisqualify);
      case FourOfAKindPairPlus:
        return FourOfAKindPairPlus(cards, game, canDisqualify);
      case FourWilds:
        return FourWilds(cards, game, canDisqualify);
      case HighCard:
        return HighCard(cards, game, canDisqualify);
      case NaturalRoyalFlush:
        return NaturalRoyalFlush(cards, game, canDisqualify);
      case OnePair:
        return OnePair(cards, game, canDisqualify);
      case RoyalFlush:
        return RoyalFlush(cards, game, canDisqualify);
      case Straight:
        return Straight(cards, game, canDisqualify);
      case StraightFlush:
        return StraightFlush(cards, game, canDisqualify);
      case ThreeOfAKind:
        return ThreeOfAKind(cards, game, canDisqualify);
      case ThreeOfAKindTwoPair:
        return ThreeOfAKindTwoPair(cards, game, canDisqualify);
      case ThreePair:
        return ThreePair(cards, game, canDisqualify);
      case TwoPair:
        return TwoPair(cards, game, canDisqualify);
      case TwoThreeOfAKind:
        return TwoThreeOfAKind(cards, game, canDisqualify);
      case WildRoyalFlush:
        return WildRoyalFlush(cards, game, canDisqualify);
    }
    throw Exception('null');
  }

  static List<List<Card>> stripWilds(List<Card> cards, Game game) {
    var wilds = <Card>[];
    var nonWilds = <Card>[];

    for (var card in cards) {
      if (card.rank == -1) {
        wilds.add(card);
      } else {
        nonWilds.add(card);
      }
    }

    return [wilds, nonWilds];
  }
}
