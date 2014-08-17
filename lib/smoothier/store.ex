defmodule Smoothier.Store do

  def my_tracks do
    read("my_tracks") |> elem(1)
  end

  def user(user_id) do
    case read("user_#{user_id}") do
      {:ok, json} -> %{total: json["total"], track_ids: json["tracks"]}
      {:none, _} -> nil
    end
  end

  def all_users do
    read("user_all") |> elem(1)
  end

  def users_for(track_id) do
    read("user_#{track_id}") |> elem(1)
  end

  defp read(file) do
    case File.read("data/#{file}.json") do
      {:ok, json} -> JSEX.decode(json)
      {:error, :enoent} -> {:none, nil}
    end
  end

end
