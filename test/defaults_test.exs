defmodule AlliumTest.DefaultsTest do
  alias Allium.Breakpoint
  use Allium

  test "breakpoints" do
    assert %{xs: xs, sm: sm, md: md, lg: lg, xl: xl} = @breakpoints
    assert %Breakpoint{width: 320,  height: 480,  skip: false} == xs
    assert %Breakpoint{width: 544,  height: 714,  skip: false} == sm
    assert %Breakpoint{width: 800,  height: 1024, skip: false} == md
    assert %Breakpoint{width: 992,  height: 1300, skip: false} == lg
    assert %Breakpoint{width: 1236, height: 1600, skip: false} == xl
  end

  test "scenarios" do
    assert %{} == @scenarios
  end
end
