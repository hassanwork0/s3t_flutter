class BoardEvent {}

class BoardWinnerEvent extends BoardEvent{
  int gameIndex;
  BoardWinnerEvent(this.gameIndex);
}

class ResetGameEvent extends BoardEvent {}

class GameEnded extends BoardEvent{}
