defmodule AdventOfCode.Day07 do
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line = String.split(line, ": ")
      {String.to_integer(Enum.at(line, 0)), Enum.map(String.split(Enum.at(line, 1), " "), &String.to_integer/1)}
    end)
  end

  def solveable_part1(result, nums, acc) do
    if length(nums) == 0 do
      acc == result
    else
      {popped, nums} = List.pop_at(nums, 0)
      solveable_part1(result, nums, acc + popped) or solveable_part1(result, nums,acc * popped)
    end
  end

  def solve_part1(input) do
    input
    |> Enum.filter(fn {result, nums} -> solveable_part1(result, nums, 0) end)
    |> Enum.map(fn {result, _} -> result end)
    |> Enum.sum
  end

  def part1(args) do
    args
    |> parse_input
    |> solve_part1
  end

  def concat(num1, num2) do
    String.to_integer(Integer.to_string(num1) <> Integer.to_string(num2))
  end

  def solveable_part2(result, nums, acc) do
    if length(nums) == 0 do
      acc == result
    else
      {popped, nums} = List.pop_at(nums, 0)
      solveable_part2(result, nums, acc + popped) or solveable_part2(result, nums, acc * popped) or
        solveable_part2(result, nums, concat(acc, popped))
    end
  end

  def solve_part2(input) do
    input
    |> Enum.filter(fn {result, nums} -> solveable_part2(result, nums, 0) end)
    |> Enum.map(fn {result, _} -> result end)
    |> Enum.sum
  end

  def part2(args) do
    args
    |> parse_input
    |> solve_part2
  end
end
