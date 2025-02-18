# xo

A [Tic-tac-toe](https://en.wikipedia.org/wiki/Tic-tac-toe) library for Gleam.

```gleam
import gleam/io
import gleam/string
import xo.{X}

pub fn main() {
  let game0 = xo.start(X)
  let assert Ok(game1) = xo.play(game0, #(1, 1)) // X
  let assert Ok(game2) = xo.play(game1, #(0, 0)) // O
  let assert Ok(game3) = xo.play(game2, #(2, 2)) // X
  let assert Ok(game4) = xo.play(game3, #(2, 1)) // O

  io.println(xo.to_string(game4))
  // => o...x..ox

  // Where should I play?
  let moves = xo.get_smart_moves(game4)

  io.println(string.inspect(moves))
  // => [#(0, 2), #(1, 2)]

  let assert Ok(game5) = xo.play(game4, #(1, 2)) // X

  // It doesn't matter where you play now,
  // you're going to lose
  let assert Ok(game6) = xo.play(game5, #(0, 2)) // O

  // Make the winning play
  let assert Ok(game7) = xo.play(game6, #(1, 0)) // X

  io.println(string.inspect(xo.to_state(game7)))
  // => State(X, X, Win(X, [#(#(1, 0), #(1, 1), #(1, 2))]))
  //          ^  ^  ^
  //          |  |  |__ outcome
  //          |  |_____ turn
  //          |________ first
}
```
