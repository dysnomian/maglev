require "#{FF_DIR}/tmux_options.rb"

module SpotifyStatus
  extend self

  attr_reader :status, :artist, :track, :last_updated

  ARTIST_SCRIPT_PATH = ENV["TMUX_PLUGIN_MANAGER_PATH"] +
    "tmux-spotify/scripts/spotify_artist.sh"
  TRACK_SCRIPT_PATH = ENV["TMUX_PLUGIN_MANAGER_PATH"] +
    "tmux-spotify/scripts/spotify_track.sh"
  STATUS_SCRIPT_PATH = ENV["TMUX_PLUGIN_MANAGER_PATH"] +
    "tmux-spotify/scripts/spotify_status.sh"

  def status_string
    refresh_status
    "#{Icons[:spotify_icon]} #{status} #{artist}: #{track}"
  end

  def refresh_status
    @status = TmuxOptions.run_script("tmux-spotify", "spotify_status.sh").strip
    @artist = TmuxOptions.run_script("tmux-spotify", "spotify_artist.sh").strip
    @track  = TmuxOptions.run_script("tmux-spotify", "spotify_track.sh").strip
    @last_updated = Time.now
  end

  def stopped?
    status == Icons[:spotify_stopped_icon]
  end
end

