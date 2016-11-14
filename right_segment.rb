module FairyflossTheme
  class RightSegment
    attr_reader :content, :fg, :bg, :old_bg, :old_fg

    def initialize(content:, fg:, bg:, old_bg: nil, old_fg: nil)
      @content = content
      @fg = fg
      @bg = bg
      @old_fg = old_fg
      @old_bg = old_bg
    end

    def to_s
      case
      when bg == old_bg
        Icons[:right_separator] + content
      when old_bg.nil?
        "#[fg=#{bg}]" +
          Icons[:right_separator] +
          "#[fg=#{fg},bg=#{bg},bold]#{content} "
      else
        "#[fg=#{old_bg}]" +
          Icons[:right_separator_black] +
          "#[fg=#{fg},bg=#{bg},bold]#{content} "
      end
    end
  end
end
