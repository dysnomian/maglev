module TmuxOptions
  extend self
  include Helpers

  def set(option, value)
    `tmux set-option -gq '#{option}' '#{value}'`
  end

  def get(option, default_value=nil)
    current_value = `tmux show-option -gqv #{option}`

    current_value != "" ? current_value : default_value
  end

  def run_script(plugin, script)
    script_path = ENV["TMUX_PLUGIN_MANAGER_PATH"] +
                    plugin +
                    "/scripts/" +
                    script

    begin
      `#{script_path}`
    rescue
      tmux_message("Couldn't find #{script} for #{plugin}. Is it installed?")
    end
  end
end

