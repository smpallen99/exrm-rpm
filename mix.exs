defmodule ExrmRpm.Mixfile do
  use Mix.Project

  def project do
    [app: :exrm_rpm,
     version: "0.3.0",
     elixir: "~> 1.0",
     description: description,
     package: package,
     deps: deps]
  end

  def application do
    [applications: []]
  end

  defp description do
    """
    Adds simple Red Hat Package Manager (RPM) generation to the exrm package manager.
    The generated RPM file includes the Elixir release and an init.d script to 
    manage the project's service.
    """
  end

  defp deps do
    [{:exrm, git: "https://github.com/bitwalker/exrm.git", tag: "0.19.6"}]
  end

  defp package do
    [ files: ["lib", "priv", "mix.exs", "README.md", "LICENSE"],
      contributors: ["Stephen Pallen"],
      licenses: ["MIT"],
      links: [ { "GitHub", "https://github.com/smpallen99/exrm-rpm" } ] ]
  end
end
