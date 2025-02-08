import gleeunit/should
import helpers
import xo/internal/board
import xo/internal/mark.{O, X}

pub fn is_open_test() {
  []
  |> board.is_open(#(0, 1))
  |> should.be_true

  X
  |> helpers.put_many([#(0, 1)])
  |> board.is_open(#(0, 1))
  |> should.be_false
}

pub fn open_positions_test() {
  []
  |> board.open_positions()
  |> should.equal(board.all_positions)

  X
  |> helpers.put_many([#(0, 0), #(0, 2), #(1, 1), #(2, 0), #(2, 2)])
  |> board.open_positions()
  |> should.equal([#(0, 1), #(1, 0), #(1, 2), #(2, 1)])
}

pub fn to_string_test() {
  X
  |> helpers.put_many([#(0, 0), #(1, 1)])
  |> board.to_string()
  |> should.equal("x...o....")

  O
  |> helpers.put_many([#(0, 0), #(1, 1)])
  |> board.to_string()
  |> should.equal("o...x....")
}
