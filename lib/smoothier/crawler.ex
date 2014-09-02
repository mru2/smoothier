defmodule Smoothier.Crawler do

  @moduledoc """
  Handle the soundcloud crawl throttling and queue
  """

  def ping({type, id}) do
    IO.puts "Adding #{type}:#{id} to the crawl list"
  end

end