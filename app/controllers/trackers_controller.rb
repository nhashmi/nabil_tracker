class TrackersController < ApplicationController

  def index
    @nabil = Tracker.create(name: "Nabil") 
    
    # Software development
    @dev_time = @nabil.get_dev_time
    @hours = @dev_time[:hours]
    @minutes = @dev_time[:minutes]

    # Music listening
    @music = @nabil.get_most_recent_tracks
  end

end
