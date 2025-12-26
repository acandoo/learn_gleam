import externs.{get_line}
import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub fn main() -> Nil {
  repeat_prompt("Height: ")
  |> make_pyramid(0)
  |> list.each(io.println)
}

pub type InputError {
  NotInRange
  NotANumber
}

fn repeat_prompt(input: String) -> Int {
  let input_int =
    get_line(input)
    |> validate_input
  case input_int {
    Ok(a) -> a
    Error(_) -> repeat_prompt(input)
  }
}

fn make_pyramid(height: Int, spacing: Int) -> List(String) {
  let space = string.repeat(" ", spacing)
  let pyramid = string.repeat("#", height)
  let line = space <> pyramid <> "  " <> pyramid <> space
  case height {
    1 -> [line]
    _ ->
      make_pyramid(height - 1, spacing + 1)
      |> list.append([line])
  }
}

fn validate_input(input: String) -> Result(Int, InputError) {
  let number =
    input
    |> int.parse
  case number {
    Ok(a) -> validate_input_integer(a)
    Error(_) -> Error(NotANumber)
  }
}

fn validate_input_integer(input: Int) -> Result(Int, InputError) {
  case 1 <= input && input <= 8 {
    True -> Ok(input)
    False -> Error(NotInRange)
  }
}
