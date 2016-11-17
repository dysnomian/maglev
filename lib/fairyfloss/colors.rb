module Colors
  extend self

  #TODO migrate to config
  ROUND_SEPARATORS = true

  def [](name)
    colors.fetch(name.to_sym)
  end

  private

  def colors
    @colors ||= base_colors.merge({
      status_fg: base_colors[:silver],
      status_bg: base_colors[:bg_purple],
      session_fg: base_colors[:bg_purple],
      session_bg: base_colors[:seafoam],
      message_fg: base_colors[:bg_purple],
      message_bg: base_colors[:goldenrod],
      mode_fg: base_colors[:bg_purple],
      mode_bg: base_colors[:goldenrod],
      display_panes_active: base_colors[:seafoam],
      display_panes: base_colors[:seafoam],
      window_status_fg: base_colors[:silver],
      window_status_bg: base_colors[:bg_purple],
      window_current_fg: base_colors[:silver],
      window_current_bg: base_colors[:peach],
      window_status_bell_fg: base_colors[:goldenrod],
      window_status_bell_bg: "default",
      window_status_last_fg: base_colors[:silver],
      window_status_last_bg: "default",
      slack_bg: base_colors[:magenta],
      slack_fg: base_colors[:silver],
      time_date_fg: base_colors[:silver],
      time_date_bg: base_colors[:bg_purple],
      battery_full_fg: base_colors[:magenta],
      battery_empty_fg: base_colors[:silver],
      battery_bg: base_colors[:bg_purple],
      whoami_fg: base_colors[:silver],
      whoami_bg: base_colors[:peach],
      host_fg: base_colors[:peach],
      host_bg: base_colors[:silver],
      vpn_fg: base_colors[:silver],
      vpn_bg: base_colors[:pink],
      spotify_fg: base_colors[:bg_purple],
      spotify_bg: base_colors[:seafoam],
    })
  end

  def base_colors
    {
      bg_purple: "#5a5475",
      goldenrod: "#fffea0",
      lavender: "#8076aa",
      lilac: "#c5a3ff",
      pink: "#ffb8d1",
      peach: "#ff857f",
      magenta: "#f92672",
      seafoam: "#c2ffdf",
      silver: "#f8f8f0",
    }
  end
end
