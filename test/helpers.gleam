import xo/board.{type Board, type Position}
import xo/mark.{type Mark}

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
