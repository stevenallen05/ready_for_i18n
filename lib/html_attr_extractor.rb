module ReadyForI18N
  class HtmlAttrExtractor < HtmlTextExtractor
    SKIP_PATTERN = /<%(.*)%>/

    LABEL_TAG_ATTR_PATTERN = [
      [/<img(.*)(\/>|<\/img>)/i, /alt=["'](.*?)["']/i],
      [/<img(.*)(\/>|<\/img>)/i, /title=["'](.*?)["']/i],
      [/<input(.*)\s*type\s*=\s*["']submit["'](.*)/i, /value\s*=\s*["'](.*?)["']/i],
      [/<input(.*)\s*type\s*=\s*["']button["'](.*)/i, /value\s*=\s*["'](.*?)["']/i]
    ]

    protected

    def values_in_line(line)
      LABEL_TAG_ATTR_PATTERN.each_with_object([]) do |p, values|
        if line =~ p[0] && line =~ p[1]
          value = line.match(p[1])[1]
          values << value unless value =~ SKIP_PATTERN
        end
      end
    end

    def key_prefix
      'label'
    end

    def replace_line(line, e)
      line.sub!(e, t_method(e, true))
    end
  end
end
