import externs.{get_line}
import gleam/io

pub fn main() -> Nil {
  get_line("Enter your name: ")
  |> greet
}

fn greet(name: String) -> Nil {
  io.println("hello, " <> name)
}
