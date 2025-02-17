import gleeunit/should
import helpers
import prng/seed.{type Seed}
import xo/internal/ai
import xo/internal/board.{type Position}
import xo/internal/mark.{X}

pub fn get_random_move_test() {
  []
  |> ai.get_random_move(seed.new(12_345))
  |> should_equal_move(#(2, 1))

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
  |> should_equal_move(#(2, 0))

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

fn should_equal_move(result: Result(#(Position, Seed), Nil), pos: Position) {
  case result {
    Ok(#(chosen_pos, _)) -> chosen_pos |> should.equal(pos)
    _ -> should.fail()
  }
}
