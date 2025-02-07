import xo/mark

pub fn swap_test() {
  let assert mark.O = mark.swap(mark.X)
  let assert mark.X = mark.swap(mark.O)
}

pub fn to_string_test() {
  let assert "x" = mark.to_string(mark.X)
  let assert "o" = mark.to_string(mark.O)
}
