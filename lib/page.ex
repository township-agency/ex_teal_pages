defmodule ExTealPages.Page do
  @moduledoc """
  Used to define the fields that are grouped into a page.
  """
  defstruct key: nil, fields: []

  alias ExTeal.Resource.{Attributes, Show}

  alias Ecto.Multi

  defmacro __using__(_opts) do
    quote do
      use ExTeal.Resource.Repo
      use ExTeal.Resource.Show
      use ExTeal.Resource.Fields

      import Ecto.Query, only: [from: 2]

      alias ExTeal.Naming
      alias ExTeal.Resource.{Fields, Model}

      def handle_show(_conn, _key), do: to_map()

      def to_map do
        fields()
        |> Enum.map(fn field ->
          Atom.to_string(field.field)
        end)
        |> all_for_keys()
        |> Map.new(fn k -> {String.to_atom(k.key), page_value_for(k.data)} end)
      end

      def serialize_response(:show, resource, data, conn) do
        Fields.serialize_response(:show, resource, data, conn)
      end

      def key, do: Naming.resource_name(__MODULE__)

      def title,
        do: __MODULE__ |> Model.title_from_resource() |> Inflex.singularize()

      defoverridable(key: 0, title: 0)

      defp page_value_for(%{"content" => true}), do: true
      defp page_value_for(%{"content" => false}), do: false
      defp page_value_for(%{"content" => content}), do: content
      defp page_value_for(%{"content_array" => content_array}), do: content_array

      def schema, do: Application.get_env(:ex_teal_pages, :copy_schema)

      def all_for_keys(keys) do
        query = from(x in schema(), where: x.key in ^keys)
        repo().all(query)
      end

      def identifier(_model), do: nil
    end
  end

  def update_all_in(page, conn) do
    case multi_for_keys(page, conn) do
      {:ok, _} ->
        Show.call(page, conn, page.key)

      {:error, _key, _cs} ->
        conn
    end
  end

  defp multi_for_keys(page, %{params: params}) do
    params
    |> Attributes.from_params()
    |> Map.keys()
    |> page.all_for_keys()
    |> Enum.reduce(Multi.new(), fn c, acc ->
      val = cast(params[c.key])

      cs =
        case Map.get(c.data, "content") do
          nil ->
            page.schema().changeset(c, %{data: %{"content_array" => val}})

          _val ->
            page.schema().changeset(c, %{data: %{"content" => val}})
        end

      Multi.update(acc, String.to_atom(c.key), cs)
    end)
    |> page.repo().transaction()
  end

  defp cast(""), do: nil
  defp cast("true"), do: true
  defp cast("false"), do: false
  defp cast(val), do: val
end
