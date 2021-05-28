defmodule IPP.Parser do
  alias IPP.Enums.{Tags, Versions}
  alias IPP.Parser.Utils

  def parse(binary) do
    <<version::16, status::16, request_id::32, binary::binary>> = binary

    base = %{
      version: Versions.get(version),
      status: status,
      request_id: request_id
    }

    parse_groups(binary)
    |> Map.merge(base)
  end

  defp parse_groups(binary, attr_groups \\ %{}) do
    <<tag, binary::binary>> = binary
    attribute_group_tag = Tags.lookup(tag)

    if attribute_group_tag == "end-attributes-tag" do
      attr_groups
    else
      {attrs, binary} = parse_attr(binary)

      if byte_size(binary) == 0 do
        attr_groups
      else
        parse_groups(binary, Map.put(attr_groups, attribute_group_tag, attrs))
      end
    end
  end

  defp parse_attr(binary, attrs \\ %{}) do
    if byte_size(binary) == 0 do
      {attrs, binary}
    else
      <<tag, rest::binary>> = binary

      if tag < 0x0F do
        {attrs, binary}
      else
        {tag, rest} =
          if tag == 0x7F do
            <<extension_tag::32, rest::binary>> = rest
            {extension_tag, rest}
          else
            {tag, rest}
          end

        {name, rest} = Utils.parse_name(rest)

        {value, rest} =
          if tag == 0x23,
            do: parse_values(tag, rest, name),
            else: parse_values(tag, rest, name)

        parse_attr(rest, Map.put(attrs, name, value))
      end
    end
  end

  defp parse_values(tag, binary, group, initial_value \\ nil) do
    {value, binary} = Utils.parse_value(tag, group, binary)

    if !Utils.has_additional_value(binary) do
      if is_nil(initial_value) do
        {value, binary}
      else
        if is_list(initial_value),
          do: {[value | initial_value], binary},
          else: {[value, initial_value], binary}
      end
    else
      <<next_tag, _::16, binary::binary>> = binary

      if is_nil(initial_value) do
        parse_values(next_tag, binary, group, value)
      else
        if is_list(initial_value),
          do: parse_values(next_tag, binary, group, [value | initial_value]),
          else: parse_values(next_tag, binary, group, [value, initial_value])
      end
    end
  end
end
