defmodule StoreTest do
  use ExUnit.Case

  alias Smoothier.Store

  test "fetching a users tracks" do
    assert Store.my_tracks == []
  end

end