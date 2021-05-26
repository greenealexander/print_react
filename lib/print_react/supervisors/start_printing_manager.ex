defmodule PrintReact.Supervisors.StartPrintingManager do
  use DynamicSupervisor

  alias PrintReact.JobRowManager
  alias PUP.Models.JobRowModel

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_child(%JobRowModel{} = job_row) do
    child_spec = %{
      id: JobRowManager,
      start: {JobRowManager, :start_link, [job_row]},
      restart: :temporary,
      shutdown: :brutal_kill,
      type: :worker,
      modules: [JobRowManager]
    }

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def init([]) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
