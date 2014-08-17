defmodule Smoothier do
  use Application

  alias Smoothier.Algo

  def start(_type, _args) do
    IO.puts "Starting smoothier..."

    {:ok, self}
  end

  # Here for now
  def run(track_id) do
    scoring = fn stats -> stats.mean end

    tracks = Algo.top_tracks(scoring, track_id)

    tracks |> Enum.take(20) |> Enum.each(fn track -> 
      IO.puts "#{track.id} [#{track.stats.count}] - #{track.score}"
    end)
    
  end
end
