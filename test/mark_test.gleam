import gleeunit/should
import xo/internal/mark.{O, X}

pub fn swap_test() {
  mark.swap(X) |> should.equal(O)
  mark.swap(O) |> should.equal(X)
}

pub fn to_string_test() {
  mark.to_string(X) |> should.equal("x")
  mark.to_string(O) |> should.equal("o")
}
