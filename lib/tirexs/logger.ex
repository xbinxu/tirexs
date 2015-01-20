defmodule Tirexs.Logger do
  @moduledoc false
  require Logger

  def to_curl(data) do
    Logger.info inspect data, pretty: true
  end
end