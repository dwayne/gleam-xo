import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import prng/seed.{type Seed}
import xo/internal/ai
import xo/internal/board.{type Board}
import xo/internal/mark.{type Mark}
import xo/internal/referee.{type Location, C1, C2, C3, D1, D2, R1, R2, R3}

// Player

pub type Player {
  X
  O
}

pub fn next_turn(player: Player) -> Player {
  case player {
    X -> O
    O -> X
  }
}

// Game

pub opaque type Game {
  Playing(first: Player, turn: Player, board: Board)
  GameOver(first: Player, turn: Player, board: Board, outcome: referee.Outcome)
}

/// Start a new game such that the given player plays first.
pub fn start(player: Player) -> Game {
  Playing(player, player, [])
}

// Modify

pub type Position =
  #(Int, Int)

pub type PlayError {
  OutOfBounds(Position)
  Occupied(Position)
  GameAlreadyEnded
}

pub fn play(game: Game, pos: Position) -> Result(Game, PlayError) {
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

pub type Rules {
  Rules(winner_plays_first: Bool, take_turns_on_draw: Bool)
}

/// The default rules are that the winner plays first and that you must take turns after a draw.
pub const default_rules = Rules(
  winner_plays_first: True,
  take_turns_on_draw: True,
)

/// Reset the game while respecting the given rules.
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
  State(first: Player, turn: Player, outcome: Outcome)
}

pub type Outcome {
  Win(Player, List(Line))
  Draw(Player)
  Undecided
}

/// The three positions that make up a winning row, column, or diagonal.
pub type Line =
  #(Position, Position, Position)

pub fn to_state(game: Game) -> State {
  case game {
    Playing(first, turn, _) -> State(first, turn, Undecided)

    GameOver(first, turn, _, outcome) ->
      State(first, turn, case outcome {
        referee.Win(mark, locations) ->
          Win(mark_to_player(mark), list.map(locations, location_to_line))

        referee.Draw(mark) -> Draw(mark_to_player(mark))
      })
  }
}

pub type Tile =
  Option(Player)

pub fn map(game: Game, f: fn(Position, Tile) -> a) -> List(a) {
  board.map(game.board, fn(pos, mark_tile) {
    f(pos, option.map(mark_tile, mark_to_player))
  })
}

pub fn to_string(game: Game) -> String {
  map(game, fn(_, tile) { tile_to_string(tile) })
  |> string.concat
}

fn tile_to_string(tile: Tile) -> String {
  case tile {
    Some(X) -> "x"
    Some(O) -> "o"
    None -> "."
  }
}

// AI

pub fn get_random_move(game: Game, seed: Seed) -> Result(#(Position, Seed), Nil) {
  case game {
    Playing(_, _, board) -> ai.get_random_move(board, seed)
    _ -> Error(Nil)
  }
}

pub fn get_smart_moves(game: Game) -> List(Position) {
  case game {
    Playing(_, turn, board) -> ai.get_smart_moves(board, player_to_mark(turn))
    _ -> []
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

fn location_to_line(location: Location) -> Line {
  case location {
    R1 -> #(#(0, 0), #(0, 1), #(0, 2))
    R2 -> #(#(1, 0), #(1, 1), #(1, 2))
    R3 -> #(#(2, 0), #(2, 1), #(2, 2))
    C1 -> #(#(0, 0), #(1, 0), #(2, 0))
    C2 -> #(#(0, 1), #(1, 1), #(2, 1))
    C3 -> #(#(0, 2), #(1, 2), #(2, 2))
    D1 -> #(#(0, 0), #(1, 1), #(2, 2))
    D2 -> #(#(0, 2), #(1, 1), #(2, 0))
  }
}
