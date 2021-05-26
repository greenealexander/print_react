defmodule IPP.Xref do
  def create(items \\ []) do
    items
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {item, idx}, acc -> Map.put(acc, item, idx) end)
    |> Map.put(:lookup, items)
  end
end
