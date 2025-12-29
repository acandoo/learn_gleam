import externs.{get_line}
import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub fn main() -> Nil {
  use input <- repeat_prompt("Height: ")

  input
  |> make_pyramid(0)
  |> list.each(io.println)
}

pub type InputError {
  NotInRange
  NotANumber
}

fn repeat_prompt(prompt: String, callback: fn(Int) -> Nil) -> Nil {
  use input <- get_line(prompt)
  let input_int = validate_input(input)
  case input_int {
    Ok(a) -> callback(a)
    Error(_) -> repeat_prompt(prompt, callback)
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
