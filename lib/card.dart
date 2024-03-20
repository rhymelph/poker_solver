// NOTE: The 'joker' will be denoted with a value of 'O' and any suit.
const kValues = [
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  'T',
  'J',
  'Q',
  'K',
  'A'
];

class Card {
  late String value;
  late String suit;
  late int rank;
  late String wildValue;

  Card(String str) {
    value = str.substring(0, 1);
    suit = str.substring(1, 2).toLowerCase();
    rank = kValues.indexOf(value);
    wildValue = str.substring(0, 1);
  }

  @override
  String toString() {
    return wildValue.replaceAll('T', '10') + suit;
  }

  static int sort(Card a, Card b) {
    if (a.rank > b.rank) {
      return -1;
    } else if (a.rank < b.rank) {
      return 1;
    } else {
      return 0;
    }
  }
}
