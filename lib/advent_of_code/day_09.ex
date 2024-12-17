defmodule AdventOfCode.Day09 do
  def parse_input(input) do
    input
    |> String.trim
    |> String.graphemes
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2, 2, [0])
    |> Enum.with_index
  end

  def step_over_blocks(blocks, pos, result) do
    block = Enum.at(blocks, pos)
    pos = pos + 1

    if pos - 1 == length(blocks) do
      result
    else
      if block == -1 do
        {block, blocks} =  List.pop_at(blocks, length(blocks) - 1)

        if block == -1 do
          step_over_blocks(blocks, pos - 1, result)
        else
          result = result + block * (pos - 1)
          step_over_blocks(blocks, pos, result)
        end
      else
        result = result + block * (pos - 1)
        step_over_blocks(blocks, pos, result)
      end
    end
  end

  def solve_part1(input) do
    input
    |> Enum.map(fn {pair, index} ->
      file_times = Enum.at(pair, 0)
      space_times = Enum.at(pair, 1)

      [List.duplicate(index, file_times) | List.duplicate(-1, space_times)]
    end)
    |> List.flatten
    |> step_over_blocks(0, 0)
  end

  def part1(args) do
    args
    |> parse_input
    |> solve_part1
  end

  def print_blocks(blocks) do
    for {[file, free], index} <- blocks do
      IO.write(String.duplicate(Integer.to_string(index), file))
      IO.write(String.duplicate(".", free))
    end
    IO.puts("")

    blocks
  end

  def calulate_result(blocks) do
    Enum.reduce(blocks, {0, 0}, fn {[file, free], block_id}, {curr_index, result} ->
      if file != 0 do
        these_blocks = 0..file - 1
        |> Enum.map(fn index ->
          (curr_index + index) * block_id
        end)
        |> Enum.sum
        {curr_index + file + free, result + these_blocks}
      else
        {curr_index + file + free, result}
      end
    end)
    |> elem(1)
  end

  def whole_block_move(blocks, pos_from, tried) do
    if rem(tried, 100) == 0 do
      IO.inspect((tried / 10000) * 100)
    end

    #print_blocks(blocks)

    if tried >= length(blocks) - 1 or pos_from <= 0 do
      blocks
    else
      {block, index} = Enum.at(blocks, pos_from)

      # IO.inspect(index, label: "index: ")
      # IO.inspect(pos_from, label: "pos_from: ")


      {updated_blocks, pos_from} = Enum.reduce_while(0..(pos_from - 1), {blocks, 0}, fn pos_to, {acc_blocks, _} ->
        {space, replace_index} = Enum.at(blocks, pos_to)
        file_size = Enum.at(block, 0)
        file_space_size = Enum.at(block, 1)
        space_size = Enum.at(space, 1)

        if space_size >= file_size do
          updated_blocks =
            acc_blocks
            |> List.replace_at(pos_to, {[Enum.at(space, 0), 0], replace_index})
            |> List.insert_at(pos_to + 1, {[file_size, space_size - file_size], index})
            |> List.replace_at(pos_from + 1, {[0, file_size + file_space_size], index})

          pos_from = if pos_to < pos_from - 1 do
            pos_from
          else
            pos_from - 1
          end
          {:halt, {updated_blocks, pos_from}}
        else
          {:cont, {acc_blocks, pos_from - 1}}
        end
      end)
      whole_block_move(updated_blocks, pos_from, tried + 1)
    end
  end

  def solve_part2(input) do
    input
    |> whole_block_move(length(input) - 1, 0)
    |> calulate_result
  end

  def part2(args) do
    args
    |> parse_input
    |> solve_part2
  end
end
