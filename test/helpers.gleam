import xo/internal/board.{type Board, type Position}
import xo/internal/mark.{type Mark}

pub fn make_moves(mark: Mark, positions: List(Position)) -> Board {
  make_moves_helper([], mark, positions)
}

fn make_moves_helper(
  board: Board,
  mark: Mark,
  positions: List(Position),
) -> Board {
  case positions {
    [] -> board
    [pos, ..rest] ->
      make_moves_helper(board.put(board, pos, mark), mark.swap(mark), rest)
  }
}
