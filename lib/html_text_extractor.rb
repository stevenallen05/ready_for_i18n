module ReadyForI18N
  class HtmlTextExtractor
    include ReadyForI18N::ExtractorBase

    SEPERATOR = '_@@@_'

    SKIP_TAGS = [
      [/<script/i, /<\/script>/i],
      [/<%/, /%>/],
      [/<style/i, /\/style>/i]
    ]
    SKIP_INLINE_TAG = [
      /<script>(.*?)<\/script>/i,
      /\s*\)?\s*:?\s<%(.*?)%>\s*\(?/,
      /\s*\)?\s*:?\s*<(.*?)>\s*\(?/,
      /\s*\)?\s*:?\s*<(.*)$/,
      /^(.*)>\s*\(?/,
      /&nbsp;/
    ]

    protected

    def values_in_line(line)
      SKIP_INLINE_TAG.inject(line.clone) do |memo, tag|
        memo.gsub(tag, SEPERATOR)
      end.strip.split SEPERATOR
    end

    def skip_line?(s)
      return false if s.nil? || s.strip.size == 0

      jump_in_tag = SKIP_TAGS.find{ |start_tag, end_tag| s =~ start_tag}

      @stack ||= []
      @stack.push jump_in_tag[1] if jump_in_tag

      unless @stack.empty?
        end_tag_match = s.match(@stack.last)
        if end_tag_match
          @stack.pop
          return skip_line?(end_tag_match.post_match)
        end
      end

      return !@stack.empty?
    end

    def to_value(s)
      s.strip
    end

    def replace_line(line, e)
      repeat = line.scan(e).size
      replaced = t_method(e, true)
      return line if repeat == 0
      return line.sub!(e.strip, replaced) if repeat == 1

      if repeat > 1
        line.gsub!(/>\s*#{e}\s*</, ">#{replaced}<")
        line.gsub!(/>\s*#{e}/, ">#{replaced}")
      end
    end

    def key_prefix
      ENV.fetch('I18N_KEY_PREFIX', nil)
    end
  end
end
