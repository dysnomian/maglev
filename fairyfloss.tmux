#!/usr/bin/env ruby

require 'yaml'

FF_DIR = ENV["TMUX_PLUGIN_MANAGER_PATH"] + "tmux-fairyfloss"

require "#{FF_DIR}/helpers.rb"
require "#{FF_DIR}/icons.rb"
require "#{FF_DIR}/colors.rb"

require "#{FF_DIR}/tmux_options.rb"
require "#{FF_DIR}/config.rb"
require "#{FF_DIR}/spotify.rb"
require "#{FF_DIR}/slack.rb"
require "#{FF_DIR}/cpu_status.rb"
require "#{FF_DIR}/battery_status.rb"
require "#{FF_DIR}/session_info.rb"
require "#{FF_DIR}/vpn_status.rb"
require "#{FF_DIR}/right_segment.rb"
require "#{FF_DIR}/status_bar.rb"

module FairyflossTheme
  extend self

  ROUND_SEPARATORS = true

  attr_accessor :status_bar_fg, :status_bar_bg

  def apply_theme
    TmuxOptions.set("status_style", status_style)
    TmuxOptions.set("status-right-length", "128")
    TmuxOptions.set("status-right", status_right)
  end

  def status_style
    "fg=#{Colors[:status_fg]},bg=#{Colors[:status_bg]}"
  end

  def status_right
    FairyflossTheme::StatusBar.new
      .add_segment(clock_segment)
      .add_segment(vpn_segment)
      .add_segment(spotify_segment)
      .add_segment(slack_segment)
      .to_s
    # "︎$segment_color_dark$status_clock$status_vpn$status_spotify$segment_color_light$status_battery$status_cpu"
  end

  def slack_segment
    {
      content: Icons[:slack_symbol],
      bg: Colors[:slack_bg],
      fg: Colors[:slack_fg]
    }
  end

  def clock_segment
    {
      content: " %R %a %b %d ",
      fg: Colors[:status_fg],
      bg: Colors[:status_bg]
    }
  end

  #TODO: Move to VpnStatus
  def vpn_segment
    if VpnStatus.connected?
      vpn_list = VpnStatus.connected_vpns
      vpn_count = vpn_list.count

      vpn_list_str = Icons[:vpn_symbol] + " " + vpn_list.join(", ")
      vpn_list_chars = vpn_list_str.split("").count

      status_string = vpn_list_chars > 20 ? "( #{vpn_count} " : vpn_list_str

      {
        content: status_string,
        bg: Colors[:vpn_bg],
        fg: Colors[:vpn_fg]
      }
    else
      {content: nil, fg: nil, bg: nil}
    end
  end

  #TODO: Move to VpnStatus
  def vpn_status
    if ENV['TMUX_PLUGIN_MANAGER_PATH']
      `#{ENV['TMUX_PLUGIN_MANAGER_PATH']}/tmux-vpn/scripts/vpn_status.sh`.strip
    else
      raise "Missing env variable: TMUX_PLUGIN_MANAGER_PATH"
    end
  end

  def vpn_name
    `scutil --nc show "CHI-VPN-MFA" | head -n 1 | awk '{gsub(/[""]/,""); print $5}'`
  end

  def spotify_segment
    if false #SpotifyStatus.stopped?
      {content: nil, fg: nil, bg: nil}
    else
      {
        content: SpotifyStatus.status_string,
        bg: Colors[:spotify_bg],
        fg: Colors[:spotify_fg]
      }
    end
  end

  def battery_segment
  end

  def cpu_segment
  end
end

FairyflossTheme.apply_theme
