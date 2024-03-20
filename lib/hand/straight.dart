import 'package:poker_solver/card.dart';
import 'package:poker_solver/game.dart';
import 'package:poker_solver/hand.dart';

class Straight extends Hand {
  Straight(List<dynamic> cards, Game game, [bool? canDisqualify])
      : super(cards, 'Straight', game, canDisqualify);

  @override
  bool solve() {
    Card card;
    List<Card> checkCards;
    resetWildCards();

    if (this.game.wheelStatus == 1) {
      this.cards = getWheel();
      if (this.cards.isNotEmpty) {
        int wildCount = 0;
        for (var i = 0; i < this.cards.length; i++) {
          card = this.cards[i];
          if (card.value == this.game.wildValue) {
            wildCount += 1;
          }
          if (card.rank == 0) {
            card.rank = kValues.indexOf('A');
            card.wildValue = 'A';
            if (card.value == '1') {
              card.value = 'A';
            }
          }
        }
        this.cards.sort(Card.sort);
        for (;
            wildCount < this.wilds.length &&
                this.cards.length < this.game.cardsInHand;
            wildCount++) {
          card = this.wilds[wildCount];
          card.rank = kValues.indexOf('A');
          card.wildValue = 'A';
          this.cards.add(card);
        }
        descr = '${this.name}, Wheel';
        this.sfLength = game.sfQualify;
        if (this.cards[0].value == 'A') {
          this.cards.addAll(this
              .nextHighest()
              .sublist(1, this.game.cardsInHand - this.cards.length + 1));
        } else {
          this.cards.addAll(this
              .nextHighest()
              .sublist(0, this.game.cardsInHand - this.cards.length));
        }
        return true;
      }
      resetWildCards();
    }

    this.cards = getGaps();

    for (var i = 0; i < this.wilds.length; i++) {
      card = this.wilds[i];
      checkCards = getGaps(this.cards.length);
      if (this.cards.length == checkCards.length) {
        if (this.cards[0].rank < (values.length - 1)) {
          card.rank = this.cards[0].rank + 1;
          card.wildValue = kValues[card.rank];
          this.cards.add(card);
        } else {
          card.rank = this.cards[this.cards.length - 1].rank - 1;
          card.wildValue = kValues[card.rank];
          this.cards.add(card);
        }
      } else {
        for (var j = 1; j < this.cards.length; j++) {
          if (this.cards[j - 1].rank - this.cards[j].rank > 1) {
            card.rank = this.cards[j - 1].rank - 1;
            card.wildValue = kValues[card.rank];
            this.cards.add(card);
            break;
          }
        }
      }
      this.cards.sort(Card.sort);
    }
    if (this.cards.length >= this.game.sfQualify) {
      descr =
          '${this.name}, ${this.cards[0].toString().substring(0, this.cards[0].toString().length - 1)} High';
      this.cards = this.cards.sublist(0, this.game.cardsInHand);
      this.sfLength = this.cards.length;
      if (this.cards.length < this.game.cardsInHand) {
        if (this.cards[this.sfLength - 1].rank == 0) {
          this.cards.addAll(this
              .nextHighest()
              .sublist(1, this.game.cardsInHand - this.cards.length + 1));
        } else {
          this.cards.addAll(this
              .nextHighest()
              .sublist(0, this.game.cardsInHand - this.cards.length));
        }
      }
    }

    return this.cards.length >= this.game.sfQualify;
  }

  List<Card> getGaps([int? checkHandLength]) {
    List<Card> wildCards, cardsToCheck, gapCards, cardsList;
    int i, gapCount, prevCard, diff;

    var stripReturn = Hand.stripWilds(this.cardPool, this.game);
    wildCards = stripReturn[0];
    cardsToCheck = stripReturn[1];

    for (i = 0; i < cardsToCheck.length; i++) {
      var card = cardsToCheck[i];
      if (card.wildValue == 'A') {
        cardsToCheck.add(Card('1${card.suit}'));
      }
    }
    cardsToCheck.sort(Card.sort);

    if (checkHandLength != null) {
      i = cardsToCheck[0].rank + 1;
    } else {
      checkHandLength = this.game.sfQualify;
      i = values.length;
    }

    gapCards = [];
    for (; i > 0; i--) {
      cardsList = [];
      gapCount = 0;
      for (var j = 0; j < cardsToCheck.length; j++) {
        var card = cardsToCheck[j];
        if (card.rank > i) {
          continue;
        }
        prevCard =
            (cardsList.isNotEmpty) ? cardsList[cardsList.length - 1].rank : i;
        diff = (prevCard != null) ? prevCard - card.rank : i - card.rank;

        if (diff == null) {
          cardsList.add(card);
        } else if (checkHandLength < (gapCount + diff + cardsList.length)) {
          break;
        } else if (diff > 0) {
          cardsList.add(card);
          gapCount += (diff - 1);
        }
      }
      if (cardsList.length > gapCards.length) {
        gapCards = List.from(cardsList);
      }
      if (this.game.sfQualify - gapCards.length <= wildCards.length) {
        break;
      }
    }

    return gapCards;
  }

  List<Card> getWheel() {
    var wildCards, cardsToCheck, i, card, wheelCards, wildCount, cardFound;

    var stripReturn = Hand.stripWilds(cardPool, game);
    wildCards = stripReturn[0];
    cardsToCheck = stripReturn[1];

    for (i = 0; i < cardsToCheck.length; i++) {
      card = cardsToCheck[i];
      if (card.wildValue == 'A') {
        cardsToCheck.add(Card('1' + card.suit));
      }
    }
    cardsToCheck.sort((a, b) => a.rank.compareTo(b.rank));

    wheelCards = [];
    wildCount = 0;
    for (i = game.sfQualify! - 1; i >= 0; i--) {
      cardFound = false;
      for (var j = 0; j < cardsToCheck.length; j++) {
        card = cardsToCheck[j];
        if (card.rank > i) {
          continue;
        }
        if (card.rank < i) {
          break;
        }
        wheelCards.add(card);
        cardFound = true;
        break;
      }
      if (!cardFound) {
        if (wildCount < wildCards.length) {
          wildCards[wildCount].rank = i;
          wildCards[wildCount].wildValue = values[i];
          wheelCards.add(wildCards[wildCount]);
          wildCount += 1;
        } else {
          return [];
        }
      }
    }

    return wheelCards;
  }
}
