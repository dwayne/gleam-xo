import xo.{type Game, type Player}
import xo/internal/board.{type Board, type Position}
import xo/internal/mark.{type Mark}

pub fn put_many(mark: Mark, positions: List(Position)) -> Board {
  put_many_helper([], mark, positions)
}

fn put_many_helper(board: Board, mark: Mark, positions: List(Position)) -> Board {
  case positions {
    [] -> board
    [pos, ..rest] ->
      put_many_helper(board.put(board, pos, mark), mark.swap(mark), rest)
  }
}

pub fn play_many(player: Player, positions: List(Position)) -> Game {
  player
  |> xo.start()
  |> play_many_helper(positions)
}

fn play_many_helper(game: Game, positions: List(Position)) -> Game {
  case positions {
    [] -> game
    [pos, ..rest] ->
      case xo.play(game, pos) {
        Ok(next_game) -> play_many_helper(next_game, rest)
        Error(_) -> play_many_helper(game, rest)
      }
  }
}
