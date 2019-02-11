defmodule Timewrap.TimeSupervisor do
  require Logger
  alias Timewrap.Timer
  use DynamicSupervisor

  def start_link(args) do
    # start the default timer for the application
    spawn(fn ->
      :timer.sleep(1)
      Timewrap.new_timer(:default_timer)
    end)

    DynamicSupervisor.start_link(args)
  end

  @impl true
  def init(opts), do: DynamicSupervisor.init(opts)

  def start_timer(name) do
    DynamicSupervisor.start_child(__MODULE__, {Timer, name: name})
  end

  def stop_timer(pid) do
    DynamicSupervisor.terminate_child(Timewrap.TimeSupervisor, pid)
  end
end
