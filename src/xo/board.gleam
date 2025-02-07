import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import xo/mark.{type Mark}

// Constants

pub const all_positions: List(Position) = [
  #(0, 0),
  #(0, 1),
  #(0, 2),
  #(1, 0),
  #(1, 1),
  #(1, 2),
  #(2, 0),
  #(2, 1),
  #(2, 2),
]

// Types

pub type Board =
  List(Move)

pub type Move =
  #(Position, Mark)

pub type Position =
  #(Int, Int)

// Modify

pub fn put(board: Board, pos: Position, mark: Mark) -> Board {
  [#(pos, mark), ..board]
}

// Query

pub fn is_open(board: Board, pos: Position) -> Bool {
  is_not_member(board, pos)
}

pub fn in_bounds(pos: Position) -> Bool {
  let #(r, c) = pos

  r >= 0 && r < 3 && c >= 0 && c < 3
}

pub fn open_positions(board: Board) -> List(Position) {
  list.filter(all_positions, is_not_member(board, _))
}

// Convert

pub type Tile =
  Option(Mark)

pub fn to_tiles(board: Board) -> List(Tile) {
  list.map(all_positions, find(board, _))
}

pub type Cell =
  #(Position, Tile)

pub fn to_cells(board: Board) -> List(Cell) {
  list.zip(all_positions, to_tiles(board))
}

pub fn to_string(board: Board) -> String {
  to_tiles(board)
  |> list.map(tile_to_string)
  |> string.concat
}

fn tile_to_string(tile: Tile) -> String {
  case tile {
    Some(mark) -> mark.to_string(mark)
    None -> "."
  }
}

// Association List

fn is_not_member(alist: List(#(a, b)), key: a) -> Bool {
  find(alist, key) == None
}

fn find(alist: List(#(a, b)), search_key: a) -> Option(b) {
  case alist {
    [] -> None
    [#(key, value), ..rest] ->
      case search_key == key {
        True -> Some(value)
        False -> find(rest, search_key)
      }
  }
}
