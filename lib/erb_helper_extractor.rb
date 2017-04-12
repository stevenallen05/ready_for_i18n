module ReadyForI18N
  class ErbHelperExtractor
    include ReadyForI18N::ExtractorBase

    LABEL_IN_HELPER_PATTERN =
      %w{
        label_tag link_to field_set_tag submit_tag button_to content_tag
      }.map { |h| /#{h}[(\s\w_,:]*('|")([\w ]*)(\1)/ }

    protected

    def values_in_line(line)
      LABEL_IN_HELPER_PATTERN.each_with_object([]) { |h, res| res << line.match(h).captures.join if line =~ h }
    end

    def skip_line?(s)
      false
    end

    def to_value(s)
      s.strip[1..-2]
    end

    def replace_line(line, e)
      line.gsub!(e, t_method(e))
    end

    def key_prefix
      'label'
    end
  end
end