

defmodule SmoothierTest do
  use ExUnit.Case

  alias Smoothier.Algo
  alias Smoothier.Store
  alias Smoothier.Utils

  setup do
    { :ok, client } = Exredis.start_link
  end

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "redis reading" do
    client |> Exredis.Api.set "foo", "bar"
    res = client |> Exredis.Api.get "foo"
    assert res == "bar"
  end

  test "file reading" do
    assert Store.my_tracks |> hd == 152589690
    assert Store.users |> hd == 82928248
  end

  test "common tracks count" do
    assert Utils.count([1, 2, 3], [2, 8, 5, 1]) == 2
  end

  test "sigma calculation" do
    user = Store.user 103083700
    my_tracks = Store.my_tracks

    assert Algo.sigma(user, my_tracks) == 0.0967741935483871
  end

  test "weighted_tracks" do
    assert Algo.weighted_tracks(%{track_ids: [1, 4, 6], total: 12}, [1, 7, 5]) == [%{id: 1, sigma: 0.08333333333333333}, %{id: 4, sigma: 0.08333333333333333}, %{id: 6, sigma: 0.08333333333333333}]
  end

  # test "out" do
  #   algo = fn track -> 
  #     track.mean
  #     # track.consensus * :math.log(track.count)
  #   end

  #   tracks = Algo.top_tracks(algo, "all")

  #   out = tracks |> Enum.take(20) |> Enum.each(fn track -> 
  #     IO.puts "#{track.id} [#{track.stats.count}] - #{track.score}"
  #   end)

  # end

end
