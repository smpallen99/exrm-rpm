defmodule ExrmRpm.Mixfile do
  use Mix.Project

  def project do
    [app: :exrm_rpm,
     version: "0.1.1",
     elixir: "~> 0.13.2",
     description: "Adds simple RPM generation to the exrm package manager.",
     package: package,
     deps: deps]
  end

  def application do
    [applications: []]
  end

  defp deps do
    [{:exrm, "~> 0.7.2"}]
  end

  defp package do
    [ files: ["lib", "priv", "mix.exs", "README.md", "LICENSE"],
      contributors: ["Stephen Pallen"],
      licenses: ["MIT"],
      links: [ { "GitHub", "https://github.com/smpallen99/exrm-rpm" } ] ]
  end
end
