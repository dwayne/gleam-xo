import gleeunit/should
import helpers.{make_moves}
import xo/mark.{O, X}
import xo/referee.{C3, Draw, R1, R3, Undecided, Win, decide}

pub fn decide_test() {
  // when X wins
  X
  |> make_moves([#(0, 0), #(1, 0), #(0, 1), #(1, 1), #(0, 2)])
  |> decide(X)
  |> should.equal(Win(X, [R1]))

  // when O wins
  O
  |> make_moves([#(2, 0), #(1, 0), #(2, 1), #(1, 1), #(2, 2)])
  |> decide(O)
  |> should.equal(Win(O, [R3]))

  // when the rare multi-win occurs
  X
  |> make_moves([
    #(0, 0),
    #(1, 0),
    #(2, 2),
    #(2, 0),
    #(0, 1),
    #(2, 1),
    #(1, 2),
    #(1, 1),
    #(0, 2),
  ])
  |> decide(X)
  |> should.equal(Win(X, [R1, C3]))

  // when it's a draw
  X
  |> make_moves([
    #(0, 0),
    #(1, 1),
    #(2, 2),
    #(0, 1),
    #(2, 1),
    #(2, 0),
    #(0, 2),
    #(1, 2),
    #(1, 0),
  ])
  |> decide(X)
  |> should.equal(Draw(X))

  // after 2 moves it's still undecided
  X
  |> make_moves([#(0, 0), #(1, 1)])
  |> decide(O)
  |> should.equal(Undecided)
}
