CLIENT_ID = 'd082276d6bcf9390cb2b1dab9197ce0e'
ME = 2339203

require 'httparty'
require 'pry'
require 'redis'
require 'json'

def read(name)
  JSON.parse ( File.open("../data/#{name}.json", "r").read )
end

def stored?(name)
  File.exist? "../data/#{name}.json"
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

def update_user!(user_id, force = false)
  return if !force && stored?("user_#{user_id}")

  begin 
    user_details = get("/users/#{user_id}")
    total_likes = user_details["public_favorites_count"]
    likes = track_ids(user_id)

    store "user_#{user_id}", { :total => total_likes, :tracks => likes }
  rescue => e
    puts "Error fetching user : #{e.message}"
  end
end

