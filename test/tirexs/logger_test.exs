Code.require_file "../../test_helper.exs", __ENV__.file

defmodule Tirexs.LoggerTest do
  use ExUnit.Case
  alias Tirexs.Json

  test :to_curl do
    assert Tirexs.Logger.to_curl([d: 4]) == :ok
    assert Tirexs.Logger.to_curl(Json.encode!([d: 4])) == :ok
  end
end
