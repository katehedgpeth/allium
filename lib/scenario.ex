defmodule Allium.Scenario do
  import ExUnit.{Case, Assertions}
  alias Allium.{Breakpoints, Breakpoint}
  require Allium.Breakpoint
  @type t :: %{url: String.t, breakpoints: Breakpoints.t, max_threshold: float, javascript: String.t}
  defstruct [
    # name: nil,
    url: "/",
    breakpoints: %Breakpoints{},
    max_threshold: 0.1,
    javascript: nil
  ]

  def make_module_name(scenario_name, breakpoint_name) do
    Module.concat(
      scenario_name
      |> Atom.to_string
      |> Macro.camelize,

      breakpoint_name
      |> Atom.to_string
      |> Macro.camelize
    )
  end

  @doc """
  Generates a new module for each breakpoint in a scenario. Using separate modules allows the tests to be run async.
  """
  @spec write_breakpoint_modules({atom, t}) :: {atom, list, list}
  defmacro write_breakpoint_modules({scenario_name, %__MODULE__{breakpoints: breakpoints} = opts}) do
    quote do
      breakpoints
      |> Enum.reject(&Allium.Scenario.skipped/1)
      |> Enum.map(&Allium.Scenario.write_breakpoint_module(&1, unquote(scenario_name), unquote(opts)))
    end
  end

  @spec write_breakpoint_module({atom, Breakpoint.t}, atom, Scenario.t) :: {atom, list, list}
  defmacro write_breakpoint_module({_, %Breakpoint{skip: true}}, _, _), do: :ok
  defmacro write_breakpoint_module({breakpoint_name, breakpoint_opts}, scenario_name, scenario_opts) do
    require Allium.Breakpoint
    quote do
      module_name = Allium.Scenario.make_module_name(unquote(scenario_name), unquote(breakpoint_name))
      defmodule Module.concat(__MODULE__, module_name) do
        Allium.Breakpoint.run [
          scenario_name: unquote(scenario_name),
          scenario_opts: unquote(scenario_opts),
          breakpoint_name: unquote(breakpoint_name),
          breakpoint_opts: unquote(breakpoint_opts)
        ]
      end
    end
  end
  defmacro write_breakpoint_module(_, _, _), do: :error

  def skipped(%Breakpoint{skip: skip}), do: skip

  def start_link(scenario) do
    {:ok, pid} = GenServer.start_link(__MODULE__, [%{scenario: scenario, parent: self, finished: []}])
    GenServer.cast(pid, :start)
  end

  # def start(args), do:
  def init(state), do: {:ok, state}

  def handle_cast(:build_scenario, state) do
    # build_scenario(state)
    {:noreply, state}
  end

  def handle_cast({:finished, {breakpoint, result}}, %{scenario: %{breakpoints: breakpoints}, parent: parent, finished: finished} = state) do
    finished = [result | finished]
    if length(finished) == length(breakpoints) do
      GenServer.cast(parent, {:finished, {}})
    end
  end

  # def build_scenario({scenario_name, %{breakpoints: breakpoints}}) do
  #   Application.ensure_all_started(:ex_unit)
  #   for breakpoint <- breakpoints do
  #     Allium.Breakpoint.start_link(%{scenario: scenario, breakpoint: breakpoint})
  #   end
  # end
end
