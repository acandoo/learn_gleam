import credit/credit
import externs.{get_line}
import gleam/dict.{type Dict}
import gleam/io
import gleam/string
import hello/hello
import mario_more/mario

pub type ProjectDict =
  Dict(String, fn() -> Nil)

pub fn main() -> Nil {
  let project_dict: ProjectDict =
    dict.from_list([
      #("hello", hello.main),
      #("mario", mario.main),
      #("credit", credit.main),
    ])

  dict.keys(project_dict)
  |> string.join(", ")
  |> project_message
  |> io.println

  use project <- get_project(project_dict)
  project()
}

fn project_message(projects: String) -> String {
  "Available projects: " <> projects
}

// wtf is this signature 😭😭
// to those who are looking back on this,
// get_line is asynchronous, so this wrapper function
// takes a callback with the resulting project as the parameter.
// the project itself is a function, so the callback is a function
// with a function as the one argument.

// yknow looking back this would have been easier if i just
// executed the project function within this function but i'm
// keeping this bc it's absolute chaos of a function signature

// it's not too bad..
fn get_project(projects: ProjectDict, callback: fn(fn() -> Nil) -> Nil) -> Nil {
  use project_name <- get_line("Enter project name: ")

  let main_fn =
    project_name
    |> dict.get(projects, _)
  case main_fn {
    Ok(project) -> callback(project)
    Error(_) -> {
      io.println("Project not found")
      get_project(projects, callback)
    }
  }
}
