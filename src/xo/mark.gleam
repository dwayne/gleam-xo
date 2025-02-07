pub type Mark {
  X
  O
}

pub fn swap(mark: Mark) -> Mark {
  case mark {
    X -> O
    O -> X
  }
}

pub fn to_string(mark: Mark) -> String {
  case mark {
    X -> "x"
    O -> "o"
  }
}
