defmodule HnAg.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      releases: releases()
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: :test}
    ]
  end

  defp releases do
    [
      hn_ag: [
        include_executables_for: [:unix],
        applications: [
          ets_service: :permanent,
          http_service: :permanent
        ]
      ]
    ]
  end
end
