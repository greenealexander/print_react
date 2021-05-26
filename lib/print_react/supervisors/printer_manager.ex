defmodule PrintReact.Supervisors.PrinterManager do
  use DynamicSupervisor

  alias PrintReact.ShadowPrinter

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_child(parent, printer_name, start_code) do
    child_spec = %{
      id: ShadowPrinter,
      start: {ShadowPrinter, :start_link, [parent, printer_name, start_code]},
      restart: :temporary,
      shutdown: :brutal_kill,
      type: :worker,
      modules: [ShadowPrinter]
    }

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def init([]) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
