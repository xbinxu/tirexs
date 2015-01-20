defmodule Tirexs.Json do
  @moduledoc false

	alias Poison, as: J

  require Logger

	def encode(v = %{}, opt \\ []) do 
    opt = opt |> Dict.merge escape: :unicode, iodata: false
		case J.encode(v, opt) do 
			{:ok, result} -> {:ok, result |> IO.iodata_to_binary}
			other -> other
		end
	end

  def encode!(v) do 
    encode!(v, escape: :unicode, iodata: false)
  end

	def encode!(v = %{}, opt) do 
		J.encode!(v, opt) 
	end	

  def encode!(v, opt) when is_list(v) do 
    if Keyword.keyword?(v) do 
      __MODULE__.encode!(keyword_to_map(v), opt)
    else 
      J.encode!(children_keyword_to_map(v), opt)
    end
  end

	def decode(v, opt \\ []) do 
		J.decode(v, opt)
	end

	def decode!(v, opt \\ []) do 
		J.decode!(v, opt)
	end

  defp keyword_to_map(v) do 
    keyword_to_map(v, %{})
  end

  defp keyword_to_map([], acc = %{}) do 
    acc
  end

  defp keyword_to_map([{k, v} | other], acc = %{}) do 
    if Keyword.keyword?(v) do 
      acc = Map.put(acc, k, keyword_to_map(v))
    else 
      if is_list(v) do 
        acc = Map.put(acc, k, children_keyword_to_map(v))
      else
        acc = Map.put(acc, k, v)
      end
    end

    keyword_to_map(other, acc)
  end

  defp children_keyword_to_map(v) do 
    children_keyword_to_map(v, [])
  end

  defp children_keyword_to_map([], acc) do 
    Enum.reverse(acc)
  end

  defp children_keyword_to_map([h|t], acc) do 
    if Keyword.keyword?(h) do 
      acc = [keyword_to_map(h) | acc]
    else 
      if is_list(h) do 
        acc = [children_keyword_to_map(h) | acc]
      else
        acc = [h | acc]
      end
    end

    children_keyword_to_map(t, acc)
  end

end
