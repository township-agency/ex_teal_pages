defmodule ExTealPages.ArrayField do
  @moduledoc """
  Modifies a field to allow teal to manage an array.
  """

  def mut(field) do
    child_comp = field.component
    opts = field.options

    %{
      field
      | component: "pages-array",
        options: Map.put_new(opts, :child_component, child_comp)
    }
  end
end
