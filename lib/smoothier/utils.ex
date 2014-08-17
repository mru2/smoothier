defmodule Smoothier.Utils do

  def count(l1, l2), do: count(l1 |> Enum.sort, l2 |> Enum.sort, 0)

  # Stop when one is empty
  defp count([], _l, i), do: i
  defp count(_l, [], i), do: i

  # When equal, increment
  defp count([a|t1], [a|t2], i), do: count(t1, t2, i+1)

  # Otherwise, drop the smallest and continue
  defp count(l1, l2, i) do
    if hd(l1) < hd(l2), do: count(tl(l1), l2, i), else: count(l1, tl(l2), i)
  end

end
