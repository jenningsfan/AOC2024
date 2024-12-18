defmodule AdventOfCode.Day11 do
  use Memoize

  def parse_input(input) do
    input
    |> String.trim
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
  end

  defmemo change_stone(_, 0), do: 1
  defmemo change_stone(stone, iters_left) do
    iters_left = iters_left - 1

    if stone == 0 do
      change_stone(1, iters_left)
    else
      len_stone = length(Integer.digits(stone))

      if rem(len_stone, 2) == 0 do
        half_len = div(len_stone, 2)
        half_len_mul = 10 ** half_len

        change_stone(rem(stone, half_len_mul), iters_left) + change_stone(div(stone, half_len_mul) , iters_left)
      else
        change_stone(stone * 2024, iters_left)
      end
    end

  end

  def solve(input, iters) do
    Enum.reduce(input, 0, fn stone, acc ->
      acc + change_stone(stone, iters)
    end)
  end

  def part1(args) do
    Memoize.invalidate() # enable proper benchmarking

    args
    |> parse_input
    |> solve(25)
  end

  def part2(args) do
    Memoize.invalidate() # enable proper benchmarking

    args
    |> parse_input
    |> solve(75)
  end
end
