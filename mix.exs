defmodule Timewrap.MixProject do
  use Mix.Project

  def project do
    [
      app: :timewrap,
      version: "0.1.4",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
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

  def description,
    do: ~S"""
    **Timewrap** is a simple _wrapper_ you can use to access
    time. Other than that, you can freeze and unfreeze different
    timers. Very handy in tests.
    """

  def package() do
    [
      name: "timewrap",
      files: ["lib", "mix.exs", "README*", "LICENSE*", "CHANGELOG*"],
      maintainers: ["andreas@altendorfer.at"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/iboard/timewrap",
        "Documentation" => "https://hexdocs.pm/timewrap/readme.html"
      }
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.16", only: :dev, runtime: false}
    ]
  end
end
