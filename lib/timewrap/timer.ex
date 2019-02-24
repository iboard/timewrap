defmodule Timewrap.Timer do
  require Logger
  use Agent

  def start_link(opts) do
    module =
      case Keyword.fetch(opts, :name) do
        {:ok, name} -> name
        :error -> :default_timer
      end

    Agent.start_link(
      fn -> [mode: :transparent, unit: :second] end,
      name: module
    )
  end

  def current_time(timer \\ :default_timer) do
    case mode(timer) do
      [mode: :transparent, unit: unit] -> System.system_time(unit)
      [mode: :frozen, unit: _, time: time] -> time
      rc -> Logger.error("Unsupported options:" <> inspect(rc, pretty: true))
    end
  end

  def freeze(timer \\ :default_timer, time \\ nil) do
    Agent.update(timer, fn state ->
      unit = Keyword.get(state, :unit)
      [mode: :frozen, unit: unit, time: time || System.system_time(unit)]
    end)

    Agent.get(timer, fn s -> Keyword.get(s, :time) end)
  end

  def unfreeze(timer \\ :default_timer) do
    Agent.update(timer, fn state ->
      [mode: :transparent, unit: Keyword.get(state, :unit)]
    end)

    current_time(timer)
  end

  def mode(timer \\ :default_timer) do
    Agent.get(timer, fn state -> state end)
  end
end
