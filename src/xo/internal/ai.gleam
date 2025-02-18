import gleam/int
import gleam/list
import gleam/option.{None, Some}
import prng/random
import prng/seed.{type Seed}
import xo/internal/board.{type Board, type Position}
import xo/internal/mark.{type Mark}
import xo/internal/referee.{type Outcome, Draw, Win}

pub fn get_random_move(
  board: Board,
  seed: Seed,
) -> Result(#(Position, Seed), Nil) {
  case board.open_positions(board) {
    [pos, ..rest] -> random.uniform(pos, rest) |> random.step(seed) |> Ok()
    [] -> Error(Nil)
  }
}

pub fn get_smart_moves(board: Board, mark: Mark) -> List(Position) {
  let open_positions = board.open_positions(board)

  case list.length(open_positions) {
    0 | 1 | 9 -> open_positions
    _ -> find_best_moves(board, mark, mark.swap(mark), open_positions)
  }
}

type State {
  State(value: Int, positions: List(Position))
}

const initial_state = State(value: min, positions: [])

const min = -3

fn find_best_moves(
  board: Board,
  turn: Mark,
  prev_turn: Mark,
  open_positions: List(Position),
) -> List(Position) {
  case referee.decide(board, prev_turn) {
    None -> {
      let final_state =
        open_positions
        |> list.fold(initial_state, fn(state, pos) {
          let next_board = board.put(board, pos, turn)
          let next_value = negamax(next_board, prev_turn, turn, -1)

          case next_value > state.value {
            True -> State(value: next_value, positions: [pos])
            False ->
              case next_value == state.value {
                True -> State(..state, positions: [pos, ..state.positions])
                False -> state
              }
          }
        })

      list.reverse(final_state.positions)
    }

    _ -> []
  }
}

fn negamax(board: Board, turn: Mark, prev_turn: Mark, color: Int) -> Int {
  case referee.decide(board, prev_turn) {
    None -> {
      let final_value =
        board
        |> board.open_positions()
        |> list.fold(min, fn(value, pos) {
          let next_board = board.put(board, pos, turn)

          int.max(value, color * negamax(next_board, prev_turn, turn, -color))
        })

      color * final_value
    }

    Some(outcome) -> -{ color * score(outcome) }
  }
}

fn score(outcome: Outcome) -> Int {
  case outcome {
    Win(_, _) -> 2
    Draw(_) -> 1
  }
}
