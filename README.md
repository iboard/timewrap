# Timewrap
[![Documentation](https://img.shields.io/badge/docs-hexpm-blue.svg)](http://hexdocs.pm/timewrap/)
[![Documentation](https://travis-ci.com/iboard/timewrap.svg?branch=master)](https://travis-ci.com/iboard/timewrap)

Timewrap is a "Time-Wrapper" through which you can access different
time-sources, Elixir and Erlang offers you. Other than that you 
can implement on your own.

Also, _Timewrap_ can do the time-warp, freeze, and unfreeze a 
`Timewrap.Timer`.

You can instantiate different `Timewrap.Timer`s, registered and
supervised by `:name`.

The `Timewrap.TimeSupervisor` is started with the `Timewrap.Application`
and implicitly starts the default timer `:default_timer`. This
one is used whenever you call Timewrap-functions without a 
timer given as the first argument.

### Examples:

The best way to figure out how you can use this library is by having a look at 
this [Test suite](https://github.com/iboard/hexpack-examples/blob/master/test/hexpack_examples_test.exs).


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


## Installation

From [available Hex package](https://hex.pm/docs/publish), the package can be installed
by adding `timewrap` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:timewrap, "~> 0.1.3"}
  ]
end
```
 
### Configuration

  `config/config.exs`

      config :timewrap,
        timer: :default,
        unit: :second,
        calendar: Calendar.ISO,
        representation: :unix


  `lib/your_app/application.ex`

      use Application

      @impl true
      def start(_type, _args) do
        # List all child processes to be supervised
        children = [
          # Starts a worker by calling: Timewrap.Worker.start_link(arg)
          {Timewrap.TimeSupervisor, strategy: :one_for_one, name: Timewrap.TimeSupervisor} #<---ADD THIS
        ]

        # See https://hexdocs.pm/elixir/Supervisor.html
        # for other strategies and supported options
        opts = [strategy: :one_for_one, name: Timewrap.Supervisor]
        Supervisor.start_link(children, opts)
      end

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/timewrap](https://hexdocs.pm/timewrap).

