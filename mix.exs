defmodule Tirexs.Mixfile do
  use Mix.Project

  def project do
    [ 
    	app: :tirexs, 
      version: "0.5.0", 
      elixir: "~> 1.0.1 or ~> 1.1",
      deps: deps 
    ]
  end

  def application do
    [
      env: [],
      applications: [:logger] 
    ]
  end

  defp deps do
    [ 
    	{:poison, "~> 1.3"} 
    ]
  end
end