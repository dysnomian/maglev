module Icons
  extend self

  #TODO migrate to config
  ROUND_SEPARATORS = true

  def [](name)
    icons.fetch(name.to_sym)
  end

  private

  def icons
    @icons ||= {
      session_symbol: '❐',
      slack_symbol: '',           # nerdfonts f198
      vpn_symbol: '',             # nerdfonts f0ec
      calendar_symbol: '',        # nerdfonts f133
      cpu_symbol: "",             # nerdfonts f0ae
      batt_charged_icon: "",
      batt_charging_icon: "",     # nerdfonts f1e6
      batt_discharging_icon: "♡",
      spotify_icon: "♫",
      spotify_playing_icon: "",
      spotify_paused_icon: "",
      spotify_stopped_icon: "■",
    }.merge(separators)
  end

  def separators
    ROUND_SEPARATORS ? round_separators : pointy_separators
  end

  def round_separators
    {
      left_separator: '',
      left_separator_black: '',
      right_separator: '',
      right_separator_black: '',
    }
  end

  def pointy_separators
    {
      left_separator: '',
      left_separator_black: '',
      right_separator: '',
      right_separator_black: '',
    }
  end
end
