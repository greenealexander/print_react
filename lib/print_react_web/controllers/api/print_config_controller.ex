defmodule PrintReactWeb.Api.PrintConfigController do
  use PrintReactWeb, :controller
  alias IPP.{Request, Printer}
  alias HTTPoison

  def printers(conn, _params) do
    case HTTPoison.get("http://localhost:631/printers") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        printers = get_attrs_for_printers(body)
        render(conn, "printers.json", %{printers: printers})

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Not found :(")
        render(conn, "printers.json", %{printers: []})

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.puts(reason)
        render(conn, "printers.json", %{printers: []})
    end
  end

  defp get_attrs_for_printers(body) do
    Regex.scan(~r/<TR><TD><A HREF="\/printers\/(.*)"/, body)
    |> Enum.map(fn [_, printer_name] ->
      Task.async(fn ->
        Request.execute(
          :get_printer_attributes,
          %Printer{
            url: "http://localhost:631/printers/#{printer_name}",
            uri: "ipp://localhost:631/printers/#{printer_name}"
          }
        )
      end)
    end)
    |> Task.yield_many()
    |> Enum.map(fn {t, res} ->
      if is_nil(res) do
        Task.shutdown(t, :brutal_kill)
      else
        {_, printer_info} = res
        printer_info
      end
    end)
    |> Enum.filter(fn res -> !is_nil(res) end)
  end
end
