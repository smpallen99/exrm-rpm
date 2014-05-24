defmodule ExrmRpm.Mixfile do
  use Mix.Project

  def project do
    [app: :exrm_rpm,
     version: "0.0.4",
     elixir: "~> 0.13.2",
     deps: deps]
  end

  def application do
    [applications: []]
  end

  defp deps do
    [
      {:exrm, "~>0.7.1"}
    ]
  end
end
