defmodule Smoothier do
  use Application

  alias Smoothier.Algo
  alias Smoothier.Store

  def start(_type, _args) do

    IO.puts "Starting the redis server"
    { :ok, pid } = Exredis.start_link
    Process.register pid, Redis

    # TODO : start the crawler

    IO.puts "Starting the API..."
    {:ok, _pid} = Smoothier.API.start

    {:ok, self}
  end

  # Here for now
  def run(track_id) do
    scoring = fn stats -> stats.mean end

    tracks = Algo.top_tracks(scoring, track_id)

    tracks |> Enum.take(20) |> Enum.each(fn track -> 
      IO.puts "#{track.id} [#{track.stats.count} | #{track.stats.mean}] - #{track.score}"
    end)
    
  end
end
