defmodule Smoothier.Store do

  @moduledoc """
  Module responsible for manipulating/accessing the tracks data
  Interfaces with redis and the soundcloud crawler
  """

  @me 2339203

  use Exredis.Api
  alias Smoothier.Crawler

  # Fetch the tracks ids / user ids
  def my_tracks, do: tracks(@me)

  def users(track_id) do
    Crawler.ping {:track, track_id}
    redis |> smembers "track:#{track_id}:users"
  end

  def tracks(user_id) do
    Crawler.ping {:user, user_id}
    redis |> smembers "user:#{user_id}:tracks"
  end



  # Gets the redis client (seems like the registered name is not usable as is)
  defp redis do
    Process.whereis Redis
  end


end
