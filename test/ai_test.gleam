import gleeunit/should
import helpers
import prng/seed
import xo/internal/ai
import xo/internal/mark.{O, X}

pub fn get_random_move_test() {
  []
  |> ai.get_random_move(seed.new(12_345))
  |> helpers.should_equal_move(#(2, 1))

  X
  |> helpers.put_many([
    #(1, 1),
    #(0, 0),
    #(2, 2),
    #(0, 2),
    #(0, 1),
    #(2, 1),
    #(1, 2),
    #(1, 0),
  ])
  |> ai.get_random_move(seed.new(12_346))
  |> helpers.should_equal_move(#(2, 0))

  X
  |> helpers.put_many([
    #(1, 1),
    #(0, 0),
    #(2, 2),
    #(0, 2),
    #(0, 1),
    #(2, 1),
    #(1, 2),
    #(1, 0),
    #(2, 0),
  ])
  |> ai.get_random_move(seed.new(12_347))
  |> should.be_error()
}

pub fn get_smart_moves_test() {
  //
  //    0   1   2
  // 0  x |   | o
  //   ---+---+---
  // 1    | x |
  //   ---+---+---
  // 2    |   |
  //
  // It finds the blocking move to avoid losing.
  //
  X
  |> helpers.put_many([#(0, 0), #(0, 2), #(1, 1)])
  |> ai.get_smart_moves(O)
  |> should.equal([#(2, 2)])

  //
  //    0   1   2
  // 0  x | o |
  //   ---+---+---
  // 1    | x |
  //   ---+---+---
  // 2    |   |
  //
  // It has no good moves since every position is losing.
  //
  X
  |> helpers.put_many([#(0, 0), #(0, 1), #(1, 1)])
  |> ai.get_smart_moves(O)
  |> should.equal([#(0, 2), #(1, 0), #(1, 2), #(2, 0), #(2, 1), #(2, 2)])

  //
  //    0   1   2
  // 0  x |   | o
  //   ---+---+---
  // 1  x |   |
  //   ---+---+---
  // 2    | o |
  //
  // It finds the winning moves.
  //
  X
  |> helpers.put_many([#(0, 0), #(0, 2), #(1, 0), #(2, 1)])
  |> ai.get_smart_moves(X)
  |> should.equal([#(1, 1), #(1, 2), #(2, 0), #(2, 2)])

  //
  //    0   1   2
  // 0  x |   | o
  //   ---+---+---
  // 1    |   |
  //   ---+---+---
  // 2  x |   | o
  //
  // It favors winning over blocking.
  //
  X
  |> helpers.put_many([#(2, 0), #(0, 2), #(0, 0), #(2, 2)])
  |> ai.get_smart_moves(X)
  |> should.equal([#(1, 0)])
}
