defmodule DellTestElixir.MixProject do
  use Mix.Project

  def project do
    [
      app: :dell_test_elixir,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: [main_module: DellTestElixir],

      # Docs

      name: "ElixirDellTest",
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
      {:nimble_csv, "~> 1.2"},
      {:decimal, "~> 2.0"},
      {:table_rex, "~> 3.1.1"},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
    ]
  end
end
