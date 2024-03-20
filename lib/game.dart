import 'package:poker_solver/hand/five_of_a_kind.dart';
import 'package:poker_solver/hand/flush.dart';
import 'package:poker_solver/hand/four_of_a_kind.dart';
import 'package:poker_solver/hand/four_of_a_kind_pair_plus.dart';
import 'package:poker_solver/hand/four_wilds.dart';
import 'package:poker_solver/hand/full_house.dart';
import 'package:poker_solver/hand/high_card.dart';
import 'package:poker_solver/hand/natural_royal_flush.dart';
import 'package:poker_solver/hand/one_pair.dart';
import 'package:poker_solver/hand/straight.dart';
import 'package:poker_solver/hand/straight_flush.dart';
import 'package:poker_solver/hand/three_of_a_kind.dart';
import 'package:poker_solver/hand/three_of_a_kind_two_pair.dart';
import 'package:poker_solver/hand/three_pair.dart';
import 'package:poker_solver/hand/two_pair.dart';
import 'package:poker_solver/hand/two_three_of_a_kind.dart';
import 'package:poker_solver/hand/wild_royal_flush.dart';

Map<String, dynamic> gameRules = {
  'standard': {
    'cardsInHand': 5,
    'handValues': [
      StraightFlush,
      Flush,
      Straight,
      FullHouse,
      FourOfAKind,
      ThreeOfAKind,
      TwoPair,
      OnePair,
      HighCard
    ],
    'wildValue': null,
    'wildStatus': 1,
    'wheelStatus': 0,
    'sfQualify': 5,
    'lowestQualified': null,
    "noKickers": false
  },
  'jacksbetter': {
    'cardsInHand': 5,
    'handValues': [
      StraightFlush,
      FourOfAKind,
      FullHouse,
      Flush,
      Straight,
      ThreeOfAKind,
      TwoPair,
      OnePair,
      HighCard
    ],
    'wildValue': null,
    'wildStatus': 1,
    'wheelStatus': 0,
    'sfQualify': 5,
    'lowestQualified': ['Jc', 'Jd', '4h', '3s', '2c'],
    "noKickers": true
  },
  'joker': {
    'cardsInHand': 5,
    'handValues': [
      NaturalRoyalFlush,
      FiveOfAKind,
      WildRoyalFlush,
      StraightFlush,
      FourOfAKind,
      FullHouse,
      Flush,
      Straight,
      ThreeOfAKind,
      TwoPair,
      HighCard
    ],
    'wildValue': 'O',
    'wildStatus': 1,
    'wheelStatus': 0,
    'sfQualify': 5,
    'lowestQualified': ['4c', '3d', '3h', '2s', '2c'],
    "noKickers": true
  },
  'deuceswild': {
    'cardsInHand': 5,
    'handValues': [
      NaturalRoyalFlush,
      FourWilds,
      WildRoyalFlush,
      FiveOfAKind,
      StraightFlush,
      FourOfAKind,
      FullHouse,
      Flush,
      Straight,
      ThreeOfAKind,
      HighCard
    ],
    'wildValue': '2',
    'wildStatus': 1,
    'wheelStatus': 0,
    'sfQualify': 5,
    'lowestQualified': ['5c', '4d', '3h', '3s', '3c'],
    "noKickers": true
  },
  'threecard': {
    'cardsInHand': 3,
    'handValues': [
      StraightFlush,
      ThreeOfAKind,
      Straight,
      Flush,
      OnePair,
      HighCard
    ],
    'wildValue': null,
    'wildStatus': 1,
    'wheelStatus': 0,
    'sfQualify': 3,
    'lowestQualified': ['Qh', '3s', '2c'],
    "noKickers": false
  },
  'fourcard': {
    'cardsInHand': 4,
    'handValues': [
      FourOfAKind,
      StraightFlush,
      ThreeOfAKind,
      Flush,
      Straight,
      TwoPair,
      OnePair,
      HighCard
    ],
    'wildValue': null,
    'wildStatus': 1,
    'wheelStatus': 0,
    'sfQualify': 4,
    'lowestQualified': null,
    "noKickers": true
  },
  'fourcardbonus': {
    'cardsInHand': 4,
    'handValues': [
      FourOfAKind,
      StraightFlush,
      ThreeOfAKind,
      Flush,
      Straight,
      TwoPair,
      OnePair,
      HighCard
    ],
    'wildValue': null,
    'wildStatus': 1,
    'wheelStatus': 0,
    'sfQualify': 4,
    'lowestQualified': ['Ac', 'Ad', '3h', '2s'],
    "noKickers": true
  },
  'paigowpokerfull': {
    'cardsInHand': 7,
    'handValues': [
      FiveOfAKind,
      FourOfAKindPairPlus,
      StraightFlush,
      Flush,
      Straight,
      FourOfAKind,
      TwoThreeOfAKind,
      ThreeOfAKindTwoPair,
      FullHouse,
      ThreeOfAKind,
      ThreePair,
      TwoPair,
      OnePair,
      HighCard
    ],
    'wildValue': 'O',
    'wildStatus': 0,
    'wheelStatus': 1,
    'sfQualify': 5,
    'lowestQualified': null
  },
  'paigowpokeralt': {
    'cardsInHand': 7,
    'handValues': [
      FourOfAKind,
      FullHouse,
      ThreeOfAKind,
      ThreePair,
      TwoPair,
      OnePair,
      HighCard
    ],
    'wildValue': 'O',
    'wildStatus': 0,
    'wheelStatus': 1,
    'sfQualify': 5,
    'lowestQualified': null
  },
  'paigowpokersf6': {
    'cardsInHand': 7,
    'handValues': [StraightFlush, Flush, Straight],
    'wildValue': 'O',
    'wildStatus': 0,
    'wheelStatus': 1,
    'sfQualify': 6,
    'lowestQualified': null
  },
  'paigowpokersf7': {
    'cardsInHand': 7,
    'handValues': [StraightFlush, Flush, Straight],
    'wildValue': 'O',
    'wildStatus': 0,
    'wheelStatus': 1,
    'sfQualify': 7,
    'lowestQualified': null
  },
  'paigowpokerhi': {
    'cardsInHand': 5,
    'handValues': [
      FiveOfAKind,
      StraightFlush,
      FourOfAKind,
      FullHouse,
      Flush,
      Straight,
      ThreeOfAKind,
      TwoPair,
      OnePair,
      HighCard
    ],
    'wildValue': 'O',
    'wildStatus': 0,
    'wheelStatus': 1,
    'sfQualify': 5,
    'lowestQualified': null
  },
  'paigowpokerlo': {
    'cardsInHand': 2,
    'handValues': [OnePair, HighCard],
    'wildValue': 'O',
    'wildStatus': 0,
    'wheelStatus': 1,
    'sfQualify': 5,
    'lowestQualified': null
  }
};

class Game {
  String? descr;
  int cardsInHand = 0;
  List handValues = [];
  String? wildValue;
  int wildStatus = 0;
  int wheelStatus = 0;
  int sfQualify = 5;
  List<String>? lowestQualified;
  bool? noKickers;

  Game(this.descr) {
    if (descr == null || gameRules[descr] == null) {
      descr = 'standard';
    }
    cardsInHand = gameRules[descr]!['cardsInHand'];
    handValues = gameRules[descr]!['handValues'];
    wildValue = gameRules[descr]!['wildValue'];
    wildStatus = gameRules[descr]!['wildStatus'];
    wheelStatus = gameRules[descr]!['wheelStatus'];
    sfQualify = gameRules[descr]!['sfQualify'];
    lowestQualified = gameRules[descr]!['lowestQualified'];
    noKickers = gameRules[descr]!['noKickers'];
  }
}
