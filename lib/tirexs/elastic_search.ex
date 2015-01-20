defmodule Tirexs.ElasticSearch do

  require Logger

  @doc """
  This module provides a simple convenience for connection options such as `port`, `uri`, `user`, `pass`
  and functions for doing a `HTTP` request to `ElasticSearch` engine directly.
  """
  defmodule Config do 
    defstruct port: 9200, 
              uri: "127.0.0.1", 
              user: nil, 
              pass: nil
  end

  @doc false
  def get(query_url, config) do
    do_request(make_url(query_url, config), :get)
  end

  @doc false
  def put(query_url, config), do: put(query_url, [], config)

  def put(query_url, body, config) do
    unless body == [], do: body = to_string(body)
    do_request(make_url(query_url, config), :put, body)
  end

  @doc false
  def delete(query_url, config), do: delete(query_url, [], config)

  @doc false
  def delete(query_url, _body, config) do
    unless _body == [], do: _body = to_string(_body)
    do_request(make_url(query_url, config), :delete)
  end

  @doc false
  def head(query_url, config) do
    do_request(make_url(query_url, config), :head)
  end

  @doc false
  def post(query_url, config), do: post(query_url, [], config)

  def post(query_url, body, config) do
    unless body == [], do: body = to_string(body)
    url = make_url(query_url, config)
    do_request(url, :post, body)
  end

  @doc false
  def exist?(url, settings) do
    case head(url, settings) do
      {:error, _, _} -> false
      _ -> true
    end
  end

  @doc false
  def do_request(url, method, body \\ []) do
    # Logger.info "httpc request #{url}, #{method}, body: #{inspect body, pretty: true}"
    :inets.start()
    { url, content_type, options } = { String.to_char_list(url), 'application/json', [{:body_format, :binary}] }
    case method do
      :get    -> response(:httpc.request(method, {url, []}, [], []))
      :head   -> response(:httpc.request(method, {url, []}, [], []))
      :put    -> response(:httpc.request(method, {url, make_headers, content_type, body}, [], options))
      :post   -> response(:httpc.request(method, {url, make_headers, content_type, body}, [], options))
      :delete -> response(:httpc.request(method, {url, make_headers},[],[]))
    end
  end

  defp response(req) do
    # Logger.info "httpc response: #{inspect req, pretty: true}"
    case req do
      {:ok, { {_, status, _}, _, body}} ->
        if round(status / 100) == 4 || round(status / 100) == 5 do
          { :error, status, body }
        else
          case body do
            [] -> { :ok, status, [] }
            _  -> { :ok, status, get_body_json(body) }
          end
        end
      e ->
        :error
    end
  end

  def get_body_json(body), do: Poison.decode!(to_string(body), keys: :atoms)

  def make_url(query_url, config) do
    if config.port == nil || config.port == 80 do
      "http://#{config.uri}/#{query_url}"
    else
      "http://#{config.uri}:#{config.port}/#{query_url}"
    end
  end

  defp make_headers, do: [{'Content-Type', 'application/json'}]
end
