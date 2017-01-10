defmodule ConfigTest do
  use ExUnit.Case
  alias Allium.{Config, Scenario, Breakpoint, Breakpoints}
  alias Allium.TestHelpers, as: Help
  doctest Config

  @custom_breakpoint [xs: [width: 1200]]

  def map_custom_breakpoints,
    do: Config.map_custom_breakpoints(@custom_breakpoint, Help.test_breakpoints)

  describe "Config.build_scenario_opts/1" do
    test "returns %Scenario{}" do
      assert %Scenario{
        url: "/",
        breakpoints: %Breakpoints{
          xs: xs,
          sm: _sm,
          md: _md,
          lg: _lg,
          xl: _xl
        }
      } = Config.build Help.test_args
      assert xs == %Breakpoint{width: 1200, height: 100, skip: false}
    end
  end

  describe "Config.prioritize_scenario/2" do
    test ""
  end

  describe "Config.map_custom_breakpoints/2" do
    test "returns %Breakpoints{} with custom values (and no nils)" do
      assert {:xs, %Breakpoint{width: width, height: height, skip: skip}} = Config.map_breakpoint_struct({:xs, [width: 100]})
      %Breakpoint{width: default_width, height: default_height, skip: default_skip} = Map.get %Breakpoints{}, :xs
      refute height == nil
      assert height == default_height
      refute skip == nil
      assert skip == default_skip
      refute default_width == 100
      assert width == 100
    end
  end

  # describe "Config.breakpoint_reducer/3" do
  #   test "prioritizes scenario breakpoints over general breakpoint config" do
  #     assert [xs: scenario_xs] = @custom_breakpoint
  #     assert [width: scenario_width] = scenario_xs
  #     assert %{xs: config_xs} = Map.new Help.test_breakpoints
  #     assert [width: config_width, height: config_height] = config_xs
  #     %Breakpoint{width: default_width, height: default_height, skip: default_skip} =
  #       Map.get(%Breakpoints{}, :xs)
  #     scenario_struct = %Breakpoint{width: scenario_width, height: default_height, skip: default_skip}
  #     assert %{xs: %Breakpoint{width: result_width, height: result_height}} =
  #       Config.breakpoint_reducer {:xs, scenario_struct}, %Breakpoint{}, Help.test_breakpoints
  #     refute result_width == default_width
  #     assert result_width == scenario_width
  #     refute result_height == default_height
  #     assert result_height == config_height
  #   end
  # end

  # describe "Config.map_custom_breakpoints/2" do
  #   test "replaces default values with custom values" do
  #     assert %{xs: default_xs, sm: default_sm, md: default_md} = %Breakpoints{}
  #     assert %Breakpoints{xs: xs, sm: sm, md: md} = map_custom_breakpoints
  #     assert sm == default_sm
  #     refute xs == default_xs
  #     refute md == default_md
  #   end
  #
  #   test "prioritizes scenario breakpoints over general breakpoint config" do
  #     assert [xs: [width: scenario_width]] = @custom_breakpoint
  #     assert %{xs: config_xs} = Map.new Help.test_breakpoints
  #     assert [width: config_width, height: config_height] = config_xs
  #     assert %{xs: %Breakpoint{width: result_width, height: result_height}} = map_custom_breakpoints
  #     assert result_width == scenario_width
  #     assert result_height == config_height
  #   end
  # end
  describe "default breakpoints" do
    test "haven't changed" do
      assert %Breakpoints{
        xs: %Breakpoint{width: 320,  height: 480,  skip: false},
        sm: %Breakpoint{width: 544,  height: 714,  skip: false},
        md: %Breakpoint{width: 800,  height: 1024, skip: false},
        lg: %Breakpoint{width: 992,  height: 1300, skip: false},
        xl: %Breakpoint{width: 1236, height: 1600, skip: false}
      } == %Breakpoints{}
    end
  end

  describe "test arguments" do
    test "return value hasn't changed" do
      assert [
        xs: [width: 200, height: 100],
        md: [skip: true]
      ] == Help.test_breakpoints
      assert [scenarios: [homepage: [url: "/"]], breakpoints: Help.test_breakpoints] == Help.test_args
    end
  end

  describe "Throwaway" do
    test "Kernel.struct/2" do
      assert %Breakpoint{width: nil, height: nil, skip: false} == Kernel.struct(Map.get(%Breakpoints{}, :xs), %Breakpoint{} |> Map.from_struct)

    end
  end
end
