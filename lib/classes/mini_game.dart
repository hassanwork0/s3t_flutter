import 'package:s3t/classes/game_stats.dart';
import 'package:s3t/core/constants/players.dart';

class MiniGame {
  List<String> board = List.filled(9, '');
  String? miniGameWinner;

  String? checkWinner() {
    const List<List<int>> winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var combination in winningCombinations) {
      if (board[combination[0]] != AppPlayers.emptyCell &&
          board[combination[0]] == board[combination[1]] &&
          board[combination[1]] == board[combination[2]]) {
        return board[combination[0]];
      }
    }

    if (!board.contains('')) {
      return AppPlayers.draw;
    }

    return null;
  }

  bool handleTap(int gameIndex, int cellIndex) {
    if ((gameIndex == GameStats.miniGameIndex ||
            GameStats.mainBoard[GameStats.miniGameIndex].miniGameWinner !=
                null) &&
        GameStats.gameWinner == null) {
      if (GameStats.mainBoard[gameIndex].miniGameWinner == null &&
          GameStats.mainBoard[gameIndex].board[cellIndex] ==
              AppPlayers.emptyCell) {
        return true;
      }
    }
    return false;
  }

  
}
