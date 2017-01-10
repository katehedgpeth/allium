defmodule Allium.OverridesTest do
  alias Allium.{Scenario, Breakpoint}
  use Allium, Allium.TestHelpers.test_args

  describe "throwaway" do
    test "structs" do
      # assert %Breakpoints{} |> Enum.into(@breakpoints)
    end
  end

  test "args" do
    assert %{scenarios: %{homepage: %{url: "/"}}}, breakpoints: %{xs: %{width: 200, height: 100}, md: %{skip: true}} == @all_args
  end

  test "scenarios" do
    assert [homepage: %Scenario{url: "/"}] = @scenarios
  end

  test "breakpoints" do
    assert %{xs: xs, sm: sm, md: md, lg: lg, xl: xl} = @breakpoints
    assert %Breakpoint{width: 200,  height: 100,  skip: false} = xs
    assert %Breakpoint{width: 544,  height: 714,  skip: false} = sm
    assert %Breakpoint{width: 800,  height: 1024, skip: true} = md
    assert %Breakpoint{width: 992,  height: 1300, skip: false} = lg
    assert %Breakpoint{width: 1236, height: 1600, skip: false} = xl
  end
end
