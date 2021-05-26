defmodule IPP.Serializer do
  alias IPP.Enums
  alias Enums.{Tags, Versions}

  def serialize(:get_printer_attributes, printer_uri) do
    serialize_base("Get-Printer-Attributes", printer_uri)
    |> write(0x03, 8)
  end

  def serialize(:print_job, printer_uri, file_path) do
    {:ok, file_bytes} = File.read(file_path)

    serialize_base("Print-Job", printer_uri)
    |> write(Tags.get("job-attributes-tag"), 8)
    # |> write_attr("charset", "requesting-user-name", "test")
    # |> write_attr("charset", "job-name", "0YK32")
    |> write_attr("charset", "document-format", "application/pdf")
    |> write(0x03, 8)
    |> write(file_bytes)
  end

  defp serialize_base(op, printer_uri) do
    operation = Enums.get_enum(op, :"operations-supported")
    version = Versions.get("2.1")
    request_id = :rand.uniform(100_000)

    <<0>> <> serialized_base =
      <<0>>
      |> write(version, 16)
      |> write(operation, 16)
      |> write(request_id, 32)
      |> write(Tags.get("operation-attributes-tag"), 8)
      |> write_attr("charset", "attributes-charset", "utf-8")
      |> write_attr("naturalLanguage", "attributes-natural-language", "en-us")
      |> write_attr("uri", "printer-uri", printer_uri)

    serialized_base
  end

  defp write_attr(binary, tag, name, value) do
    binary
    |> write(Tags.get(tag), 8)
    |> write(byte_size(name), 16)
    |> write(name)
    |> write(byte_size(value), 16)
    |> write(value)
  end

  defp write(binary, value, length), do: binary <> <<value::size(length)>>
  defp write(binary, value), do: binary <> value
end
