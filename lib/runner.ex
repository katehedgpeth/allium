defmodule Allium.Runner do
  def start(tags) do
    {:ok, session} = Wallaby.start_session
    breakpoint = Map.get(tags, :breakpoint)


    # screenshot =
    #   session
    #   |>

    {:ok, session: session, breakpoint: breakpoint}
  end
end
