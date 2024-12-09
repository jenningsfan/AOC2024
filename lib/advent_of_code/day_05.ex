defmodule AdventOfCode.Day05 do
  def parse_input(input) do
    [rules, updates] = String.split(input, "\n\n", trim: true)

    rules = rules
    |> String.split("\n", trim: true)
    |> Enum.map(fn l -> List.to_tuple(Enum.map(String.split(l, "|"), &String.to_integer/1)) end)
    |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, elem(x, 0), [elem(x, 1)], (fn e -> [elem(x, 1) | e] end)) end)

    updates = updates
    |> String.split("\n", trim: true)
    |> Enum.map(fn l -> Enum.map(String.split(l, ","), &String.to_integer/1) end)

    {rules, updates}
  end

  def is_valid(update, rules) do
    Enum.all?(for i <- 0..length(update) - 2 do
      elem = Enum.at(update, i)
      rule = Map.get(rules, elem, [])
      Enum.all?(for j <- (i+1)..length(update) - 1 do
        Enum.member?(rule, Enum.at(update, j))
      end)
    end)
  end

  def sort(update, rules) do
    Enum.sort(update, fn a, b ->
      Enum.member?(Map.get(rules, a, []), b) # true if a before b
    end)
  end

  def solve_part1({rules, updates}) do
    updates
    |> Enum.map(fn x -> if is_valid(x, rules), do: Enum.at(x, div(length(x) - 1, 2)), else: 0 end)
    |> Enum.sum
  end

  def solve_part2({rules, updates}) do
    updates
    |> Enum.map(fn x -> if !is_valid(x, rules), do: Enum.at(sort(x, rules), div(length(x) - 1, 2)), else: 0 end)
    |> Enum.sum
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
