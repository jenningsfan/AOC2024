defmodule AdventOfCode.Day04 do
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end

  def count_row(row) do
    row
    |> Enum.chunk_every(4, 1)
    |> Enum.map(fn x -> x == ["X", "M", "A", "S"] || x == ["S", "A", "M", "X"] end)
    |> Enum.count(fn x -> x end)
  end

  def count_col(grid) do
    row_len = Enum.count(grid)
    Enum.sum(
      for col <- (0..row_len - 1) do
        grid
        |> Enum.zip
        |> Enum.map(&Tuple.to_list/1)
        |> Enum.map(fn x -> Enum.slice(x, (col..col+3)) end)
        |> Enum.count(fn x -> x == ["X", "M", "A", "S"] || x == ["S", "A", "M", "X"] end)
      end
    )
  end

  def count_diag(grid) do
    row_count = Enum.count(grid)
    col_count = Enum.count(List.first(grid))
    grid = List.flatten(grid)

    Enum.sum(for row <- 0..row_count - 1 do
      Enum.sum(for col <- 0..col_count - 1 do
        count_diag(grid, row, col, col_count, row_count)
      end)
    end)
  end

  def count_diag(grid, row, col, row_len, col_len) do
    Enum.count([appears_left_diag(grid, row, col, row_len, col_len), appears_right_diag(grid, row, col, row_len, col_len)], fn x -> x end)
  end

  def appears_left_diag(grid, row, col, row_len, col_len) do
    if (col < 3) || (row > (col_len - 4)) do
      false
    else
      diag = for i <- 0..3 do
        Enum.at(grid, (row + i) * row_len + col - i)
      end
      diag == ["X", "M", "A", "S"] || diag == ["S", "A", "M", "X"]
    end
  end

  def appears_right_diag(grid, row, col, row_len, col_len) do
    if (col > row_len - 4) || (row > (col_len - 4)) do
      false
    else
      diag = for i <- 0..3 do
        Enum.at(grid, (row + i) * row_len + col + i)
      end
      diag == ["X", "M", "A", "S"] || diag == ["S", "A", "M", "X"]
    end
  end

  def mas_appears(grid, row, col, row_len, row_count) do
    if (col == 0) || (col == row_len - 1) || (row == 0) || (row == row_count - 1) do
      false
    else
      if Enum.at(grid, row * row_len + col) == "A" do
        diag_left = [Enum.at(grid, (row - 1) * row_len + col - 1), Enum.at(grid, (row + 1) * row_len + col + 1)]
        diag_right = [Enum.at(grid, (row + 1) * row_len + col - 1), Enum.at(grid, (row - 1) * row_len + col+ 1)]
        (diag_left == ["M", "S"] || diag_left == ["S", "M"]) && (diag_right == ["M", "S"] || diag_right == ["S", "M"])
      else
        false
      end
    end
  end

  def count_mas(grid) do
    row_count = Enum.count(grid)
    col_count = Enum.count(List.first(grid))
    grid = List.flatten(grid)

    Enum.sum(for row <- 0..row_count - 1 do
      Enum.count(for col <- 0..col_count - 1 do
        mas_appears(grid, row, col, col_count, row_count)
      end, fn x -> x end)
    end)
  end

  def solve_part1(input) do
    row_count = input
      |> Enum.map(&count_row/1)
      |> Enum.sum
    col_count = count_col(input)
    diag_count = count_diag(input)

    IO.inspect(row_count) + IO.inspect(col_count) + IO.inspect(diag_count)
  end

  def solve_part2(input) do
    count_mas(input)
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
