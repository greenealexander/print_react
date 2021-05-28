defmodule IPP.Printer do
  alias IPP.Printer

  @enforce_keys [:name, :uri, :url]
  defstruct name: "", uri: "", url: ""

  def new(name) do
    %Printer{
      name: name,
      uri: "ipp://localhost:631/printers/#{name}",
      url: "http://localhost:631/printers/#{name}"
    }
  end
end
