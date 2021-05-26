defmodule PrintReactWeb.Api.PrintConfigView do
  use PrintReactWeb, :view
  alias PrintReactWeb.Api.PrintConfigView

  def render("configs.json", %{configs: configs}) do
    render_many(configs, PrintConfigView, "config.json", as: :config)
  end

  def render("config.json", %{config: config}) do
    %{name: config.name, formType: config.form_type, printers: config.printers}
  end

  def render("add.json", %{status: status}) do
    %{status: status}
  end

  def render("printers.json", %{printers: printers}) do
    render_many(printers, PrintConfigView, "printer.json", as: :printer)
  end

  def render("printer.json", %{printer: printer}) do
    attrs = Map.get(printer, "printer-attributes-tag", %{})

    name = Map.get(attrs, "printer-name", "")
    icon_url = Map.get(attrs, "printer-icons", "")
    state = Map.get(attrs, "printer-state", "")
    marker_names = Map.get(attrs, "marker-names", [])
    marker_colors = Map.get(attrs, "marker-colors", [])
    marker_high_levels = Map.get(attrs, "marker-high-levels", [])
    marker_low_levels = Map.get(attrs, "marker-low-levels", [])
    marker_levels = Map.get(attrs, "marker-levels", [])

    %{
      name: name,
      iconUrl: icon_url,
      state: state,
      markers: %{
        names: marker_names,
        colors: marker_colors,
        highLevels: marker_high_levels,
        lowLevels: marker_low_levels,
        levels: marker_levels
      }
    }
  end
end
