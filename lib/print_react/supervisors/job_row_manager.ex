defmodule PrintReact.JobRowManager do
  use GenServer

  alias Phoenix.PubSub
  alias PUP.Models.JobRowModel
  alias PrintReact.Supervisors.PrinterManager
  alias PrintReact.ShadowPrinter

  def start_link(%JobRowModel{start_code: start_code, end_code: end_code} = job_row) do
    pid = create_process_name(start_code, end_code)
    args = %{start_code: start_code, pid: pid}

    GenServer.start_link(__MODULE__, {args, job_row}, name: pid)
  end

  @impl true
  def init({args, %JobRowModel{} = job_row}) do
    Process.send_after(self(), {:start, job_row}, 500)
    {:ok, args}
  end

  def start(server, %JobRowModel{} = job_row) do
    GenServer.cast(server, {:start, job_row})
  end

  def notify(server, info) do
    GenServer.cast(server, info)
  end

  @impl true
  def handle_cast({:idle, shadow_printer}, state) do
    handle_idle(shadow_printer, state)
  end

  @impl true
  def handle_info({:idle, shadow_printer}, state) do
    handle_idle(shadow_printer, state)
  end

  @impl true
  def handle_info({:start, %JobRowModel{} = job_row}, %{start_code: start_code, pid: parent}) do
    printer_pids =
      job_row.printer_config.printers
      |> Enum.reduce([], fn printer_name, acc ->
        {:ok, pid} = PrinterManager.start_child(parent, printer_name, start_code)
        [pid | acc]
      end)

    state = %{
      start_code: start_code,
      documents: job_row.documents,
      pids: printer_pids,
      idle: :queue.new()
    }

    {:noreply, state}
  end

  defp handle_idle(shadow_printer, state) do
    %{documents: documents, pids: pids, idle: idle, start_code: start_code} = state
    no_docs_left = length(documents) == 0
    updated_queue = :queue.in(shadow_printer, idle)

    if no_docs_left and length(pids) == :queue.len(updated_queue) do
      PubSub.broadcast!(
        PrintReact.PubSub,
        "print_job_row_completed",
        {:printing_completed, start_code}
      )

      # finished printing all docs so kill all shadow printers and self
      Enum.each(pids, fn pid -> Process.exit(pid, :kill) end)
      Process.exit(self(), :kill)
    else
      if no_docs_left do
        updated_state = Map.update(state, :idle, :idle, fn _ -> updated_queue end)

        {:noreply, updated_state}
      else
        [doc | remaining_documents] = documents
        {{:value, next_printer}, new_queue} = :queue.out(updated_queue)

        ShadowPrinter.print(next_printer, doc)

        updated_state =
          state
          |> Map.update(:documents, :documents, fn _ -> remaining_documents end)
          |> Map.update(:idle, :idle, fn _ -> new_queue end)

        {:noreply, updated_state}
      end
    end
  end

  defp create_process_name(start_code, end_code) do
    pid =
      if end_code == "",
        do: start_code,
        else: "#{start_code}-#{end_code}"

    String.to_atom(pid)
  end
end
