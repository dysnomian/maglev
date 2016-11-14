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
      status_fg: base_colors[:lilac],
      status_bg: base_colors[:bg_purple],
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
      lilac: "#c5a3ff",
      seafoam: "#c2ffdf",
      bg_purple: "#5a5475",
      goldenrod: "#fffea0",
      lavender: "#8076aa",
      magenta: "#f92672",
      silver: "#f8f8f0",
      peach: "#ff857f",
      pink: "#ffb8d1",
    }
  end
end
