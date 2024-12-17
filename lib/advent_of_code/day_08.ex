defmodule AdventOfCode.Day08 do
  def parse_input(input) do
    map = input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)

    row_count = length(map)
    col_count = length(List.first(map))

    map = map
    |> List.flatten
    |> Enum.with_index
    |> Enum.reduce(Map.new(), fn {char, index}, acc ->
      if char != "." do
        coords = {rem(index, col_count), div(index, row_count)}
        Map.update(acc, char, [coords], (fn e -> [coords | e] end))
      else
        acc
      end
    end)
    # remove node name bc we don't need that after collecting them into groups
    # and sort for antinode calculation
    |> Enum.map(fn {_, nodes} ->
      Enum.sort_by(nodes, fn {_, y} -> y end)
    end)

    {map, col_count, row_count}
  end

  def find_antinodes_part1({trans1_x, trans1_y}, {trans2_x, trans2_y}, col_count, row_count) do
    if trans1_y > trans2_y do
      raise "Trans2 Y MUST be greater than Trans1"
    end

    change_x = trans2_x - trans1_x
    change_y = trans2_y - trans1_y

    antinode_1 = {trans1_x - change_x, trans1_y - change_y}
    antinode_2 = {trans2_x + change_x, trans2_y + change_y}

    MapSet.new(Enum.filter([antinode_1, antinode_2], fn {x, y} -> x < col_count and y < row_count and x >= 0 and y >= 0 end))
  end

  def find_antinodes_part2({trans1_x, trans1_y}, {trans2_x, trans2_y}, col_count, row_count) do
    if trans1_y > trans2_y do
      raise "Trans2 Y MUST be greater than Trans1"
    end

    change_x = trans2_x - trans1_x
    change_y = trans2_y - trans1_y

    total = MapSet.new([{trans1_x, trans1_y}, {trans2_x, trans2_y}])
    total = find_antinodes_part2_recurse({trans1_x, trans1_y}, {-change_x, -change_y}, total, col_count, row_count)
    total = find_antinodes_part2_recurse({trans2_x, trans2_y}, {change_x, change_y}, total, col_count, row_count)

    total
  end

  def find_antinodes_part2_recurse({node_x, node_y}, {change_x, change_y}, acc, col_count, row_count) do
    {antinode_x, antinode_y} = {node_x + change_x, node_y + change_y}

    # check bounds
    if antinode_x < col_count and antinode_y < row_count and antinode_x >= 0 and antinode_y >= 0 do
      find_antinodes_part2_recurse({antinode_x, antinode_y}, {change_x, change_y}, MapSet.put(acc, {antinode_x, antinode_y}), col_count, row_count)
    else
      acc
    end
  end

  def find_antinodes(antennas, antinode_set, antinode_func, col_count, row_count) do
    Utils.reduce_with_rest(antennas, antinode_set, fn curr, rest, acc ->
      Enum.reduce(rest, acc, fn node, acc_inner ->
        MapSet.union(acc_inner, antinode_func.(curr, node, col_count, row_count))
      end)
    end)
  end

  def solve_part1({map, col_count, row_count}) do
    map
    |> Enum.reduce(MapSet.new([]), fn curr, acc -> find_antinodes(curr, acc, &find_antinodes_part1/4, col_count, row_count) end)
    |> Enum.count
  end

  def part1(args) do
    args
    |> parse_input
    |> solve_part1()
  end

  def solve_part2({map, col_count, row_count}) do
    map
    |> Enum.reduce(MapSet.new([]), fn curr, acc -> find_antinodes(curr, acc, &find_antinodes_part2/4, col_count, row_count) end)
    |> Enum.count
  end

  def part2(args) do
    args
    |> parse_input
    |> solve_part2()
  end
end
