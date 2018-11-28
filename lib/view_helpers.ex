defmodule ExTealPages.ViewHelpers do
  @moduledoc """
  Simple functions for rendering content from a page
  """

  def content_for(page, key) do
    with {:ok, copy} <- Map.fetch(page, key) do
      copy
    else
      :error -> nil
    end
  end

  def elements_for(page, key) do
    with {:ok, copy} <- Map.fetch(page, key) do
      copy
      |> Enum.map(fn element ->
        Map.new(element, fn {k, v} -> {String.to_atom(k), v} end)
      end)
    else
      :error -> []
    end
  end
end
