CLIENT_ID = 'd082276d6bcf9390cb2b1dab9197ce0e'
ME = 2339203

require 'httparty'
require 'pry'
require 'redis'
require 'json'

def read(name)
  JSON.parse ( File.open("../data/#{name}.json", "r").read )
end

def store(name, value)
  puts "Storing #{name}"
  File.open("../data/#{name}.json", "w") do |f|
    f.write value.to_json
  end
end

def get(path, opts = {})
  Kernel.sleep(2)
  puts "Fetching #{path}"

  url = "http://api.soundcloud.com#{path}.json?client_id=#{CLIENT_ID}"
  url += "&limit=#{opts[:limit]}" if opts[:limit]
  res = HTTParty.get url

  if !res.success?
    raise "Error : #{res.inspect}"
  end

  JSON.parse(res.body)
end

def track_ids(user_id)
  get("/users/#{user_id}/favorites", :limit => 200).map{|t|t['id']}  
end

# Get my tracks
my_tracks = track_ids(ME)
store :my_tracks, my_tracks

# Get the users who liked them
users = {}
my_tracks.each do |track_id|

  # Get the likers
  likers = get("/tracks/#{track_id}/favoriters", :limit => 200).map{|u|u['id']}

  # Push them in the local store
  likers.each do |user_id|
    users[user_id] ||= 0
    users[user_id] += 1
  end

end

# Get the potential users
potential_users = users.reject{|k,v|v == 1}.keys
store :potential_users, potential_users

# Get their data
rated_users = {}

potential_users.each do |user_id|
  user_details = get("/users/#{user_id}")
  total_likes = user_details["public_favorites_count"]
  likes = track_ids(user_id)

  store "user_#{user_id}", { :total => total_likes, :tracks => likes }
end
