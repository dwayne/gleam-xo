import gleam/io
import xo/mark

pub fn main() {
  io.println(mark.to_string(mark.X))
  io.println(mark.to_string(mark.O))
  io.println(mark.to_string(mark.swap(mark.X)))
  io.println(mark.to_string(mark.swap(mark.O)))
}
