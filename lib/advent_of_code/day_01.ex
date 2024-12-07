defmodule AdventOfCode.Day01 do
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn x -> Enum.map(String.split(x, "   "), &String.to_integer/1) end)
    |> Enum.map(&List.to_tuple/1)
  end

  def solve_part1(input) do
    {left, right} = Enum.unzip(input)
    Enum.zip(Enum.sort(left), Enum.sort(right))
    |> Enum.map(fn {x1, x2} -> abs(x1 - x2) end)
    |> Enum.sum()
  end

  def solve_part2(input) do
    {left, right} = Enum.unzip(input)
    right = Enum.frequencies(right)

    left
    |> Enum.map(fn x -> x * Map.get(right, x, 0) end)
    |> Enum.sum()
  end

  def part1(args) do
    args
    |> parse_input
    |> solve_part1
  end

  def part2(args) do
    args
    |> parse_input
    |> solve_part2
  end
end
