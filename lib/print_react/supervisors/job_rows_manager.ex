defmodule PrintReact.Supervisors.JobRowsManager do
  use GenServer

  alias Phoenix.PubSub
  alias PUP.Models.{JobRowModel}
  alias PrintReact.Supervisors.StartPrintingManager

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(args) do
    PubSub.subscribe(PrintReact.PubSub, "page_printed")
    PubSub.subscribe(PrintReact.PubSub, "print_job_row_completed")
    {:ok, args}
  end

  def get_rows(), do: GenServer.call(__MODULE__, :get_rows)

  def add_row(new_row_opts) do
    GenServer.call(__MODULE__, {:add_row, new_row_opts})
  end

  def start(start_code) do
    GenServer.call(__MODULE__, {:start, start_code})
  end

  def cancel(_start_code) do
  end

  def remove_row() do
  end

  def handle_call({:start, start_code}, _from, rows) do
    job_row = Map.get(rows, start_code, %{})

    case job_row.state do
      "Ready" ->
        StartPrintingManager.start_child(job_row)
        updated_row = Map.update(job_row, :state, :state, fn _ -> "Printing" end)
        updated_rows = Map.update(rows, start_code, start_code, fn _ -> updated_row end)
        {:reply, {:ok, "job row started"}, updated_rows}

      "Printing" ->
        {:reply, {:error, "already started"}, rows}

      _ ->
        {:reply, {:error, "must be in ready state to start"}, rows}
    end
  end

  def handle_call(:get_rows, _from, rows) do
    {:reply, rows, rows}
  end

  def handle_call({:add_row, new_row_opts}, _from, rows) do
    new_row = JobRowModel.from(new_row_opts)

    if Map.has_key?(rows, new_row.start_code) do
      {:reply, {:error, "conflicting row"}, rows}
    else
      updated_rows = Map.put(rows, new_row_opts.start_code, new_row)
      index = Map.keys(updated_rows) |> Enum.find_index(fn key -> key == new_row.start_code end)
      {:reply, {:ok, {new_row, index}}, updated_rows}
    end
  end

  def handle_info({:page_printed, start_code}, rows) do
    job_row = Map.get(rows, start_code, %{})

    updated_row =
      Map.update(job_row, :pages_completed, :pages_completed, fn completed -> completed + 1 end)

    updated_rows = Map.update(rows, start_code, start_code, fn _ -> updated_row end)

    {:noreply, updated_rows}
  end

  def handle_info({:printing_completed, start_code}, rows) do
    job_row = Map.get(rows, start_code, %{})

    updated_row = Map.update(job_row, :state, :state, fn _ -> "Printed" end)

    updated_rows = Map.update(rows, start_code, start_code, fn _ -> updated_row end)

    {:noreply, updated_rows}
  end

  def terminate(_reason, rows) do
    PubSub.unsubscribe(PrintReact.PubSub, "page_printed")
    PubSub.unsubscribe(PrintReact.PubSub, "print_job_row_completed")

    {:ok, rows}
  end
end
