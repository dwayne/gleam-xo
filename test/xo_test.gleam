import gleeunit
import gleeunit/should
import helpers
import prng/seed
import xo.{
  type Game, type Outcome, type Player, Draw, GameAlreadyEnded, O, Occupied,
  OutOfBounds, Undecided, Win, X,
}

pub fn main() {
  gleeunit.main()
}

pub fn play_test() {
  // after 3 plays
  X
  |> helpers.play_many([#(1, 1), #(0, 2), #(2, 0)])
  |> should_equal_state(X, O, "..o.x.x..", Undecided)

  // when X wins
  X
  |> helpers.play_many([
    #(1, 1),
    #(0, 2),
    #(2, 0),
    #(1, 2),
    #(2, 2),
    #(2, 1),
    #(0, 0),
  ])
  |> should_equal_state(
    X,
    X,
    "x.o.xoxox",
    Win(X, [#(#(0, 0), #(1, 1), #(2, 2))]),
  )

  // when O draws
  O
  |> helpers.play_many([
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
  |> should_equal_state(O, O, "xoxxoooxo", Draw(O))

  // when the position is taken
  X
  |> helpers.play_many([#(1, 1)])
  |> xo.play(#(1, 1))
  |> should.equal(Error(Occupied(#(1, 1))))

  // when the position is out of bounds
  X
  |> xo.start
  |> xo.play(#(0, 4))
  |> should.equal(Error(OutOfBounds(#(0, 4))))

  // when the game has already ended
  O
  |> helpers.play_many([#(0, 0), #(1, 0), #(0, 1), #(1, 1), #(0, 2)])
  |> xo.play(#(1, 2))
  |> should.equal(Error(GameAlreadyEnded))
}

fn should_equal_state(
  game: Game,
  first: Player,
  turn: Player,
  layout: String,
  outcome: Outcome,
) {
  let state = xo.to_state(game)

  #(state.first, state.turn, xo.to_string(game), state.outcome)
  |> should.equal(#(first, turn, layout, outcome))
}

pub fn get_random_move_test() {
  X
  |> helpers.play_many([
    #(1, 1),
    #(0, 0),
    #(2, 2),
    #(0, 2),
    #(0, 1),
    #(2, 1),
    #(1, 2),
    #(1, 0),
  ])
  |> xo.get_random_move(seed.new(12_346))
  |> helpers.should_equal_move(#(2, 0))
}

pub fn get_smart_moves_test() {
  X
  |> helpers.play_many([#(0, 0), #(0, 2), #(1, 0), #(2, 1)])
  |> xo.get_smart_moves()
  |> should.equal([#(1, 1), #(1, 2), #(2, 0), #(2, 2)])
}
