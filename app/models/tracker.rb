class Tracker < ActiveRecord::Base

  def get_dev_time
    rescuetime_key = ENV["rescuetime_key"]
    yesterday = Date.today.prev_day.strftime(("%Y-%m-%d"))
    response = HTTParty.get("https://www.rescuetime.com/anapi/data?key=#{rescuetime_key}&perspective=rank&restrict_kind=overview&restrict_begin=#{yesterday}&restrict_end=#{yesterday}&format=json")
    @dev_category = response["rows"].select { |category| category[-1] == "Software Development"}
    @dev_category.flatten! 
    dev_time_seconds = @dev_category[1]
    dev_time_hours = dev_time_seconds / 3600
    dev_time_minutes = (dev_time_seconds % 3600) / 60
    @dev_time = {
      hours: dev_time_hours, 
      minutes: dev_time_minutes
    }
    return @dev_time
  end

  def get_most_recent_tracks
    last_fm_api_key = ENV["last_fm_api_key"]
    response = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=nabil2011&limit=10&api_key=#{last_fm_api_key}&format=json")
    tracks = response["recenttracks"]["track"]
    @recent_tracks = []
    tracks.each do |track|
      image = track["image"].select { |image| image["size"] == "large"}
      image.flatten!
      track_info = {
        artist: track["artist"]["#text"],
        name: track["name"],
        url: track["url"],
        image: image[0]["#text"]
      }
      @recent_tracks << track_info
    end
    return @recent_tracks
  end

end
