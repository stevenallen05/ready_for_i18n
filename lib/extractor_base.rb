require 'stringio'

module ReadyForI18N
  module ExtractorBase
    def self.use_dot(on_off)
      @use_dot = on_off
    end

    def self.use_dot?
      @use_dot
    end

    def self.key_mapper=(mapper)
      @key_mapper = mapper
    end

    def self.key_mapper
      @key_mapper
    end

    def extract(input)
      buffer = StringIO.new
      input.each_line do |line|
        unless skip_line?(line)

          values_in_line(line).each do |e|
            if can_replace?(e)
              yield(
                to_key(e),
                to_value(e)
              ) if block_given?

              replace_line(line, e)
            end
          end
        end

        buffer << line
      end

      buffer.string
    end

    def to_key(s)
      val = to_value(s)

      result = if ExtractorBase.key_mapper
                 ExtractorBase.key_mapper.key_for(val)
               else
                 val.scan(/\w+/).join('_').downcase
               end
      "#{"#{key_prefix}_" if key_prefix}#{result}"
    end

    def can_replace?(e)
      e.strip.size > 1
    end

    def t_method(val, wrap = false)
      t = ENV.fetch("I18N_T_METHOD", 't')
      key = to_key(val)
      m = ExtractorBase.use_dot? ? "#{t}('.#{key}')" : "#{t}('#{key}')"
      wrap ? "<%=#{m}%>" : m
    end
  end
end
