Code.require_file "../../test_helper.exs", __ENV__.file
defmodule Acceptances.WarmerTest do
  use ExUnit.Case
  import TestHelpers

  import Tirexs.Search.Warmer
  alias  Tirexs.ElasticSearch.Config
  alias  Tirexs.Json

  require Logger

  @settings %Config{}

  setup_all do 
    on_exit fn -> 
      remove_index("bear_test", @settings)
    end
  end

  test :create_warmer do
    Tirexs.ElasticSearch.delete("bear_test", @settings)

    warmers = warmers do
      warmer_1 [types: []] do
        source do
          query do
            match_all
          end
          facets do
            facet_1 do
              terms field: "field"
            end
          end
        end
      end
    end


    {:ok, 200, body} = Tirexs.ElasticSearch.put("bear_test", Json.encode!(warmers), @settings)

    Logger.info "create bear_test request body: #{Json.encode!(warmers)}, response: #{inspect body, pretty: true}"

    {:ok, 200, body} = Tirexs.ElasticSearch.get("bear_test/_warmer/warmer_1", @settings)

    assert Dict.get(body, :bear_test) |> Dict.get(:warmers) 
      == [
            warmer_1: [types: [], 
                       source: [query: [match_all: []], 
                                facets: [facet_1: [terms: [field: "field"]]
                                        ]
                               ]
                      ]
         ]
  end
end
