defmodule ExTealPages do
  @moduledoc """
  Documentation for ExTealPages.
  """
  use ExTeal.Plugin

  alias ExTeal.Asset.Script

  def uri, do: "pages"

  def repo, do: nil

  def router, do: ExTealPages.Router

  def navigation_component, do: "pages-nav"

  def content_for_page(key) do
    page = page_for_key(key)
    page.to_map()
  end

  def scripts, do: [%Script{path: "js/pages.js"}]

  defp page_for_key(key) do
    case ExTeal.plugin_for("pages") do
      {:ok, plugin} ->
        Enum.find(plugin.options.pages, &(&1.key() == key))

      _ ->
        ExTealPages.Page
    end
  end
end
