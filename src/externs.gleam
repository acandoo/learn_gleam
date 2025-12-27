import gleam/string

pub const max_safe_integer = 9007199254740991

// i feel like this is wrong but it works
@external(erlang, "io", "get_line")
fn get_line_unwrapped(prompt: String) -> String

pub fn get_line(prompt: String) -> String {
  get_line_unwrapped(prompt)
  |> string.trim_end()
}

// @external(erlang, "io", "get_line")
// fn get_line_unwrapped(prompt: String) -> Result(String, Nil)

// pub fn get_line(prompt: String) -> Result(String, Nil) {
//   let line = get_line_unwrapped(prompt)
//   case line {
//     Ok(a) -> Ok(string.trim_end(a))
//     b -> b
//   }
// }