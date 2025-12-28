import gleam/string

pub const max_safe_integer: Int = 9_007_199_254_740_991

// i feel like this is wrong but it works
@external(erlang, "io", "get_line")
fn get_line_unwrapped(prompt: String) -> String

pub fn get_line(prompt: String) -> String {
  get_line_unwrapped(prompt)
  |> string.trim_end()
}
