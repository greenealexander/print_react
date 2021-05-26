defmodule PUP.PrinterConfigAgent do
  use Agent
  alias PUP.Models.ConfigModel

  def start_link(_opts) do
    Agent.start_link(fn -> %{lookup: []} end, name: __MODULE__)
  end

  def get, do: Agent.get(__MODULE__, fn configs -> configs end)

  def add(%ConfigModel{name: name} = config) do
    Agent.update(__MODULE__, fn configs ->
      Map.put(configs, name, config)
      |> Map.update!(:lookup, fn lookup -> [name | lookup] end)
    end)
  end

  def delete(name) when is_bitstring(name) do
    Agent.update(__MODULE__, fn configs ->
      Map.delete(configs, name)
      |> Map.update!(:lookup, fn lookup ->
        List.delete(lookup, name)
      end)
    end)
  end
end
