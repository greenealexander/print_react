defmodule PrintReact.ShadowPrinter do
  use GenServer

  alias Phoenix.PubSub
  alias PrintReact.JobRowManager
  alias PUP.Models.DocumentMeta

  def start_link(parent, printer_name, start_code) do
    args = {parent, printer_name, start_code}
    GenServer.start_link(__MODULE__, args, name: String.to_atom(printer_name))
  end

  def init({parent, _, _} = args) do
    Process.send_after(parent, {:idle, self()}, 500)
    {:ok, args}
  end

  def print(shadow_printer, %DocumentMeta{} = doc) do
    GenServer.cast(shadow_printer, {:print, doc})
  end

  def handle_cast({:print, %DocumentMeta{} = doc}, {parent, _, start_code} = state) do
    IO.puts("printing #{doc.code} at #{doc.doc_path}")

    Enum.each(1..doc.page_count, fn page_num ->
      Process.sleep(500)

      IO.puts("printing: #{page_num}")

      PubSub.broadcast(
        PrintReact.PubSub,
        "page_printed",
        {:page_printed, start_code}
      )
    end)

    JobRowManager.notify(parent, {:idle, self()})
    {:noreply, state}
  end
end
