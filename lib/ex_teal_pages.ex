defmodule ExTealPages do
  @moduledoc """
  Documentation for ExTealPages.
  """
  use ExTeal.Plugin

  def uri, do: "pages"

  def repo, do: nil

  def router, do: ExTealPages.Router

  def navigation_component, do: "pages-nav"

  def content_for_page(key) do
    page = page_for_key(key)
    page.to_map()
  end

  defp page_for_key(key) do
    with {:ok, plugin} <- ExTeal.plugin_for("pages") do
      Enum.find(plugin.options.pages, &(&1.key() == key))
    else
      _ -> ExTealPages.Page
    end
  end
end
