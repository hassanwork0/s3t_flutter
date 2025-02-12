import 'package:flutter/material.dart';
import 'package:s3t/classes/game_stats.dart';
import 'package:s3t/core/constants/colors.dart';
import 'package:s3t/core/constants/players.dart';
import 'package:s3t/core/routes/routes.dart';

class MgScreen extends StatelessWidget {
  const MgScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("game number #${GameStats.miniGameIndex + 1}"),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: 500,
              height: 500,
              child: gridBuilder(GameStats.miniGameIndex)),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, RoutesName.game);
            },
            child: const Text('Return to board'),
          ),
        ],
      )),
    );
  }

  Widget gridBuilder(int gameIndex) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2.0,
        mainAxisSpacing: 2.0,
      ),
      itemCount: 9,
      itemBuilder: (context, cellIndex) {
        return GestureDetector(
          onTap: () => _handleTap(gameIndex, cellIndex , context),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
            ),
            child: Center(
              child: Text(
                GameStats.mainBoard[gameIndex].board[cellIndex],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: GameStats.mainBoard[gameIndex].board[cellIndex] == 'X'
                      ? AppColor.xColor
                      : AppColor.oColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  //!Check if the tap is legit or not
  void _handleTap(int gameIndex, int cellIndex , BuildContext context) {
    if (GameStats.mainBoard[gameIndex].miniGameWinner == null &&
        GameStats.mainBoard[gameIndex].board[cellIndex] ==
            AppPlayers.emptyCell) {
        GameStats.mainBoard[gameIndex].board[cellIndex] =
            GameStats.currentPlayer;
        GameStats.mainBoard[gameIndex].miniGameWinner =
            GameStats.mainBoard[gameIndex].checkWinner();
        if (GameStats.mainBoard[gameIndex].miniGameWinner != null) {
          checkMainWinner();
        }
        GameStats.currentPlayer = GameStats.currentPlayer == AppPlayers.playerX
            ? AppPlayers.playerO
            : AppPlayers.playerX;
            
        gameIndex = cellIndex;
        GameStats.miniGameIndex = gameIndex;
        Navigator.pushReplacementNamed(context, RoutesName.game);
    }

  }

  void checkMainWinner() {
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
      if (GameStats.mainBoard[combination[0]].miniGameWinner != null &&
          GameStats.mainBoard[combination[0]].miniGameWinner ==
              GameStats.mainBoard[combination[1]].miniGameWinner &&
          GameStats.mainBoard[combination[1]].miniGameWinner ==
              GameStats.mainBoard[combination[2]].miniGameWinner) {
        GameStats.gameWinner = GameStats.mainBoard[combination[0]].miniGameWinner;
        return;
      }
    }

    if (GameStats.mainBoard.every((game) => game.miniGameWinner != null)) {
      GameStats.gameWinner = AppPlayers.draw;
    }
  }
}
