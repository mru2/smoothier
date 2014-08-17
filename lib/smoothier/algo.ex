defmodule Smoothier.Algo do

  alias Smoothier.Store
  alias Smoothier.Utils

  def top_tracks(scoring, track_id) do
    my_tracks = Store.my_tracks

    all_users_for(track_id)
     |> Enum.take(1000)
     |> Enum.map( &( weighted_tracks(&1, my_tracks) ) )
     |> consolidate_tracks
     |> Enum.reject( &(Enum.member? my_tracks, &1.id) )
     |> Enum.filter( &select_track/1 )
     |> Enum.map( &( score_track scoring, &1 ) )
     |> Enum.sort( &( &1.score > &2.score ) )
  end

  def all_users_for(track_id) do
    Store.users_for(track_id)
     |> Enum.map( &( Store.user(&1) ) )
     |> Enum.reject( &( &1 == nil ) )
  end

  def sigma(user, my_tracks) do
    Utils.count(user.track_ids, my_tracks) / length(user.track_ids)
  end

  def weighted_tracks(user, my_tracks) do
    user_score = sigma(user, my_tracks)
    user.track_ids |> Enum.map fn track_id -> %{id: track_id, sigma: user_score} end
  end

  def consolidate_tracks(tracks) do
    tracks 
     |> Enum.concat
     |> Enum.group_by( &(&1.id) )
     |> Enum.map &consolidate_track/1
  end

  def consolidate_track({id, tracks}) do
    sigmas = tracks |> Enum.map( &(&1.sigma) )
    %{id: id, sigmas: sigmas}
  end

  def select_track(%{sigmas: sigmas}), do: length(sigmas) > 2

  def score_track(algo, track) do  
    s = stats(track.sigmas)
    score = algo.(s)
    %{id: track.id, stats: s, score: score}
  end

  def stats(values) do
    count = length values
    sum = Enum.sum values
    mean = sum / count
    variance = values |> Enum.map( &( :math.pow((&1 - mean), 2) ) ) |> Enum.sum
    stdiv = :math.sqrt(variance)
    consensus = mean / stdiv
    %{
      sum: sum,
      count: count, 
      mean: mean, 
      stdiv: stdiv, 
      consensus: consensus
    }
  end

  def mean(list), do: Enum.sum(list) / Enum.length(list)

end

