require_relative "fairyfloss/helpers"
require_relative "fairyfloss/icons"
require_relative "fairyfloss/colors"
require_relative "fairyfloss/tmux_options"
require_relative "fairyfloss/config"
require_relative "fairyfloss/spotify"
require_relative "fairyfloss/slack"
require_relative "fairyfloss/cpu_status"
require_relative "fairyfloss/battery_status"
require_relative "fairyfloss/session_info"
require_relative "fairyfloss/vpn_status"
require_relative "fairyfloss/right_segment"
require_relative "fairyfloss/status_bar"

module FairyflossTheme
  extend self

  # TODO: Move to StatusBar
  attr_accessor :status_bar_fg, :status_bar_bg

  def apply_theme

    TmuxOptions.set_all({
      pane_border_style: "fg=#{Colors[:lilac]}",
      pane_active_border_style: "fg=#{Colors[:seafoam]}",
      message_style: "fg=#{Colors[:message_fg]}," +
      "bg=#{Colors[:message_bg]},bold",
      message_command_style: "fg=#{Colors[:message_fg]}," \
      "bg=#{Colors[:message_bg]},bold",
      display_panes_active_colour: Colors[:display_panes_active],
      display_panes_colour: Colors[:display_panes],
      status_justify: "left",
      status_left: status_left,
      status_left_length: status_left_length,
      status_style: status_style,
      status_right_length: "128",
      status_right: status_right,
    })

    TmuxOptions.set_all({
      clock_mode_colour: Colors[:goldenrod],
      mode_style: "fg=#{Colors[:mode_bg]}," +
                  "bg=#{Colors[:mode_bg]},bold",
      window_status_style: "fg=#{Colors[:window_status_fg]}," +
                           "bg=#{Colors[:window_status_bg]}",
      window_status_format:  "#I #W",
      window_status_current_format: window_current_format,
      window_status_activity_style: "fg=default,bg=default,underscore",
      window_status_bell_style: "fg=#{Colors[:window_status_bell_fg]}," +
                                "bg=#{Colors[:window_status_bell_bg]}," +
                                "blink,bold",
      window_status_last_style: "default,fg=" + Colors[:window_status_last_fg]
    }, :window)

  end



  def window_current_format
    "#[fg=#{Colors[:status_bg]}," +
      "bg=#{Colors[:window_current_bg]}]" +
      Icons[:left_separator_black] +
      "#[fg=#{Colors[:window_current_fg]}," +
      "bg=#{Colors[:window_current_bg]},bold]" +
      " #I" + Icons[:left_separator] + " #W " +
      "#[fg=#{Colors[:window_current_bg]},bg=#{Colors[:status_bg]},nobold]" +
      Icons[:left_separator_black]
  end

  # TODO: Move to StatusBar
  def status_style
    "fg=#{Colors[:status_fg]},bg=#{Colors[:status_bg]}"
  end

  # TODO: Move to StatusBar
  def status_left
    "#[fg=#{Colors[:session_fg]},bg=#{Colors[:session_bg]},bold]" +
      " #{Icons[:session_symbol]} #S" +
      "#[fg=#{Colors[:session_bg]}," +
      "bg=#{Colors[:status_bg]},nobold]" +
      Icons[:left_separator_black] + " "
  end

  def status_left_length
    "32"
  end

  # TODO: oh gods
  def multiple_tmux_sessions?
    `tmux -q -L tmux_theme_status_left_test -f /dev/null new-session -d \; show -g -v status-left \; kill-session`.trim == "[#S]"
  end

  # TODO: Move to StatusBar
  def status_right
    FairyflossTheme::StatusBar.new
      .add_segment(clock_segment)
      .add_segment(vpn_segment)
      .add_segment(spotify_segment)
      .add_segment(cpu_battery_segment)
      .to_s
    # "︎$segment_color_dark$status_clock$status_vpn$status_spotify$segment_color_light$status_battery$status_cpu"
  end

  # TODO: Move to SlackStatus
  def slack_segment
    {
      content: Icons[:slack_symbol],
      bg: Colors[:slack_bg],
      fg: Colors[:slack_fg]
    }
  end

  # TODO: Move to Clock
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

  #TODO Move to SpotifyStatus
  def spotify_segment
    if SpotifyStatus.stopped?
      {content: nil, fg: nil, bg: nil}
    else
      {
        content: SpotifyStatus.status_string,
        bg: Colors[:spotify_bg],
        fg: Colors[:spotify_fg]
      }
    end
  end
end
