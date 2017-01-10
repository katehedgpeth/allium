defmodule Allium.TagsTest do
  alias Allium.{Scenario, Breakpoint}

  use Allium, Allium.TestHelpers.test_args

  test "session", %{session: session} do
    assert %Wallaby.Session{} = session
  end

  breakpoint_opts = Map.merge %Breakpoint{},
    Allium.TestHelpers.test_args
    |> Keyword.get(:breakpoints)
    |> Map.get(:xs)

  @tag breakpoint: {:xs, breakpoint_opts}
  test "breakpoint", %{breakpoint: breakpoint} do
    assert {:xs, %Breakpoint{width: 200, height: 100, skip: false}} == breakpoint
  end
end
