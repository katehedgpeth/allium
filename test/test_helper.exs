{:ok, _} = Application.ensure_all_started(:wallaby)
ExUnit.start()

defmodule Allium.TestHelpers do
  alias Allium.{Scenario, Breakpoints}
  def test_args, do: [
    scenarios: [
      homepage: [
        url: "/"
      ]
    ],
    breakpoints: [
      xs: [width: 200, height: 100],
      md: [skip: true]
    ]
  ]

  def test_breakpoints, do: Keyword.get(test_args, :breakpoints)

  def breakpoint_args(breakpoint) do
    %Breakpoints{}
    |> Map.from_struct
    |> Map.get(breakpoint)
  end

  def breakpoint_module_args(size \\ :xs, scenario_name \\ :homepage, scenario_url \\ "/") do
    [
      scenario_name: scenario_name,
      scenario_opts: %Scenario{url: scenario_url},
      breakpoint_name: size,
      breakpoint_opts: breakpoint_args(size)
    ]
  end
end
