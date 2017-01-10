defmodule Allium.Capture do
  def start_link(args) do
    {:ok, session} = Wallaby.start_session    
  end
end
