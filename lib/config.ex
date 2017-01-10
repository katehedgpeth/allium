defmodule Allium.Config do
  alias Allium.{Scenario, Breakpoints, Breakpoint}

  @doc """
  Combines various config sources into a single configuration.
  this test <- all tests (:config) <- default
  """
  def build(scenario_args) do
    scenario_args
    |> Keyword.get(:breakpoints)
    |> do_build_scenario_opts(scenario_args)
  end


  @doc false
  @spec do_build_scenario_opts(Keyword.t, Keyword.t) :: Scenario.t
  def do_build_scenario_opts(nil, args), do: Kernel.struct(%Scenario{}, args)
  def do_build_scenario_opts(custom_breakpoints, scenario_arg_list),
    do: Enum.reduce(scenario_arg_list, %Scenario{}, &scenario_reducer(&1, &2, custom_breakpoints))

  @doc false
  @spec scenario_reducer({atom, Keyword.t}, Scenario.t, Keyword.t) :: Scenario.t
  def scenario_reducer({:breakpoints,v}, %Scenario{} = scenario, custom_breakpoints) do
    Kernel.struct(scenario, breakpoints: map_custom_breakpoints(v, custom_breakpoints))
  end
  def scenario_reducer(kv, %Scenario{} = scenario, _), do: Kernel.struct(scenario, [kv])

  @doc false
  @spec map_custom_breakpoints(Keyword.t, Keyword.t) :: Breakpoints.t
  def map_custom_breakpoints(scenario_breakpoints, config_breakpoints) do
    config_breakpoints
    |> Enum.map(&map_breakpoint_struct/1)
    |> Enum.map(&prioritize_scenario(&1, scenario_breakpoints))
    |> map_breakpoints_struct
  end

  @spec map_breakpoints_struct(Keyword.t) :: Breakpoints.t
  defp map_breakpoints_struct(breakpoints), do: struct(%Breakpoints{}, breakpoints)

  @spec prioritize_scenario({atom, Breakpoint}, Keyword.t) :: {atom, Breakpoint.t}
  defp prioritize_scenario({k,config_struct}, scenario_breakpoints),
    do: {k, struct(config_struct, Keyword.get(scenario_breakpoints, k))}

  @doc false
  @spec map_breakpoint_struct(Keyword.t | {atom, Keyword.t}, atom) :: {atom, Breakpoint.t}
  def map_breakpoint_struct(kvtuple_or_val, key \\ nil)
  def map_breakpoint_struct(v, k) when is_list(v) do
    %Breakpoints{}
    |> Map.get(k)
    |> struct(v)
  end
  def map_breakpoint_struct({k, v}, _), do: {k, map_breakpoint_struct(v, k)}

end
