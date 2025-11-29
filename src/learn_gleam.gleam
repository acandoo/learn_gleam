import gleam/string
import gleam/io
import gleam/dict.{type Dict}
import hello/hello
import externs.{get_line}

// TODO make comprehensive
pub type ProjectDict = Dict(String, fn() -> Nil)

pub fn main() -> Nil {
  let project_dict: ProjectDict = dict.from_list([
    #("hello", hello.main)
  ])

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
  get_line("Enter project name: ")
  |> dict.get(projects, _)
  |> fn (a) { case a {
      Ok(project) -> project
      Error(_) -> { 
        io.println("Project not found")
        get_project(projects)
      }
    }}
}
