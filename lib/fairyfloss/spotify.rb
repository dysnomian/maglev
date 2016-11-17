module SpotifyStatus
  extend self

  attr_reader :status, :artist, :track, :last_updated

  ARTIST_SCRIPT_PATH = ENV["TMUX_PLUGIN_MANAGER_PATH"] +
    "tmux-spotify/scripts/spotify_artist.sh"
  TRACK_SCRIPT_PATH = ENV["TMUX_PLUGIN_MANAGER_PATH"] +
    "tmux-spotify/scripts/spotify_track.sh"
  STATUS_SCRIPT_PATH = ENV["TMUX_PLUGIN_MANAGER_PATH"] +
    "tmux-spotify/scripts/spotify_status.sh"

  #TODO: Truncate track and artist names
  def status_string
    "#{Icons[:spotify_icon]} #{status} #{artist}: #{track}" unless stopped?
  end

  def refresh_status
    @artist = TmuxOptions.run_script("tmux-spotify", "spotify_artist.sh").strip
    @track  = TmuxOptions.run_script("tmux-spotify", "spotify_track.sh").strip
    @last_updated = Time.now
    @status = TmuxOptions.run_script("tmux-spotify", "spotify_status.sh").strip
  end

  def stopped?
    refresh_status
    status.nil? || status == Icons[:spotify_stopped_icon]
  end
end

