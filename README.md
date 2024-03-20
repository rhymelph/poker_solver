# PokerSolver

clone https://github.com/goldfire/pokersolver

# How to use?

```dart
import 'package:poker_solver/poker_solver.dart';

void main(){
  /// Straight Flush
  final player1 = Hand.solveHand(["4d", "5d", "6d", '7d', '8d']);
  print('${player1.name} = ${player1.descr}');

  /// Full House
  final player2 = Hand.solveHand(["4d", "4c", "4h", '7d', '7s']);
  
  /// Who win
  var whoWin = Hand.winners([player1,player2]);
}

```

## LICENSE
    Copyright 2024 rhymelph

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.