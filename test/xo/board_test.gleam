import gleeunit/should
import helpers.{make_moves}
import xo/board.{is_open, open_positions, to_string}
import xo/mark.{O, X}

pub fn is_open_test() {
  []
  |> is_open(#(0, 1))
  |> should.be_true

  X
  |> make_moves([#(0, 1)])
  |> is_open(#(0, 1))
  |> should.be_false
}

pub fn open_positions_test() {
  []
  |> open_positions()
  |> should.equal(board.all_positions)

  X
  |> make_moves([#(0, 0), #(0, 2), #(1, 1), #(2, 0), #(2, 2)])
  |> open_positions()
  |> should.equal([#(0, 1), #(1, 0), #(1, 2), #(2, 1)])
}

pub fn to_string_test() {
  X
  |> make_moves([#(0, 0), #(1, 1)])
  |> to_string()
  |> should.equal("x...o....")

  O
  |> make_moves([#(0, 0), #(1, 1)])
  |> to_string()
  |> should.equal("o...x....")
}
