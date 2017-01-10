defmodule Allium do
#
# NOTE: This is a work-in-progress thing that I've been playing with on my own time to see if it's possible to for us
# to replace Backstop with our own module that takes advantage of Elixir's concurrent processing. So far I've gotten it
# to take screenshots using an app called Wallaby (basically Casper for elixir -- we could also use Wallaby for other
# tests). It's not particularly fast at the moment because it is taking all of the screenshots as part of one module,
# which means they're not able to take advantage of ExUnit's async capability. If there is a way to define a separate
# test module for each screenshot (I'm sure there is), I think it would run much faster.
#
#
# I've started playing around with image processing as well, but the only processor I've found (Imagineer) is VERY slow,
# taking at least 6 seconds per screenshot, and I haven't dug into the output yet so I'm not sure if we even need
# the info it's taking all that time to produce.
#
  use ExUnit.CaseTemplate
  alias __MODULE__.{Scenario, Breakpoints, Breakpoint, Config}

  @type t :: %{scenarios: [Scenario.t], breakpoints: Breakpoints.t}
  defstruct [scenarios: [homepage: %Scenario{}], breakpoints: %Breakpoints{}]

  # defmodule AsyncHelper do
  #
  #   def wait_until(fun), do: wait_until(@timeout, fun)
  #   def wait_until(0, fun), do: fun.()
  #   def wait_until(timeout, fun) do
  #     try do
  #       fun.()
  #     rescue
  #       ExUnit.AssertionError ->
  #         :timer.sleep(10)
  #         wait_until(max(0, timeout - 10), fun)
  #     end
  #   end
  # end

  @doc """
  Recursively turns a keyword list into a map.
  """
  @spec into_map(Keyword.t) :: map
  def into_map(nil), do: nil
  def into_map(map) when is_map(map), do: map
  def into_map(list) when is_list(list), do: Enum.into(list, %{}, &do_into_map/1)
  def do_into_map({k, v}) when is_list(v), do: {k, Enum.into(v, %{}, &do_into_map/1)}
  def do_into_map(val) when is_list(val), do: Enum.map(val, &do_into_map/1)
  def do_into_map(val), do: val

  defmacro __using__(args \\ []) do
    scenarios = Config.build(args)

    quote do
      use ExUnit.Case, async: true
      use Wallaby.DSL
      # import Site.Router.Helpers
      # # import Allium.AsyncHelper
      # alias Wallaby.Phantom.Driver
      alias Allium.Breakpoints
      import Allium, only: [into_map: 1]
      #
      @scenarios = unquote(scenarios)
      # @breakpoints %{custom_breakpoints | %Breakpoints{}}

      setup tags do
        Allium.Runner.start(tags)
      end

      for {scenario_name, scenario_opts} <- @scenarios do
        @tag scenario_name: scenario_name
        @tag scenario_opts: scenario_opts
      end


    end
  end
end

      # setup tags do
      #   {:ok, session} = Wallaby.start_session
      #   breakpoint_opts = Map.get(tags, :breakpoint_opts)
      #   scenario_opts = Map.get(tags, :scenario_opts)
      #   # reference = Task.async(fn ->
      #   #   [Map.get(tags, :screenshot_dir), "reference", "#{Map.get(tags, :scenario_name)}_#{Map.get(tags, :breakpoint_name)}.png"]
      #   #   |> Path.join
      #   #   |> Imagineer.load
      #   # end)
      #   screenshot =
      #     session
      #     |> set_window_size(breakpoint_opts[:width], breakpoint_opts[:height])
      #     |> visit(scenario_opts[:url])
      #     |> take_screenshot
      #     # |> Driver.take_screenshot
      #     # |> IO.inspect
      #     # |> Imagineer.Image.PNG.process
      #   opts =  [:scenario_name, :scenario_opts, :breakpoint_name, :breakpoint_opts, :reference_file]
      #           |> Enum.map(&({&1, Map.get(tags, &1)}))
      #           |> Enum.into(%{})
      #           |> Map.merge(%{session: session, screenshot: screenshot}) #, reference: reference})
      #   {:ok, opts}
      # end

      # for {scenario_name, scenario_opts} <- unquote(scenarios) do
      #   for {breakpoint_name, breakpoint_opts} <- @breakpoints do
      #     %{skip: skip} = breakpoint_opts
      #     unless skip == true do
      #       @tag scenario_name: scenario_name
      #       @tag scenario_opts: scenario_opts
      #       @tag breakpoint_name: breakpoint_name
      #       @tag breakpoint_opts: breakpoint_opts
      #       @tag screenshot_dir: Path.join([Application.app_dir(:site), "priv", "screenshots"])
      #       test "#{scenario_name}: #{breakpoint_name}", %{ session: session,
      #                                     # reference: reference,
      #                                     screenshot: screenshot,
      #                                     scenario_name: scenario_name,
      #                                     breakpoint_name: breakpoint_name,
      #                                     breakpoint_opts: %{width: width, height: height}} do
      #         assert screenshot
      #         # wait_until fn ->
      #         #   assert Task.await(reference, unquote(@timeout))
      #         #   assert Task.await(screenshot, unquote(@timeout))
      #         # end
      #       end
      #     end
      #   end
      # end
