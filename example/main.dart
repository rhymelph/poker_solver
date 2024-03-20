import 'package:poker_solver/poker_solver.dart';

void main() {
  final hand = Hand.solveHand(["4d", "5d", "6d", '7d', '8d']);
  print('${hand.name} = ${hand.descr}');
}
