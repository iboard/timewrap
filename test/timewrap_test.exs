defmodule TimewrapTest do
  use ExUnit.Case
  doctest Timewrap

  use Timewrap

  setup _ do
    {:ok, timer} = Timewrap.new_timer(:test_timer)

    on_exit(fn -> Timewrap.release_timer(timer) end)

    {:ok, %{t: timer}}
  end

  describe "Timewrap in tests" do
    test "tests start with RealTime", %{t: timer} do
      assert is_pid(timer)
      assert [mode: :transparent, unit: :second] == Timer.mode(timer)
    end
  end
end
