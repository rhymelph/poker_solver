import 'package:flutter_test/flutter_test.dart';
import 'package:poker_solver/hand.dart';

import 'package:poker_solver/poker_solver.dart';

var s = ['d', 'c', 'h', 's'];

void main() {
  // test('Five of a kind', () {
  //   final hand = Hand.solveHand(["2d", "2c", "2h", '2s', 'Os']);
  //   print('${hand.name} = ${hand.descr}');
  //   expect(hand.name, 'Five of a kind');
  // });
  test('Straight Flush', () {
    final hand = Hand.solveHand(["4d", "5d", "6d", '7d', '8d']);
    print('${hand.name} = ${hand.descr}');
    expect(hand.name, 'Straight Flush');
  });
  test('Four of a Kind', () {
    final hand = Hand.solveHand(["5d", "5c", "5h", '5s', 'As']);
    print('${hand.name} = ${hand.descr}');
    expect(hand.name, 'Four of a Kind');
  });
  test('Full House', () {
    final hand = Hand.solveHand(["5d", "5c", "5h", 'Ad', 'As']);
    print('${hand.name} = ${hand.descr}');
    expect(hand.name, 'Full House');
  });
  test('Flush', () {
    final hand = Hand.solveHand(["Jd", "9d", "8d", '4d', '3d']);
    print('${hand.name} = ${hand.descr}');
    expect(hand.name, 'Flush');
  });
  test('Straight', () {
    final hand = Hand.solveHand(["5s", "6d", "7d", '8d', '9d']);
    print('${hand.name} = ${hand.descr}');
    expect(hand.name, 'Straight');
  });
  test('Three of a Kind', () {
    final hand = Hand.solveHand(["Qd", "Qc", "Qh", '8d', 'Ks']);
    print('${hand.name} = ${hand.descr}');
    expect(hand.name, 'Three of a Kind');
  });
  test('Two Pair', () {
    final hand = Hand.solveHand(["Jd", "Jc", "3d", '3c', 'Ks']);
    print('${hand.name} = ${hand.descr}');
    expect(hand.name, 'Two Pair');
  });
  test('Pair', () {
    final hand = Hand.solveHand(["Td", "Tc", "8d", '7c', '4s']);
    print('${hand.name} = ${hand.descr}');
    expect(hand.name, 'Pair');
  });
  test('High Card', () {
    final hand = Hand.solveHand(["Kd", "Tc", "8d", '7c', '4s']);
    print('${hand.name} = ${hand.descr}');
    expect(hand.name, 'High Card');
  });
  test('High Card Wins', () {
    final hand2 = Hand.solveHand(["Kd", "Tc", "8d", '7c', '4s']);
    final hand3 = Hand.solveHand(["Qs", "Td", "8s", '7d', '4d']);
    var win = Hand.winners([hand2, hand3]);
    print('win = $win');
    // expect(win.name, 'High Card');
  });
}
