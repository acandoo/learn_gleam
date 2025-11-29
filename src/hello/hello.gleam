import gleam/io
import externs.{get_line}

pub fn main() -> Nil {
  get_line("Enter your name: ") 
  |> greet()
}

fn greet(name: String) -> Nil {
  io.println("hello, " <> name)
}

