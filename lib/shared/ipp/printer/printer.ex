defmodule IPP.Printer do
  @enforce_keys [:uri, :url]
  defstruct uri: "", url: ""
end
