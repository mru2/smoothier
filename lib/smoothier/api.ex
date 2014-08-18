defmodule Smoothier.API do
  
  import Plug.Conn
  use Plug.Router

  plug :match
  plug :dispatch

  def start do
    Plug.Adapters.Cowboy.http Smoothier.API, []
  end

  def default_scoring(stats), do: stats.mean

  get "/me/tracks" do
    tracks = Smoothier.Store.my_tracks
    {:ok, out} = JSEX.encode tracks

    send_resp(conn, 200, out)
  end

  get "/track/:track_id" do
    tracks = Smoothier.Algo.top_tracks(&default_scoring/1, track_id) |> Enum.take(100)
    {:ok, out} = JSEX.encode tracks

    send_resp(conn, 200, out)
  end

  match _ do
    send_resp(conn, 404, "oops")    
  end

end