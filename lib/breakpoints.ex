defmodule Allium.Breakpoints do
  alias Allium.Breakpoint
  @type t :: %{xs: Breakpoint.t, sm: Breakpoint.t, md: Breakpoint.t, lg: Breakpoint.t, xl: Breakpoint.t}
  defstruct [
    xs: %Breakpoint{width: 320,  height: 480,  skip: false},
    sm: %Breakpoint{width: 544,  height: 714,  skip: false},
    md: %Breakpoint{width: 800,  height: 1024, skip: false},
    lg: %Breakpoint{width: 992,  height: 1300, skip: false},
    xl: %Breakpoint{width: 1236, height: 1600, skip: false}
  ]
end
