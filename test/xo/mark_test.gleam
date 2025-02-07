import gleeunit/should
import xo/mark

pub fn swap_test() {
  mark.swap(mark.X) |> should.equal(mark.O)
  mark.swap(mark.O) |> should.equal(mark.X)
}

pub fn to_string_test() {
  mark.to_string(mark.X) |> should.equal("x")
  mark.to_string(mark.O) |> should.equal("o")
}
