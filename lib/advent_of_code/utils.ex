defmodule Utils do

  def reduce_with_rest([], acc, _fun), do: acc

  def reduce_with_rest([current | rest], acc, fun) do
    # Call the provided function with the current element and the rest
    new_acc = fun.(current, rest, acc)
    # Continue processing the rest of the list
    reduce_with_rest(rest, new_acc, fun)
  end
end
