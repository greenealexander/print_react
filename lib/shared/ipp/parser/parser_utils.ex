defmodule IPP.Parser.Utils do
  alias IPP.Enums
  alias Enums.Tags

  def parse_value(tag_id, group, binary) do
    <<value_length::16, binary::binary>> = binary
    tag = Tags.lookup(tag_id)

    case tag do
      keyword
      when keyword in [
             "nameWithoutLanguage",
             "textWithoutLanguage",
             "octetString",
             "memberAttrName",
             "keyword",
             "uri",
             "uriScheme",
             "charset",
             "naturalLanguage",
             "mimeMediaType"
           ] ->
        parse_string(binary, value_length)

      "enum" ->
        parse_enum(binary, group)

      "integer" ->
        parse_integer(binary)

      "boolean" ->
        parse_boolean(binary)

      "rangeOfInteger" ->
        parse_range_of_integer(binary)

      "resolution" ->
        parse_resolution(binary)

      "textWithLanguage" ->
        parse_with_language(binary)

      "nameWithLanguage" ->
        parse_with_language(binary)

      "dateTime" ->
        parse_datetime(binary)

      "begCollection" ->
        {_collection_name, binary} = parse_string(binary, value_length)
        parse_collection(binary)

      _ ->
        parse_unknown(binary, value_length)
    end
  end

  def parse_name(binary) do
    <<name_length::16, binary::binary>> = binary
    parse_string(binary, name_length)
  end

  def parse_string(binary, length) do
    base = {"", binary}

    if length == 0,
      do: base,
      else:
        Enum.reduce(1..length, base, fn _, {parsed_string, binary} ->
          <<letter, binary::binary>> = binary
          updated_parsed_string = parsed_string <> <<letter>>
          {updated_parsed_string, binary}
        end)
  end

  def has_additional_value(binary) do
    <<next_tag, _::binary>> = binary

    if next_tag == 0x03 do
      false
    else
      <<_, name::16, _::binary>> = binary

      next_tag !== 0x4A and next_tag !== 0x37 and next_tag !== 0x03 and name == 0x0000
    end
  end

  defp parse_enum(binary, group) do
    <<key::32, binary::binary>> = binary
    enum = Enums.get_enum(key, group)
    {enum, binary}
  end

  defp parse_integer(binary) do
    <<value::32, binary::binary>> = binary
    {value, binary}
  end

  defp parse_boolean(binary) do
    <<value, binary::binary>> = binary
    bool_value = value > 0
    {bool_value, binary}
  end

  defp parse_range_of_integer(binary) do
    <<min::32, max::32, binary::binary>> = binary
    {[min, max], binary}
  end

  defp parse_resolution(binary) do
    <<w::32, h::32, tag, binary::binary>> = binary

    label = if tag == 0x03, do: "dpi", else: "dpcm"

    {[w, h, label], binary}
  end

  defp parse_datetime(binary) do
    <<_::16, _, _, _, _, _, _, _, _, _, binary::binary>> = binary
    {"datetime", binary}
  end

  # case tags.dateTime:
  # 	// http://tools.ietf.org/html/rfc1903 page 17
  # 	var date = new Date(read2(), read1(), read1(), read1(), read1(), read1(), read1());
  # 	//silly way to add on the timezone
  # 	return new Date(date.toISOString().substr(0,23).replace('T',',') +','+ String.fromCharCode(read(1)) + read(1) + ':' + read(1));

  defp parse_with_language(binary) do
    {lang, binary} = parse_name(binary)
    {subval, binary} = parse_name(binary)
    value = lang <> "\u001e" <> subval
    {value, binary}
  end

  defp parse_unknown(binary, length) do
    if length == 0,
      do: {"unknown", binary},
      else: parse_string(binary, length)
  end

  defp parse_collection(binary, collection \\ %{}) do
    <<tag, _::16, rest::binary>> = binary

    if tag !== 0x4A or tag == 0x37 do
      {collection, binary}
    else
      {member_name, rest} = parse_value(tag, nil, rest)
      <<member_tag, _::16, rest::binary>> = rest
      value = parse_value(member_tag, nil, rest)
      updated_collection = Map.put(collection, member_name, value)
      {updated_collection, binary}
    end
  end
end
