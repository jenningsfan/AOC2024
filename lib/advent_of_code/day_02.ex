defmodule AdventOfCode.Day02 do
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn x -> Enum.map(String.split(x, " "), &String.to_integer/1) end)
  end

  def compare(a, b) do
    cond do
      a < b -> :lt
      a > b -> :gt
      true -> :eq
    end
  end

  def solve_part1(input) do
    input = Enum.map(input, fn x -> x
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [x1, x2] -> x1 - x2 end)
    end)

    differ_ok = Enum.map(input, fn row -> Enum.all?(row, fn x -> abs(x) >= 1 && abs(x) <= 3 end) end)
    sign_ok = Enum.map(input, fn row -> Enum.all?(row, fn x -> x > 0 end) or Enum.all?(row, fn x -> x < 0 end) end)

    Enum.zip(differ_ok, sign_ok)
    |> Enum.count(fn {d, s} -> d && s end)
  end

  def part1(args) do
    args
    |> parse_input
    |> solve_part1
  end

  def part2(_args) do
  end
end
