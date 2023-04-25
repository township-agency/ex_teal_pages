defmodule ExTealPages.ViewHelpers do
  @moduledoc """
  Simple functions for rendering content from a page
  """

  def content_for(page, key) do
    case Map.fetch(page, key) do
      {:ok, copy} -> copy
      :error -> nil
    end
  end

  def elements_for(page, key) do
    case Map.fetch(page, key) do
      {:ok, copy} ->
        element_for(copy)

      :error ->
        []
    end
  end

  defp element_for(copy) do
    Enum.map(copy, fn element ->
      Map.new(element, fn {k, v} -> {String.to_atom(k), v} end)
    end)
  end
end
