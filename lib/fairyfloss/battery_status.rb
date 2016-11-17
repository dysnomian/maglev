module BatteryStatus
  #TODO: Move to BatteryStatus
  def segment
    {
      content: Icons[:cpu_symbol] +
      ' #{cpu_percentage}' +
      Icons[:battery_icon] +
      ' #{battery_percentage}',
      bg: Colors[:host_bg],
      fg: Colors[:host_fg]
    }
  end

  def cpu_percentage
    if ENV['TMUX_PLUGIN_MANAGER_PATH']
      `#{ENV['TMUX_PLUGIN_MANAGER_PATH']}/tmux-cpu/scripts/cpu_status.sh`.strip
    else
      raise "Missing env variable: TMUX_PLUGIN_MANAGER_PATH"
    end
  end

  def battery_percentage
    if ENV['TMUX_PLUGIN_MANAGER_PATH']
      `#{ENV['TMUX_PLUGIN_MANAGER_PATH']}/tmux-battery/scripts/battery_percentage.sh`.strip
    else
      raise "Missing env variable: TMUX_PLUGIN_MANAGER_PATH"
    end
  end
end
