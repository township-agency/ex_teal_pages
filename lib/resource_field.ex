defmodule ExTealPages.ResourceField do
  @moduledoc """
  Displays a resource index on the detail view of a page.
  """

  use ExTeal.Field

  def component, do: "resource-field"

  def value_for(_field, _model, _type), do: nil

  def show_on_index, do: false
  def show_on_new, do: false
  def show_on_edit, do: false
end
