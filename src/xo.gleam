import gleam/list
import gleam/option.{None, Some}
import xo/internal/board.{type Board, type Cell}
import xo/internal/mark.{type Mark}
import xo/internal/referee

// Game

pub opaque type Game {
  Playing(first: Player, turn: Player, board: Board)
  GameOver(first: Player, turn: Player, board: Board, outcome: referee.Outcome)
}

pub type Player {
  X
  O
}

// Create

pub fn start(player: Player) -> Game {
  Playing(player, player, [])
}

// Modify

pub type Position =
  #(Int, Int)

pub fn play(game: Game, pos: Position) -> Result(Game, Error) {
  case game {
    Playing(first, turn, board) ->
      case board.in_bounds(pos) {
        True ->
          case board.is_open(board, pos) {
            True -> {
              let mark = player_to_mark(turn)
              let next_board = board.put(board, pos, mark)

              case referee.decide(next_board, mark) {
                None -> Ok(Playing(first, next_turn(turn), next_board))

                Some(outcome) -> Ok(GameOver(first, turn, next_board, outcome))
              }
            }

            False -> Error(Occupied(pos))
          }

        False -> Error(OutOfBounds(pos))
      }

    _ -> Error(GameAlreadyEnded)
  }
}

pub type Error {
  OutOfBounds(Position)
  Occupied(Position)
  GameAlreadyEnded
}

pub type Rules {
  Rules(winner_plays_first: Bool, take_turns_on_draw: Bool)
}

pub fn play_again(game: Game, rules: Rules) -> Game {
  case game {
    Playing(first, ..) -> start(first)

    GameOver(first, turn, _, outcome) ->
      case outcome {
        referee.Win(..) ->
          case rules.winner_plays_first {
            True -> start(turn)
            False -> start(next_turn(turn))
          }

        referee.Draw(_) ->
          case rules.take_turns_on_draw {
            True -> start(next_turn(turn))
            False -> start(first)
          }
      }
  }
}

// Query

pub type State {
  State(first: Player, turn: Player, cells: List(Cell), outcome: Outcome)
}

pub type Outcome {
  Win(Player, List(Line))
  Draw(Player)
  Undecided
}

pub type Line =
  #(Position, Position, Position)

pub fn to_state(game: Game) -> State {
  case game {
    Playing(first, turn, board) ->
      State(first, turn, board.to_cells(board), Undecided)

    GameOver(first, turn, board, outcome) ->
      State(first, turn, board.to_cells(board), case outcome {
        referee.Win(mark, locations) ->
          Win(mark_to_player(mark), list.map(locations, location_to_line))

        referee.Draw(mark) -> Draw(mark_to_player(mark))
      })
  }
}

// Helpers

fn player_to_mark(player: Player) -> Mark {
  case player {
    X -> mark.X
    O -> mark.O
  }
}

fn mark_to_player(mark: Mark) -> Player {
  case mark {
    mark.X -> X
    mark.O -> O
  }
}

fn next_turn(player: Player) -> Player {
  case player {
    X -> O
    O -> X
  }
}

fn location_to_line(location: referee.Location) -> Line {
  case location {
    referee.R1 -> #(#(0, 0), #(0, 1), #(0, 2))
    referee.R2 -> #(#(1, 0), #(1, 1), #(1, 2))
    referee.R3 -> #(#(2, 0), #(2, 1), #(2, 2))
    referee.C1 -> #(#(0, 0), #(1, 0), #(2, 0))
    referee.C2 -> #(#(0, 1), #(1, 1), #(2, 1))
    referee.C3 -> #(#(0, 2), #(1, 2), #(2, 2))
    referee.D1 -> #(#(0, 0), #(1, 1), #(2, 2))
    referee.D2 -> #(#(0, 2), #(1, 1), #(2, 0))
  }
}
