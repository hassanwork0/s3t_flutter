import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s3t/bloc/board/board_event.dart';
import 'package:s3t/bloc/board/board_state.dart';
import 'package:s3t/bloc/minigame/mini_event.dart';
import 'package:s3t/bloc/minigame/mini_state.dart';
import 'package:s3t/classes/game_stats.dart';

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  BoardBloc() : super(BoardInitState()) {
    on<BoardWinnerEvent>((event, emit) {
        emit(BoardUpdatedState());
    });
    on<ResetGameEvent>((event, emit) {
        GameStats().resetStats;
        emit(BoardResetState());
      
    });
    
    on<MakeMoveEvent>((event, emit) {
        emit(MiniUpdateState());
    });

    on<GameEnded>((event, emit) {
      emit(EndGameState());
    },);
  }
}