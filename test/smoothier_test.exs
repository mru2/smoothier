defmodule Store do

  def my_tracks do
    read("my_tracks") |> elem(1)
  end

  def user(user_id) do
    json = read("user_#{user_id}") |> elem(1)
    %{total: json["total"], tracks: json["tracks"]}
  end

  def users do
    read("potential_users") |> elem(1)
  end

  defp read(file) do
    {:ok, json} = File.read("data/#{file}.json")
    JSEX.decode(json)
  end

end


defmodule Common do

  def count(l1, l2), do: count(l1 |> Enum.sort, l2 |> Enum.sort, 0)

  # Stop when one is empty
  defp count([], _l, i), do: i
  defp count(_l, [], i), do: i

  # When equal, increment
  defp count([a|t1], [a|t2], i), do: count(t1, t2, i+1)

  # Otherwise, drop the smallest and continue
  defp count(l1, l2, i) do
    if hd(l1) < hd(l2), do: count(tl(l1), l2, i), else: count(l1, tl(l2), i)
  end

end


defmodule Algo do

  def run(track_id) do
    my_tracks = Store.my_tracks



    # Store.get_users(track_id)
    #  |> select_users
    #  |> Enum.map( fn user = %{id: id} ->  %{ user | tracks: DB.get_user_tracks(id) } end )
    #  |> select_tracks
    #  |> List.first(10)
  end

  def sigma(user, my_tracks) do
    Common.count(user.tracks, my_tracks) / user.total
  end

end


defmodule SmoothierTest do
  use ExUnit.Case

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "redis reading" do
    { :ok, client } = Exredis.start_link

    client |> Exredis.Api.set "foo", "bar"
    res = client |> Exredis.Api.get "foo"
    assert res == "bar"
  end

  test "file reading" do
    assert Store.my_tracks |> hd == 152589690
    assert Store.users |> hd == 82928248
  end

  test "common tracks count" do
    assert Common.count([1, 2, 3], [2, 8, 5, 1]) == 2
  end

  test "sigma calculation" do
    user = Store.user 103083700
    my_tracks = Store.my_tracks

    assert Algo.sigma(user, my_tracks) == 0.0967741935483871
  end

end
