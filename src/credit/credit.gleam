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

pub fn check_validity(input: String, input_num: Int) -> Result(CreditCard, Nil) {
  case
    check_luhn(input_num, string.length(input)),
    check_amex(input),
    check_mastercard(input),
    check_visa(input)
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

  // let's also normalize the number to have an even number of digits while we're at it
  let #(right_acc, number, num_length) = case num_length % 2 {
    0 -> #(0, number, num_length)
    _ -> {
      let assert Ok(right_pwr) = int_power(10, { num_length - 1 })
      #(number / right_pwr, number % right_pwr, num_length - 1)
    }
  }
  echo "number: " <> int.to_string(number)
  echo "numlength: " <> int.to_string(num_length)

  // check_luhn was split into two functions since we only want to do the max_safe_integer check once.
  number <= max_safe_integer && check_luhn_2(number, num_length, 0, right_acc)
}

fn check_luhn_2(
  number: Int,
  num_length: Int,
  left_acc: Int,
  right_acc: Int,
) -> Bool {
  case num_length {
    0 -> { left_acc + right_acc } % 10 == 0
    1 -> { left_acc + right_acc + number } % 10 == 0
    _ -> {
      let assert Ok(left_pwr) = int_power(10, { num_length - 1 })
      let assert Ok(right_pwr) = int_power(10, { num_length - 2 })

      let left_digit = number / left_pwr
      let right_digit = number % left_pwr / right_pwr

      let left_acc =
        left_acc
        + case 2 * left_digit {
          a if a >= 10 -> a / 10 + a % 10
          a -> a
        }
      let right_acc = right_acc + right_digit

      let number = number % right_pwr
      let num_length = num_length - 2
      check_luhn_2(number, num_length, left_acc, right_acc)
    }
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

fn int_power(base: Int, of exponent: Int) -> Result(Int, Nil) {
  case base, exponent > 0, exponent % 2, exponent {
    _, _, _, 0 -> Ok(1)
    -1, _, 0, _ -> Ok(1)
    -1, _, 1, _ -> Ok(-1)
    1, _, _, _ -> Ok(1)
    0, _, _, _ -> Ok(0)
    _, True, _, _ -> int_power_loop(base, exponent, 1)
    _, _, _, _ -> Error(Nil)
  }
}

fn int_power_loop(
  base: Int,
  exponent: Int,
  accumulator: Int,
) -> Result(Int, Nil) {
  case exponent {
    0 -> Ok(accumulator)
    _ -> int_power_loop(base, exponent - 1, accumulator * base)
  }
}

fn get_validity(input: #(String, Int)) -> String {
  let validity = check_validity(input.0, input.1)
  case validity {
    Ok(Amex) -> "AMEX"
    Ok(MasterCard) -> "MASTERCARD"
    Ok(Visa) -> "VISA"
    Error(_) -> "INVALID"
  }
}
