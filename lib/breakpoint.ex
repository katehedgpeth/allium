defmodule Allium.Breakpoint do
  import ExUnit.{Case, Assertions}
  use GenServer
  @type t :: %{width: integer, height: integer, skip: boolean}
  defstruct [width: nil, height: nil, skip: false]

  def start_link(args) do
    {:ok, pid} = GenServer.start_link(__MODULE__, %{args: args, parent: self})
    GenServer.cast(pid, :start)
  end

  def handle_cast(:start, state) do

    {:noreply, state}
  end

  def make_module_name, do: Module.concat(__MODULE__, Allium.Breakpoint.random_module_name)
  def random_module_name, do: "Test" <> (1..1_000_000 |> Enum.random |> Integer.to_string)

  @spec run(scenario_name: atom, scenario_opts: map, breakpoint_name: atom) :: {atom, list, list}
  defmacro run(args) do
    quote do
      defmodule unquote(make_module_name) do
        use ExUnit.Case, async: true
        use Wallaby.DSL
        alias Allium.{Scenario, Breakpoint}

        [
          scenario_name: bp_scenario_name,
          scenario_opts: scenario_opts,
          breakpoint_name: bp_name,
          breakpoint_opts: %Breakpoint{skip: is_skipped}
        ] = unquote(args)

        setup do
          args = unquote(args)
          {:ok, args}
        end

        test "Screenshot: #{bp_scenario_name} - #{bp_name}#{if is_skipped do ~s( -- SKIPPED) end}",
          %{scenario_name: scenario, scenario_opts: %Scenario{url: url, breakpoints: breakpoints}, breakpoint_name: breakpoint_name,
            breakpoint_opts: %Breakpoint{width: width, height: height, skip: skip}} do
          unless skip do
            assert {:ok, session} = Wallaby.start_session
            with_screenshot =
              session
              |> set_window_size(width, height)
              |> visit(url)
              |> take_screenshot
            assert %Wallaby.Session{screenshots: [_screenshot]} =  with_screenshot
          end

          # assert true == true
        end
      end
    end
  end
end
