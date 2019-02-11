defmodule Timewrap.MixProject do
  use Mix.Project

  def project do
    [
      app: :timewrap,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      # The main page in the docs
      docs: [
        main: "readme",
        logo: "assets/images/logo.png",
        extras: ["README.md", "LICENSE.md", "CHANGELOG.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Timewrap.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.16", only: :dev, runtime: false}
    ]
  end
end
