defmodule IPP.Request do
  alias IPP.{Serializer, Parser, Printer}
  alias HTTPoison

  @doc """
  Execute IPP request to specified printer
  """
  def execute(op = :get_printer_attributes, %Printer{uri: uri, url: url}) do
    data = Serializer.serialize(op, uri)

    send_request(url, data)
  end

  def execute(op = :print_job, %Printer{uri: uri, url: url}, file_path) do
    data = Serializer.serialize(op, uri, file_path)

    send_request(url, data)
  end

  defp send_request(url, data) do
    headers = ["Content-Type": "application/ipp"]
    options = []

    case HTTPoison.post(url, data, headers, options) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> Parser.parse(body)
      {:ok, %HTTPoison.Response{status_code: 404}} -> IO.puts("Not found :(")
      {:error, %HTTPoison.Error{reason: reason}} -> IO.puts(reason)
    end
  end
end
