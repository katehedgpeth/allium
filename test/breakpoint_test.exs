defmodule Allium.BreakpointTest do
  use ExUnit.Case, async: true
  require Allium.Breakpoint
  alias Allium.Breakpoint

  setup tags do
    case Map.get(tags, :macro) do
      %{name: :run, result: breakpoint} -> {:ok, breakpoint: breakpoint}
      _ -> %{breakpoint: :error}
    end
  end

  describe "Allium.Breakpoint" do
    test "random_module_name/1" do
      assert "Test" <> number = Breakpoint.random_module_name
      assert is_binary(number)
      assert String.to_integer(number)
      assert Module.concat(__MODULE__, "Test" <> number)
    end

    test "make_module_name/1" do
      assert ["Allium", "Breakpoint", "Test" <> _] = Module.split(Breakpoint.make_module_name)
    end

    @tag macro: %{
      name: :run,
      result: Breakpoint.run(Allium.TestHelpers.breakpoint_module_args)
    }
    test "run/1", %{breakpoint: breakpoint} do
      # refute breakpoint
      assert {:module, _module_name, _charlist, _result} = breakpoint
    end
  end
end
