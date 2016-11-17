#!/usr/bin/env ruby

Dir.chdir(ENV["TMUX_PLUGIN_MANAGER_PATH"] + "tmux-fairyfloss")

require_relative "lib/fairyfloss"

FairyflossTheme.apply_theme
