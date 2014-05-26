defmodule ExrmRpm.Mixfile do
  use Mix.Project

  def project do
    [app: :exrm_rpm,
     version: "0.1.0",
     elixir: "~> 0.13.2",
     description: "Adds simple RPM generation to the exrm package manager."
     deps: deps]
  end

  def application do
    [applications: []]
  end

  defp deps do
    [
      {:exrm, "~> 0.7.2"}
    ]
  end
end
