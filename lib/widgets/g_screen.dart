import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s3t/bloc/board/board_bloc.dart';
import 'package:s3t/bloc/board/board_event.dart';
import 'package:s3t/bloc/board/board_state.dart';
import 'package:s3t/bloc/minigame/mini_event.dart';
import 'package:s3t/classes/game_stats.dart';
import 'package:s3t/core/constants/constants.dart';
import 'package:s3t/core/constants/players.dart';
import 'package:s3t/core/routes/routes.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  //!Real Shit is here
  @override
  Widget build(BuildContext context) {
    BoardBloc board = context.read<BoardBloc>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: BlocBuilder<BoardBloc, BoardState>(
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (GameStats.gameWinner != null)
                  Text(
                    GameStats.gameWinner == AppPlayers.draw
                        ? AppPlayers.draw
                        : AppPlayers.winner,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                gameTable(context, board),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        GameStats().resetStats();
                        board.add(ResetGameEvent());
                      },
                      child: const Text('Restart Game'),
                    ),
                    if (GameStats.gameWinner == null)
                      ElevatedButton(
                        onPressed: () => _gotoGame(context),
                        child: const Text('Goto Game'),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  //!Check if the tap is legit or not
  void _handleTap(int gameIndex, int cellIndex, BoardBloc board) {
    if ((gameIndex == GameStats.miniGameIndex ||
            GameStats.mainBoard[GameStats.miniGameIndex].miniGameWinner !=
                null) &&
        GameStats.gameWinner == null) {
      if (GameStats.mainBoard[gameIndex].miniGameWinner == null &&
          GameStats.mainBoard[gameIndex].board[cellIndex] ==
              AppPlayers.emptyCell) {
        GameStats.mainBoard[gameIndex].board[cellIndex] =
            GameStats.currentPlayer;

        if (GameStats.mainBoard[gameIndex].miniGameWinner == null) {
          GameStats.mainBoard[gameIndex].miniGameWinner =
              GameStats.mainBoard[gameIndex].checkWinner();
          if (GameStats.mainBoard[gameIndex].miniGameWinner != null) {
            board.add(BoardWinnerEvent(gameIndex));
          }
        }

        if (GameStats.mainBoard[gameIndex].miniGameWinner != null) {
          _checkMainWinner(gameIndex, board);
        }
        GameStats.currentPlayer = GameStats.currentPlayer == AppPlayers.playerX
            ? AppPlayers.playerO
            : AppPlayers.playerX;

        gameIndex = cellIndex;
        GameStats.miniGameIndex = gameIndex;
        board.add(MakeMoveEvent(gameIndex, cellIndex));
      }
    }
  }

  void _checkMainWinner(int gameIndex, BoardBloc board) {
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
        GameStats.gameWinner =
            GameStats.mainBoard[combination[0]].miniGameWinner ==
                    AppPlayers.draw
                ? AppPlayers.draw
                : GameStats.mainBoard[combination[0]].miniGameWinner;
        board.add(GameEnded());
        return;
      }
    }

    if (GameStats.mainBoard.every((game) => game.miniGameWinner != null)) {
      GameStats.gameWinner = AppPlayers.draw;
    }
  }

  void _gotoGame(BuildContext context) {
    Navigator.pushReplacementNamed(context, RoutesName.mini);
  }

  Widget gameTable(BuildContext context, BoardBloc board) {
    double containerSize = MediaQuery.of(context).size.width >= 410 ? 700 : 400;

    return Container(
      width: containerSize,
      height: containerSize,
      color: AppColor.black,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 columns
          crossAxisSpacing: 2.0,
          mainAxisSpacing: 2.0,
          childAspectRatio: 1.0, // Ensures square cells
        ),
        itemCount: 9,
        itemBuilder: (context, gameIndex) {
          return GameStats.mainBoard[gameIndex].miniGameWinner != null
              ? winnerBox(gameIndex)
              : gridBuilder(gameIndex, board);
        },
      ),
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount gridCrossAxis() {
    return const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
    );
  }

  Widget winnerBox(int gameIndex) {
    return Container(
      color: AppColor.black,
      child: Center(
        child: Text(
          GameStats.mainBoard[gameIndex].miniGameWinner!,
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: GameStats.mainBoard[gameIndex].miniGameWinner ==
                    AppPlayers.playerX
                ? AppColor.xColor
                : AppColor.oColor,
          ),
        ),
      ),
    );
  }

  Widget gridBuilder(int gameIndex, BoardBloc board) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
      ),
      itemCount: 9,
      itemBuilder: (context, cellIndex) {
        return GestureDetector(
          onTap: () => _handleTap(gameIndex, cellIndex, board),
          child: Container(
            decoration: BoxDecoration(
              color: coloringTable(gameIndex),
              border: Border.all(color: AppColor.black),
            ),
            child: Center(
              child: Text(
                GameStats.mainBoard[gameIndex].board[cellIndex],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: GameStats.mainBoard[gameIndex].board[cellIndex] ==
                          AppPlayers.playerX
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

  Color coloringTable(int gameIndex) {
    if (GameStats.gameWinner != null) {
      return AppColor.grey;
    }
    if (GameStats.mainBoard[GameStats.miniGameIndex].miniGameWinner != null) {
      return AppColor.white;
    }
    if (gameIndex == GameStats.miniGameIndex) {
      return AppColor.white;
    } else {
      return AppColor.grey;
    }
  }
}
