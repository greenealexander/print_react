defmodule PrintReactWeb.Channels.PrintConfigsChannel do
  use PrintReactWeb, :channel
  use PrintReactWeb, :view

  alias PUP.Models.ConfigModel
  alias PUP.PrinterConfigAgent
  alias PrintReactWeb.Api.PrintConfigView

  def join("configs_channel", _params, socket) do
    configs_map = PrinterConfigAgent.get()

    configs =
      Map.get(configs_map, :lookup, [])
      |> Enum.reverse()
      |> Enum.map(fn name -> Map.get(configs_map, name, %{}) end)

    configs_json = PrintConfigView.render("configs.json", %{configs: configs})
    response = %{configs: configs_json}

    {:ok, response, assign(socket, :configs, configs)}
  end

  def handle_in("configs_new", params, socket) do
    new_config = %ConfigModel{
      name: params["name"],
      form_type: params["formType"],
      printers: params["printers"]
    }

    PrinterConfigAgent.add(new_config)

    new_config_json = PrintConfigView.render("config.json", %{config: new_config})

    broadcast!(socket, "configs_added", new_config_json)
    {:reply, :ok, socket}
  end

  def handle_in("configs_delete", params, socket) do
    config_name_to_delete = params["name"]
    PrinterConfigAgent.delete(config_name_to_delete)

    broadcast!(socket, "configs_deleted", %{name: config_name_to_delete})
    {:reply, :ok, socket}
  end

  def terminate(_reason, socket) do
    {:ok, socket}
  end
end
