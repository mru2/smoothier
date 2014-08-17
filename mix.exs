defmodule Smoothier.Mixfile do
  use Mix.Project

  def project do
    [app: :smoothier,
     version: "0.0.1",
     elixir: "~> 0.14.2",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [
      applications: [:cowboy, :plug],
      mod: {Smoothier, []}
    ]
  end

  # Dependencies can be hex.pm packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:exredis, git: "https://github.com/artemeff/exredis.git"},
      {:ibrowse, github: "cmullaparthi/ibrowse", tag: "v4.1.0"},
      {:httpotion, "~> 0.2.0"},
      {:jsex, "~> 2.0.0"},
      {:cowboy, "~> 1.0.0"},
      {:plug, "<= 0.5.1"} # Elixir 15 required for more recent version of plug
    ]
  end
end
