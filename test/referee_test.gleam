import gleam/option.{None, Some}
import gleeunit/should
import helpers
import xo/internal/mark.{O, X}
import xo/internal/referee.{C3, Draw, R1, R3, Win}

pub fn decide_test() {
  // when X wins
  X
  |> helpers.make_moves([#(0, 0), #(1, 0), #(0, 1), #(1, 1), #(0, 2)])
  |> referee.decide(X)
  |> should.equal(Some(Win(X, [R1])))

  // when O wins
  O
  |> helpers.make_moves([#(2, 0), #(1, 0), #(2, 1), #(1, 1), #(2, 2)])
  |> referee.decide(O)
  |> should.equal(Some(Win(O, [R3])))

  // when the rare multi-win occurs
  X
  |> helpers.make_moves([
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
  |> referee.decide(X)
  |> should.equal(Some(Win(X, [R1, C3])))

  // when it's a draw
  X
  |> helpers.make_moves([
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
  |> referee.decide(X)
  |> should.equal(Some(Draw(X)))

  // after 2 moves it's still undecided
  X
  |> helpers.make_moves([#(0, 0), #(1, 1)])
  |> referee.decide(O)
  |> should.equal(None)
}
