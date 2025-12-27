import externs.{get_line}
import gleam/dict.{type Dict}
import gleam/io
import gleam/string
import hello/hello
import mario_more/mario

// TODO make comprehensive
pub type ProjectDict =
  Dict(String, fn() -> Nil)

pub fn main() -> Nil {
  let project_dict: ProjectDict =
    dict.from_list([#("hello", hello.main), #("mario", mario.main)])

  dict.keys(project_dict)
  |> string.join(", ")
  |> project_message
  |> io.println

  get_project(project_dict)()
}

fn project_message(projects: String) -> String {
  "Available projects: " <> projects
}

fn get_project(projects: ProjectDict) -> fn() -> Nil {
  let main_fn =
    get_line("Enter project name: ")
    |> dict.get(projects, _)
  case main_fn {
    Ok(project) -> project
    Error(_) -> {
      io.println("Project not found")
      get_project(projects)
    }
  }
}
