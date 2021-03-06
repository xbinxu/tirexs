defmodule Tirexs.ElasticSearch.Settings do
  @moduledoc false

  import Tirexs.ElasticSearch
  alias  Tirexs.ElasticSearch.Config
  alias  Tirexs.Json

  @doc false
  def create_resource(definition) do
    create_resource(definition, %Config{})
  end

  @doc false
  def create_resource(definition, opts) do
    if exist?(definition[:index], opts), do: delete(definition[:index], opts)
    post(definition[:index], to_resource_json(definition), opts)
  end

  @doc false
  def to_resource_json(definition) do
    Json.encode!(settings: definition[:settings])
  end
end