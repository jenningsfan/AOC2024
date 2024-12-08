defmodule AdventOfCode.Day03 do
  def parse_input(input) do
    Regex.scan(~r/(don't\(\))|(do\(\))|((mul)\((\d+),(\d+)\))/, input)
  end

  def solve_part1(input) do
    Enum.sum(for op <- input do
      if Enum.at(op, -3) == "mul" do # cases returned with extraneos stuff at front so look from back yk
        String.to_integer(Enum.at(op, -2)) * String.to_integer(Enum.at(op, -1))
      else 0
      end
    end)
  end

  def part1(args) do
    args
    |> parse_input
    |> solve_part1
  end

  def solve_part2(input, state_enabled, total) do
    op = List.first(Enum.take(input, 1))
    input = Enum.drop(input, 1)
      if op == nil do
        total
      else
        op_type = Enum.at(op, 0) # cases returned with extraneos stuff at front so look from back yk

        if String.slice(op_type, 0..2) == "mul" && state_enabled do
            solve_part2(input, state_enabled, total + String.to_integer(Enum.at(op, -2)) * String.to_integer(Enum.at(op, -1)))
        else
          if op_type == "do()" do
              solve_part2(input, true, total)
          else
            if op_type == "don't()" do
                solve_part2(input, false, total)
            else
                solve_part2(input, state_enabled, total)
            end
          end
        end
      end

  end

  def part2(args) do
    args
    |> parse_input
    |> solve_part2(true, 0)
  end
end
