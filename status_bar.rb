module FairyflossTheme
  class StatusBar
    def segments
      @segments ||= []
    end

    def add_segment(content:, bg:, fg:)
      return self if content == nil

      last_segment = segments.last || nil_segment.new
      new_segment = FairyflossTheme::RightSegment.new(
        content: content,
        fg: fg,
        bg: bg,
        old_fg: last_segment.fg,
        old_bg: last_segment.bg)

      segments << new_segment
      self
    end

    def to_s
      segments.map(&:to_s).join("")
    end

    def nil_segment
      Struct.new("NilSegment", :bg, :fg)
    end
  end
end

