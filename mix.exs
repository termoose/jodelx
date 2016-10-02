defmodule Jodelx.Mixfile do
  use Mix.Project

  def project do
    [app: :jodelx,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison, :postgrex, :ecto, :live_reload, :edeliver],
     mod: {Jodelx, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:httpoison, "~> 0.9.0"},
     {:poison, "~> 2.0"},
     {:postgrex, ">= 0.0.0"},
     {:ecto, "~> 2.0.0"},
     {:live_reload, git: "https://github.com/termoose/live-reload", only: :dev},
     {:edeliver, "~> 1.4.0"},
     {:distillery, ">= 0.8.0", warn_missing: false}]
  end
end
