defmodule AdventOfCode.Day10 do
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      Enum.map(String.graphemes(row), fn x -> if x == ".", do: -1, else: String.to_integer(x) end)
    end)
  end

  def item_at({x, y}, map) do
    if x < 0 or y < 0 or y >= length(map) or x >= length(Enum.at(map, 0)) do
      nil
    else
      Enum.at(Enum.at(map, y), x)
    end
  end

  def find_peaks({x, y}, map, peaks, add_fn) do
    curr_height = item_at({x, y}, map)

    if curr_height == nil do
      peaks
    else
      if curr_height == 9 do
        add_fn.(peaks, {x, y})
      else
        directions = [{0, -1}, {-1, 0}, {1, 0}, {0, 1}]

        Enum.reduce(directions, peaks, fn {change_x, change_y}, peaks ->
          new_pos = {x + change_x, y + change_y}

          if item_at(new_pos, map) == curr_height + 1 do # continue down this path
            find_peaks(new_pos, map, peaks, add_fn)
          else
            peaks
          end
        end)
      end
    end
  end

  def solve_part1(input) do
    input
    |> Enum.with_index
    |> Enum.map(fn {row, y} ->
      row
      |> Enum.with_index
      |> Enum.map(fn {height, x} ->
        if height == 0 do
          Enum.count(find_peaks({x, y}, input, MapSet.new([]), &MapSet.put/2))
        else
          0
        end
      end)
      |> Enum.sum
    end)
    |> Enum.sum
  end

  def solve_part2(input) do
    input
    |> Enum.with_index
    |> Enum.map(fn {row, y} ->
      row
      |> Enum.with_index
      |> Enum.map(fn {height, x} ->
        if height == 0 do
          Enum.count(find_peaks({x, y}, input, [], fn peaks, coord -> [coord | peaks] end))
        else
          0
        end
      end)
      |> Enum.sum
    end)
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
