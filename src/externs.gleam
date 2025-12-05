import gleam/string

// i feel like this is wrong but it works
@external(erlang, "io", "get_line")
fn get_line_unwrapped(prompt: String) -> String

pub fn get_line(prompt: String) -> String {
  get_line_unwrapped(prompt)
  |> string.trim_end()
}
