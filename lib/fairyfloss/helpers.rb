module Helpers
  def tmux_message(msg)
    `tmux show-message #{msg}`
  end
end
