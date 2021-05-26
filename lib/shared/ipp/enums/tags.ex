defmodule IPP.Enums.Tags do
  alias IPP.Xref

  @tags Xref.create(
          [
            nil,
            "operation-attributes-tag",
            "job-attributes-tag",
            "end-of-attributes-tag",
            "printer-attributes-tag",
            "unsupported-attributes-tag",
            "subscription-attributes-tag",
            "event-notification-attributes-tag",
            "resource-attributes-tag",
            "document-attributes-tag"
          ] ++
            Enum.map(0x0A..0x0F, fn _ -> nil end) ++
            [
              "unsupported",
              "default",
              "unknown",
              "no-value",
              nil,
              "not-settable",
              "delete-attribute",
              "admin-define"
            ] ++
            Enum.map(0x18..0x20, fn _ -> nil end) ++
            [
              "integer",
              "boolean",
              "enum"
            ] ++
            Enum.map(0x24..0x2F, fn _ -> nil end) ++
            [
              "octetString",
              "dateTime",
              "resolution",
              "rangeOfInteger",
              "begCollection",
              "textWithLanguage",
              "nameWithLanguage",
              "endCollection"
            ] ++
            Enum.map(0x38..0x40, fn _ -> nil end) ++
            [
              "textWithoutLanguage",
              "nameWithoutLanguage",
              nil,
              "keyword",
              "uri",
              "uriScheme",
              "charset",
              "naturalLanguage",
              "mimeMediaType",
              "memberAttrName"
            ] ++
            Enum.map(0x4B..0x7E, fn _ -> nil end) ++
            [
              "extension"
            ]
        )

  def get(key), do: @tags[key]
  def lookup(idx), do: Enum.at(@tags.lookup, idx)
end
