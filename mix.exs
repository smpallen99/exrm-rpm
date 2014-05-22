defmodule ExrmRpm.Mixfile do
  use Mix.Project

  def project do
    [app: :exrm_rpm,
     version: "0.0.2",
     elixir: "~> 0.13.2",
     deps: deps]
  end

  def application do
    [applications: []]
  end

  defp deps do
    [
      {:exrm, "~>0.6.11"}
    ]
  end
end
