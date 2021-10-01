defmodule ExTealPages.Router do
  @moduledoc """
  Routing for ExTeal Pages Addon
  """
  use Plug.Router

  alias Plug.Conn

  alias ExTeal.Resource.{Fields, Serializer, Show}
  alias ExTealPages.Page

  plug(Plug.Static,
    at: "/",
    from: {:ex_teal_pages, "priv/static"}
  )

  plug(Plug.Logger, log: :debug)

  plug(Plug.Parsers, parsers: [:urlencoded])
  plug(Plug.MethodOverride)

  plug(:match)
  plug(:dispatch)

  def init, do: []

  @doc false
  def call(conn, opts) do
    conn =
      conn
      |> extract_namespace(opts)
      |> Conn.put_private(:plug_skip_csrf_protection, true)

    super(conn, opts)
  end

  get "/" do
    {:ok, plugin} = ExTeal.plugin_for("pages")

    {:ok, body} =
      plugin.options.pages
      |> Enum.map(fn module ->
        %{
          title: module.title(),
          key: module.key()
        }
      end)
      |> Jason.encode()

    send_resp(conn, 200, body)
  end

  get "/:page_key" do
    page_key
    |> page_for()
    |> Show.call(conn, page_key)
  end

  get "/:page_key/update-fields" do
    page = page_for(page_key)
    model = page.handle_show(conn, page_key)

    fields =
      :edit
      |> Fields.fields_for(page)
      |> Fields.apply_values(model, page, conn, :edit)

    {:ok, body} = Jason.encode(%{fields: fields})
    Serializer.as_json(conn, body, 200)
  end

  put "/:page_key" do
    page_key
    |> page_for()
    |> Page.update_all_in(conn)
  end

  defp extract_namespace(conn, opts) do
    ns = opts[:namespace] || "teal/plugins/#{ExTealPages.uri()}"
    Conn.assign(conn, :namespace, "/" <> ns)
  end

  defp page_for(key) do
    {:ok, plugin} = ExTeal.plugin_for("pages")
    Enum.find(plugin.options.pages, &(&1.key() == key))
  end
end
