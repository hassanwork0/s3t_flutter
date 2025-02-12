
import 'package:s3t/bloc/board/board_event.dart';

class MiniGameEvent extends BoardEvent{}

class MakeMoveEvent extends MiniGameEvent{
  int gameIndex;
  int cellIndex;
  MakeMoveEvent(this.gameIndex,this.cellIndex);
}