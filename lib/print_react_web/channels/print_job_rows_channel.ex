defmodule PrintReactWeb.Channels.PrintJobRowsChannel do
  use PrintReactWeb, :channel
  use PrintReactWeb, :view

  alias Phoenix.PubSub
  alias PrintReact.Supervisors.JobRowsManager
  alias PrintReactWeb.Api.PrintJobRowsView

  def join("print_job_rows_channel", _params, socket) do
    PubSub.subscribe(PrintReact.PubSub, "page_printed")
    PubSub.subscribe(PrintReact.PubSub, "print_job_row_completed")

    print_job_rows = JobRowsManager.get_rows() |> Map.values()

    job_rows_json =
      PrintJobRowsView.render("print_job_rows.json", %{print_job_rows: print_job_rows})

    response = %{job_rows: job_rows_json}

    {:ok, response, socket}
  end

  def handle_in("print_job_rows_new", params, socket) do
    new_row_opts =
      if Map.has_key?(params, "endCode") do
        %{
          documents: params["documents"],
          start_code: params["startCode"],
          end_code: params["endCode"]
        }
      else
        %{documents: params["documents"], start_code: params["startCode"]}
      end

    case JobRowsManager.add_row(new_row_opts) do
      {:ok, {new_row, index}} ->
        new_row_json = PrintJobRowsView.render("print_job_row.json", %{print_job_row: new_row})
        broadcast!(socket, "print_job_rows_added", %{index: index, jobRow: new_row_json})
        {:reply, :ok, socket}

      {:error, reason} ->
        {:reply, {:error, %{reason: reason}}, socket}
    end
  end

  def handle_in("print_job_rows_start", params, socket) do
    start_code = params["startCode"]

    case JobRowsManager.start(start_code) do
      {:ok, desc} ->
        broadcast!(socket, "print_job_rows_started", %{startCode: start_code})
        {:reply, {:ok, %{desc: desc}}, socket}

      {:error, reason} ->
        {:reply, {:error, %{reason: reason}}, socket}
    end
  end

  def handle_info({:page_printed, start_code}, socket) do
    push(socket, "print_job_rows_page_printed", %{
      startCode: start_code
    })

    {:noreply, socket}
  end

  def handle_info({:printing_completed, start_code}, socket) do
    push(socket, "print_job_row_completed", %{
      startCode: start_code
    })

    {:noreply, socket}
  end

  def terminate(_reason, socket) do
    PubSub.unsubscribe(PrintReact.PubSub, "page_printed")
    PubSub.unsubscribe(PrintReact.PubSub, "print_job_row_completed")

    {:ok, socket}
  end
end
