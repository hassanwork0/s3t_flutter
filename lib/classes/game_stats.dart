import 'package:s3t/classes/mini_game.dart';
import 'package:s3t/core/constants/players.dart';

class GameStats {
  static List<MiniGame> mainBoard = List.generate(9, (_) => MiniGame());
  static String currentPlayer = AppPlayers.playerX;
  static String? gameWinner;
  static int miniGameIndex = 4;

  void resetStats() {
    mainBoard = List.generate(9, (_) => MiniGame());
    currentPlayer = AppPlayers.playerX;
    gameWinner = null;
    miniGameIndex = 4;
  }
}
