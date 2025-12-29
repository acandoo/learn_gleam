import gleam/string

pub const max_safe_integer: Int = 9_007_199_254_740_991

@external(erlang, "io", "get_line")
fn get_line_unwrapped(prompt: String) -> String

@external(javascript, "./externs_ffi.mjs", "getLine")
pub fn get_line(prompt: String, callback: fn(String) -> Nil) -> Nil {
  get_line_unwrapped(prompt)
  |> string.drop_end(1)
  |> callback
}
