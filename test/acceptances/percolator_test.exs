Code.require_file "../../test_helper.exs", __ENV__.file
defmodule Tirexs.PerlocatorTest do
  use    ExUnit.Case
  alias  Tirexs.ElasticSearch.Config
  import Tirexs.Percolator

  test :percolator do
    settings = %Config{}
    Tirexs.ElasticSearch.delete("percolator_/test/kuku", settings)

    percolator = percolator [index: "test", name: "kuku"] do
      query do
        term "field1", "value1"
      end
    end

    {_, _, body} = Tirexs.Percolator.create_resource(percolator, settings)

    assert body[:_id] == "kuku"
  end
end
