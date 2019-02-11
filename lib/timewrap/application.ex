defmodule Timewrap.Application do
  @moduledoc """
  The Application starts a supervised `Timewrap.TimeSupervisor` which
  implicitly starts the default `Timewrap.Timer`, named `:default_timer`.

  See https://hexdocs.pm/elixir/Application.html
  for more information on OTP Applications
  """

  use Application

  @impl true
  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: Timewrap.Worker.start_link(arg)
      {Timewrap.TimeSupervisor, strategy: :one_for_one, name: Timewrap.TimeSupervisor}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Timewrap.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
