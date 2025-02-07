import gleam/io
import xo/board
import xo/mark

pub fn main() {
  io.println(mark.to_string(mark.X))
  io.println(mark.to_string(mark.O))
  io.println(mark.to_string(mark.swap(mark.X)))
  io.println(mark.to_string(mark.swap(mark.O)))

  io.debug(board.put([], #(1, 2), mark.X))
  io.debug(board.put([], #(2, 1), mark.O))
  io.debug(board.open_positions(board.put([], #(2, 1), mark.O)))
  io.debug(board.to_tiles(board.put([#(#(1, 2), mark.X)], #(2, 1), mark.O)))

  io.println(board.to_string(board.put([#(#(1, 2), mark.X)], #(2, 1), mark.O)))
}
