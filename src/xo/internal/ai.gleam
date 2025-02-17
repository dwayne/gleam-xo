import prng/random
import prng/seed.{type Seed}
import xo/internal/board.{type Board, type Position}

pub fn get_random_move(
  board: Board,
  seed: Seed,
) -> Result(#(Position, Seed), Nil) {
  case board.open_positions(board) {
    [pos, ..rest] -> random.uniform(pos, rest) |> random.step(seed) |> Ok()
    [] -> Error(Nil)
  }
}
