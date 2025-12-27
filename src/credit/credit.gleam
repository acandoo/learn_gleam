import externs.{get_line, max_safe_integer}
import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub fn main() -> Nil {
  prompt_number("Number: ")
  |> get_validity
  |> io.println
}

pub type CreditCard {
  Amex
  MasterCard
  Visa
}

pub fn check_validity(input: #(String, Int)) -> Result(CreditCard, Nil) {
  case
    check_luhn(input.1, string.length(input.0)),
    check_amex(input.0),
    check_mastercard(input.0),
    check_visa(input.0)
  {
    True, True, False, False -> Ok(Amex)
    True, False, True, False -> Ok(MasterCard)
    True, False, False, True -> Ok(Visa)
    _, _, _, _ -> Error(Nil)
  }
}

fn check_luhn(number: Int, num_length: Int) -> Bool {
  // Note: if this code were to be ported to work on the JavaScript runtime,
  // Number.MAX_SAFE_INTEGER *should* not be a problem with regular credit
  // card representations but, just to be safe, we'll check for it

  // let's also normalize the number to have an even number of 

  // check_luhn was split into two functions since we only want to do the max_safe_integer check once.
  number <= max_safe_integer && check_luhn_2(number, num_length, 0, 0)
}

fn check_luhn_2(number: Int, num_length: Int, left_accumulator: Int, right_accumulator: Int) -> Bool {
  case num_length {
    0 -> { left_accumulator + right_accumulator } % 10 == 0
    1 -> {
      let 
    }
    _ -> False
  }
}

fn check_amex(number: String) -> Bool {
  string.length(number) == 15
  && list.contains(["34", "37"], string.slice(number, 0, 2))
}

fn check_mastercard(number: String) -> Bool {
  string.length(number) == 16
  && list.contains(["51", "52", "53", "54", "55"], string.slice(number, 0, 2))
}

fn check_visa(number: String) -> Bool {
  list.contains([13, 16], string.length(number))
  && string.slice(number, 0, 1) == "4"
}

fn prompt_number(prompt: String) -> #(String, Int) {
  let input = get_line(prompt)
  let input_int =
    input
    |> int.parse

  case input_int {
    Ok(a) -> #(input, a)
    Error(_) -> prompt_number(prompt)
  }
}

fn get_validity(input: #(String, Int)) -> String {
  let validity = check_validity(input)
  case validity {
    Ok(Amex) -> "AMEX"
    Ok(MasterCard) -> "MASTERCARD"
    Ok(Visa) -> "VISA"
    Error(_) -> "INVALID"
  }
}
