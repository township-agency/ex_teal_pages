# ExTealPages

A Simple ExTeal Plugin that pretends to be a CMS for KV Pairs.  Use it for
application settings, or static copy.

## Installation

The package can be installed by adding `ex_teal_pages` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_teal_pages, "~> 0.2"}
  ]
end
```

Add the plugin to your manifest:

```elixir
  def plugins, do: [
    ExTealPages.new(%{
      pages: []
    })
  ]
```

Point `ex_teal_pages` at the schema you want it to manage for storing values:

```elixir
config :ex_teal_pages,
  copy_schema: MyApp.CMS.Copy
```

Where `MyApp.CMS.Copy` looks like:

```elixir
defmodule MyApp.CMS.Copy do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "copy" do
    field :data, :map
    field :key, :string
    field :label, :string

    timestamps()
  end

  @doc false
  def changeset(copy, attrs) do
    copy
    |> cast(attrs, [:data, :key, :label])
    |> validate_required([:data, :key, :label])
  end
end
```

with a migration that looks like:

```elixir
defmodule MyApp.Repo.Migrations.CreateCopy do
  use Ecto.Migration

  def change do
    create table(:copy) do
      add :data, :map
      add :key, :string
      add :label, :string

      timestamps()
    end

    create index(:copy, [:key])
  end
end
```

**A word to the wise**

Be sure that you seed any initial values for rows you want to manage in the copy
schema.  This plugin will only update, not insert.

### Adding Pages

Write a new module for the page you want to manage:

```elixir
defmodule MyAppWeb.ExTeal.Pages.PaginationSettings do
  @moduledoc """
  Page for default pagination values
  """
  use ExTealPages.Page

  alias ExTeal.Fields.Number

  def title, do: "Pagination Settings"

  def key, do: "pagination"

  def fields,
    do: [
      Number.make(:page_size)
    ]
end
```

Tell `ex_teal_pages` to manage the page in the manifest:

```elixir
def plugins,
  do: [
    ExTealPages.new(%{
      pages: [PaginationSettings]
    })
  ]
```

Navigate to the page in `/teal` and profit!

### Advanced Content

#### ResourceField

You can nest a resource index inside of a page.  For example, you might have a
list of careers on an about us page that you only want to display in Teal inside
the context of an `AboutUs` page:

```elixir
defmodule MyAppWeb.ExTeal.Pages.AboutUs do
  @moduledoc """
  Content of the About Us Page
  """

  use ExTealPages.Page

  alias ExTeal.Fields.RichText
  alias ExTealPages.ResourceField

  def fields,
    do: [
      RichText.make(:about_us_overview, "Overview"),
      ResourceField.make(:quotes),
      ResourceField.make(:careers)
    ]
end
```

#### ArrayField

You can use `ArrayField.mut()` to transform a KV field into a fieldset that
contains a fixed length list of keys and values. For example:

```elixir
def fields,
  do: [
    ExTeal.Fields.Text.make(:header_copy) |> ArrayField.mut()
  ]
```

Given an initial value of:

```
%{
  key: "header_copy",
  data: %{
    content_array: [
      %{
        title: "Greeting",
        content: "Hello Teal!"
      },
      %{
        title: "Description",
        content: "This is Teal. It's very fancy."
      },
      %{
        title: "People",
        content: "The cool people of Township built this thing"
      }
    ]
  }
}
```

Teal will render a panel with three text fields, all labeled based on their
title.
