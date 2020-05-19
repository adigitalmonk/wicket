defmodule Wicket.MixProject do
  use Mix.Project

  def project do
    [
      app: :wicket,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Wicket.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:uuid, "~> 1.1"},
      {:poolboy, "~> 1.5.1"},
      {:jason, "~> 1.0"},
      {:credo, "~> 1.2", only: [:dev, :test], runtime: false}
    ]
  end
end
