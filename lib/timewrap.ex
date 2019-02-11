defmodule Timewrap do
  @moduledoc """
  Timewrap is a "Time-Wrapper" through which you can access different
  time-sources, Elixir and Erlang offers you. Other than that you 
  can implement on your own.

  Also, _Timewrap_ can do the time-wrap, freeze, and unfreeze a 
  `Timewrap.Timer`.

  You can instantiate different `Timewrap.Timer`s, registered and
  supervised by `:name`.

  The `Timewrap.TimeSupervisor` is started with the `Timewrap.Application`
  and implicitly starts the default timer `:default_timer`. This
  one is used whenever you call Timewrap-functions without a 
  timer given as the first argument.

  ### Examples:

      use Timewrap # imports some handy Timewrap-functions.

  #### With default Timer

      Timewrap.freeze_timer()
      item1 = %{ time: current_time() }
      :timer.sleep(1000)
      item2 = %{ time: current_time() }
      assert item1.time == item2.time


  #### Transactions with a given and frozen time

      with_frozen_timer(~N[1964-08-31 06:00:00Z], fn ->
        ... do something while `current_time` will 
        always return the given timestamp within this
        block...
      end )

  #### Start several independent timers

      {:ok, today} = new_timer(:today)
      {:ok, next_week} = new_timer(:next_week)
      freeze_time(:today, ~N[2019-02-11 09:00:00])
      freeze_time(:next_week, ~N[2019-02-18 09:00:00])
      ... do something ...
      unfreeze_time(:today)
      unfreeze_time(:next_week)

  """

  defmacro __using__(_args) do
    quote do
      alias Timewrap.Timer

      import Timewrap,
        only: [
          current_time: 0,
          freeze_time: 0,
          freeze_time: 1,
          unfreeze_time: 0,
          unfreeze_time: 1,
          new_timer: 1,
          release_timer: 1
        ]
    end
  end

  @doc """
  Get the `current_time` in the format you've configured.

  ### Configuration

  TODO: Describe configuration here.

  ### Examples

      iex> Timewrap.current_time() == System.system_time(:second)
      true

  """
  def current_time(timer \\ :default_timer) do
    Timewrap.Timer.current_time(timer)
  end

  @doc """
  Freeze the current time. All calls to `current_time` will return
  the same value until you call `unfreeze`.

  ### Example:

      iex> frozen = Timewrap.freeze_time()
      iex> :timer.sleep(1001)
      iex> assert frozen == Timewrap.current_time()
      true

  """
  def freeze_time(timer \\ :default_timer, time \\ nil) do
    freeze(timer, time)
  end

  @doc """
  Unfreeze a frozen time. If the Timer is not frozen, this function
  is a _noop_.

  ### Example:

      iex> frozen = Timewrap.freeze_time()
      iex> :timer.sleep(1001)
      iex> assert frozen == Timewrap.current_time()
      iex> reseted = Timewrap.unfreeze_time()
      iex> assert reseted == System.system_time(:second)
      iex> assert reseted != frozen
      true

  """
  def unfreeze_time(timer \\ :default_timer) do
    unfreeze(timer)
  end

  @doc """
  Start a new timer-agent. A supervised worker of
  `Timewrap.TimeSupervisor`.

  ### Example:

      iex> use Timewrap
      iex> {:ok, t} = new_timer(:mytime)
      iex> assert is_pid(t)
      iex> :timer.sleep(100)
      iex> Timewrap.release_timer(t)
      :ok

  """
  def new_timer(name) do
    {:ok, pid} = Timewrap.TimeSupervisor.start_timer(name)
    {:ok, pid}
  end

  @doc """
  Release a running timer terminates the process and removes
  it from supervision.

  ### Example:

      iex> use Timewrap
      iex> {:ok, t} = new_timer(:mytime)
      iex> :timer.sleep(100)
      iex> release_timer(t)
      iex> Process.alive?(t)
      false

  """
  def release_timer(pid) do
    if Process.alive?(pid) do
      Timewrap.TimeSupervisor.stop_timer(pid)
    end
  end

  @doc """
  Execute a given block with a timer frozen at the given time

  ### Example

       iex> use Timewrap
       iex> "1964-08-31 06:00:00+0100" 
       iex> |> Timewrap.with_frozen_time(fn() ->
       iex>   assert current_time() == -168372000
       iex> end) 
       true
  """
  def with_frozen_time(time, fun) do
    {:ok, dt, offset} = DateTime.from_iso8601(time)

    freeze_time(:default_timer, DateTime.to_unix(dt) + offset)
    rc = fun.()
    unfreeze_time(:default_timer)
    rc
  end

  defp freeze(timer, time), do: Timewrap.Timer.freeze(timer, time)

  defp unfreeze(timer), do: Timewrap.Timer.unfreeze(timer)
end
