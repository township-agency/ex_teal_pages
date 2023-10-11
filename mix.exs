defmodule ExTealPages.MixProject do
  use Mix.Project

  @source "https://github.com/township-agency/ex_teal_pages"

  def project do
    [
      app: :ex_teal_pages,
      version: "0.7.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      docs: docs(),
      package: package(),
      name: "ExTealPages",
      source_url: @source
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_teal, ">= 0.27.0"},
      {:ecto, "~> 3.0"},
      {:plug, "~> 1.7"},
      {:jason, "~> 1.0"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end

  defp description do
    "ExTealPages is a ExTeal tool for managing static copy on pages"
  end

  defp package do
    [
      files: ~w(lib .formatter.exs mix.exs README* CHANGELOG* priv),
      maintainers: [
        "Caleb Oller",
        "Lydia Koller",
        "Samina Khan",
        "Scott Taylor"
      ],
      licenses: ["MIT"],
      links: %{"GitHub" => @source}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: [
        "README.md",
        "CHANGELOG.md"
      ],
      source_url: @source
    ]
  end
end
