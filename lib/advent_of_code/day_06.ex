defmodule AdventOfCode.Day06 do
  def parse_input(input) do
    map = input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)

    row_count = length(map)
    col_count = length(List.first(map))

    map = List.flatten(map)
    start_pos = Enum.find_index(map, fn x -> x == "^" end)
    start_pos = {rem(start_pos, col_count), div(start_pos, row_count)}
    map = Enum.map(map, fn x -> x == "#" end) # return is just 1d array of whole map with true as obstacles and false as clear

    {map, start_pos, row_count, col_count}
  end


  def print_map(map, _, col_count) do
    map
    |> Enum.chunk_every(col_count)
    |> Enum.map(fn line -> Enum.join(Enum.map(line, fn c -> if c, do: "#", else: "." end), "") end)
    |> Enum.join("\n")
    |> IO.puts
  end

  def in_bounds({x, y}, row_count, col_count) do
      x < row_count && y < col_count && x > -1 && y > -1
  end

  def create_obstacle_cache_lists(map, row_count, col_count) do
    row_list = map
    |> Enum.chunk_every(col_count)
    |> Enum.map(&Enum.member?(&1, true))
    |> Enum.with_index()
    |> Enum.filter(fn {x, _} -> x end)
    |> Enum.map(fn {_, i} -> i end)
    |> MapSet.new

    #IO.puts("HELLO YES I HAVE ACTUALLY BEEN UPDATEEDddd!!!!")

    col_list = 0..col_count
    |> Enum.map(fn x ->
      map
      |> Enum.with_index()
      |> Enum.filter(fn {_elem, index} -> rem(index, row_count) == x end)
      |> Enum.any?(fn {x, _} -> x end)
    end)
    |> Enum.with_index()
    |> Enum.filter(fn {x, _} -> x end)
    |> Enum.map(fn {_, i} -> i end)
    |> MapSet.new

    obstacles = map
    |> Enum.with_index()
    |> Enum.filter(fn {x, _} -> x end)
    |> Enum.map(fn {_, i} -> {rem(i, col_count), div(i, row_count)} end)
    |> MapSet.new

    {row_list, col_list, obstacles}
  end


  def rotate_right(change_x, change_y) do
    case {change_x, change_y} do
      {0, -1} -> {1, 0} # UP -> RIGHT
      {-1, 0} -> {0, -1} # LEFT -> UP
      {1, 0} -> {0, 1} # RIGHT -> DOWN
      {0, 1} -> {-1, 0} # DOWN -> LEFT
    end
  end

  def colour_in({map, coloured_in, {curr_x, curr_y}, {change_x, change_y}, row_count, col_count}) do
    at_pos = fn array, x, y -> Enum.at(array, col_count * y + x) end

    {change_x, change_y} = if at_pos.(map, curr_x + change_x, curr_y + change_y) do # obstacle hit
    # change direction
    rotate_right(change_x, change_y)
  else
    {change_x, change_y}
  end

  new_x = curr_x + change_x
  new_y = curr_y + change_y

    if !in_bounds({new_x, new_y}, row_count, col_count) do
      coloured_in
    else
      coloured_in = List.replace_at(coloured_in, col_count * new_y + new_x, true)

      colour_in({map, coloured_in, {new_x, new_y}, {change_x, change_y}, row_count, col_count})
    end
  end

  def solve_part1({map, start_pos, row_count, col_count}) do
    blank = List.duplicate(false, row_count * col_count)
    coloured_in = colour_in({map, blank, start_pos, {0, -1}, row_count, col_count})

    Enum.count(coloured_in, fn x -> x end)
  end

  def new_traverse(row_list, col_list, obst_list, before_poses, curr_x, curr_y, change_x, change_y, row_count, col_count) do
    obst_maybe_hit = if change_x != 0 do # going across the row
      Enum.member?(row_list, curr_y)
    else
      if change_y != 0 do               # going down or up the cols
        Enum.member?(col_list, curr_x)
      else
        false
      end
    end

    if !obst_maybe_hit do
      #IO.puts("out of bounds")
      false # definetly no loop as exited search
    else
      # check to see if obst is actually gonna be hit
      hit = Enum.filter(obst_list, fn {obst_x, obst_y} ->
        case {change_x, change_y} do
          {0, -1} -> obst_x == curr_x && obst_y < curr_y # UP
          {0, 1} -> obst_x == curr_x && obst_y > curr_y # DOWN
          {-1, 0} -> obst_y == curr_y && obst_x < curr_x # LEFT
          {1, 0} -> obst_y == curr_y && obst_x > curr_x # RIGHT
        end
      end)

      if length(hit) == 0 do
        # no obst i.e. went out of bounds
        #IO.puts("out of bounds")
        false
      else
        # woo hoo found an obst; we have to continue searching

        {obst_x, obst_y} = case {change_x, change_y} do
          {0, -1} -> Enum.max_by(hit, fn {_, y} -> y end) # UP
          {0, 1} -> Enum.min_by(hit, fn {_, y} -> y end) # DOWN
          {-1, 0} -> Enum.max_by(hit, fn {x, _} -> x end) # LEFT
          {1, 0} -> Enum.min_by(hit, fn {x, _} -> x end) # RIGHT
        end

        #IO.inspect({obst_x, obst_y}, label: "Obstacle pos (x, y)")

        curr_x = obst_x + -change_x # like if it was coming from the left we'd be one to the right of it now
        curr_y = obst_y + -change_y # like if it was coming from the left we'd be one to the right of it now

        #IO.inspect({curr_x, curr_y}, label: "New us pos (x, y)")

        obstacle_data = {curr_x, curr_y, change_x, change_y}
        if Enum.member?(before_poses, obstacle_data) do # YES we found a loop
          #IO.puts("LOOP")
          #IO.inspect(before_poses, label: "Obst data")
          true
        else
          # keep on searching // keep on searhing // all you've got to do is search
          before_poses = MapSet.put(before_poses, obstacle_data)
          {change_x, change_y} = rotate_right(change_x, change_y)
          new_traverse(row_list, col_list, obst_list, before_poses, curr_x, curr_y, change_x, change_y, row_count, col_count)
        end
      end

    end
  end

  def obstacle(map, before_poses, {curr_x, curr_y}, {change_x, change_y}, row_count, col_count) do
    at_pos = fn array, x, y -> Enum.at(array, col_count * y + x) end

    {change_x, change_y, before_poses} = if at_pos.(map, curr_x + change_x, curr_y + change_y) do # obstacle hit
      # change direction
      obstacle_data = {curr_x, curr_y, change_x, change_y}
      if Enum.member?(before_poses, obstacle_data) do
        {0, 0, before_poses} # signal loop has been found
      else
        before_poses = [obstacle_data | before_poses]
       case {change_x, change_y} do
          {0, -1} -> {1, 0, before_poses} # UP -> RIGHT
          {-1, 0} -> {0, -1, before_poses} # LEFT -> UP
          {1, 0} -> {0, 1, before_poses} # RIGHT -> DOWN
          {0, 1} -> {-1, 0, before_poses} # DOWN -> LEFT
        end
      end
    else
      {change_x, change_y, before_poses}
    end

    new_x = curr_x + change_x
    new_y = curr_y + change_y

    if {change_x, change_y} == {0, 0} do # loop found
      true
    else
      if !in_bounds({new_x, new_y}, row_count, col_count) do
        false
      else
        obstacle(map, before_poses, {new_x, new_y}, {change_x, change_y}, row_count, col_count)
      end
    end
  end

  def solve_part2({map, {start_x, start_y}, row_count, col_count}) do
    start_pos_i = col_count * start_y + start_x

    blank = List.duplicate(false, row_count * col_count)
    coloured_in = colour_in({map, blank, {start_x, start_y}, {0, -1}, row_count, col_count})
    List.replace_at(coloured_in, start_pos_i, false)

    IO.inspect(length(map), label: "len of map")

    {row_list, col_list, obst_list} = create_obstacle_cache_lists(map, row_count, col_count)

    coloured_in
    |> Enum.with_index
    #|> Enum.filter(fn {x, _} -> x end)
    |> Enum.map(fn {x, i} ->
      if rem(i, 100) == 0 do
        IO.inspect(i, label: "Curr elem number")
      end

      if x do
        new_x = rem(i, col_count)
        new_y = div(i, row_count)

        row_list_mod = MapSet.put(row_list, new_y)
        col_list_mod = MapSet.put(col_list, new_x)
        obst_list_mod = MapSet.put(obst_list, {new_x, new_y})

        #print_map(extra_map, row_count, col_count)
        #prep = create_obstacle_cache_lists(extra_map, row_count, col_count)
        #IO.inspect(prep)
        new_traverse(row_list_mod, col_list_mod, obst_list_mod, MapSet.new(), start_x, start_y, 0, -1, row_count, col_count)
      end
    end)
    |> Enum.count(fn x -> x end)
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
