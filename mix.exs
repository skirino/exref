defmodule Exref.Mixfile do
  use Mix.Project

  @github_url "https://github.com/skirino/exref"

  def project do
    [
      app:             :exref,
      version:         "0.1.0",
      elixir:          "~> 1.2",
      build_embedded:  Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps:            deps,
      description:     description,
      package:         package,
      source_url:      @github_url,
      homepage_url:    @github_url,
    ]
  end

  def application do
    []
  end

  defp description do
    """
    Damn simple mix integration of xref.
    """
  end

  defp package do
    [
      files:       ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Shunsuke Kirino"],
      licenses:    ["MIT"],
      links:       %{"GitHub repository" => @github_url},
    ]
  end

  defp deps do
    [
      {:xref_runner, github: "X4lldux/xref_runner", branch: "bugfix-for-52"},
    ]
  end
end
