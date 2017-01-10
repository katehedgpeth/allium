defmodule Allium.ScenarioTest do
  use ExUnit.Case, async: true
  alias Allium.{Scenario, Breakpoints, Breakpoint}
  require Scenario
  require Breakpoint
  @test_args Allium.TestHelpers.test_args

  setup_all do
    # [_,breakpoints: breakpoints] = @test_args
    # module = Scenario.write_module()
    :ok
  end

  describe "Allium.Scenario" do
    test "module_name/1" do
      assert Scenario.make_module_name(:homepage, :xs) == Homepage.Xs
    end

    test "write_breakpoint_module" do
      assert %Breakpoints{xs: xs} = %Breakpoints{}
      Scenario.write_breakpoint_module({:xs, xs}, :homepage, %{breakpoints: %Breakpoints{}, url: "/"})
    end

    # test "runs a scenario" do
    #   assert [{_, [scenario|_]}|_] = @test_args
    #   Allium.Scenario.start_link scenario
    # end
  end
end
