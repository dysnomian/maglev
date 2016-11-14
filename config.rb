require "#{FF_DIR}/helpers.rb"

#TODO bootstrapping script?
class Config
  include Helpers

  def self.config_file
    begin
      File.read(Dir.home + "/.config/fairyfloss/config.yml", "r")
    rescue => e
      tmux_message("Error reading config file: #{e}")
    end
  end
end
