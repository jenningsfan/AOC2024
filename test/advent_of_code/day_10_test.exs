defmodule AdventOfCode.Day10Test do
  use ExUnit.Case

  import AdventOfCode.Day10

  test "part1" do
    input = "...0...
...1...
...2...
6543456
7.....7
8.....8
9.....9"
    result = part1(input)
    assert result == 2

    input = "..90..9
...1.98
...2..7
6543456
765.987
876....
987...."
    result = part1(input)
    assert result == 4

    input = "10..9..
2...8..
3...7..
4567654
...8..3
...9..2
.....01"
    result = part1(input)
    assert result == 3

    input = "89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732"
    result = part1(input)
    assert result == 36
  end

  test "part2" do
    input = "89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732"
    result = part2(input)
    assert result == 81
  end
end
