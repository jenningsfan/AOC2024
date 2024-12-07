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

  # all differnces same sign and between 1 and 3
  def is_report_safe(report) do
    Enum.all?(report, fn x -> abs(x) >= 1 && abs(x) <= 3 end) &&
      (Enum.all?(report, fn x -> x > 0 end) or Enum.all?(report, fn x -> x < 0 end))
  end

  def dampen(report) do
      for i <- 0..length(report) do
        List.delete_at(report, i)
      end
  end

  def solve_part1(input) do
    Enum.map(input, fn x -> x
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [x1, x2] -> x1 - x2 end) end)
    |> Enum.count(fn x -> is_report_safe(x) end)
  end

  def solve_part2(input) do
    Enum.map(input, fn r ->
      for d <- dampen(r) do
        d
        |> Enum.chunk_every(2, 1, :discard) # split into chunks
        |> Enum.map(fn [x1, x2] -> x1 - x2 end) # find the differences between the each value
        |> is_report_safe
      end
      |> Enum.count(fn x -> x end) # count how many times it has succeded with the damping
    end)
    |> Enum.count(fn x -> x != 0 end) # any that succeded at least once
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
