import gleam/list
import gleam/option.{type Option, None, Some}
import xo/board.{type Board, type Tile}
import xo/mark.{type Mark}

pub type Outcome {
  Win(Mark, List(Location))
  Draw(Mark)
}

pub type Location {
  R1
  R2
  R3
  C1
  C2
  C3
  D1
  D2
}

pub fn decide(board: Board, mark: Mark) -> Option(Outcome) {
  let tiles = board.to_tiles(board)

  case find_win(tiles, mark) {
    [] ->
      case is_draw(tiles) {
        True -> Some(Draw(mark))
        False -> None
      }

    locations -> Some(Win(mark, locations))
  }
}

fn find_win(tiles: List(Tile), mark: Mark) -> List(Location) {
  let t = Some(mark)

  tiles
  |> to_winning_arrangements()
  |> list.key_filter(#(t, t, t))
}

fn to_winning_arrangements(
  tiles: List(Tile),
) -> List(#(#(Tile, Tile, Tile), Location)) {
  case tiles {
    [a, b, c, d, e, f, g, h, i] -> [
      #(#(a, b, c), R1),
      #(#(d, e, f), R2),
      #(#(g, h, i), R3),
      #(#(a, d, g), C1),
      #(#(b, e, h), C2),
      #(#(c, f, i), C3),
      #(#(a, e, i), D1),
      #(#(c, e, g), D2),
    ]

    _ -> []
  }
}

fn is_draw(tiles: List(Tile)) -> Bool {
  tiles |> list.all(fn(t) { t != None })
}
