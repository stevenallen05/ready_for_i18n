require 'stringio'

module ReadyForI18N
  module ExtractorBase
    MAX_WORDS_PER_KEY = 12

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

    attr_reader :global_keys, :namespace, :area, :tool

    def initialize(namespace: nil, area: nil, tool: nil)
      @namespace = namespace
      @area = area
      @tool = tool
    end

    def extract(input)
      buffer = StringIO.new
      input.each_line do |line|
        unless skip_line?(line)

        values_in_line(line).each do |phrase|
          key = to_key(phrase)
          value = to_value(phrase)
          if can_replace?(phrase, line) # && !skip_values.include?(value) && skip_keys.include?(key)
            yield(key, value) if block_given?
              replace_line(line, phrase)
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
                 val.scan(/\w+/)[0...MAX_WORDS_PER_KEY].join('_').downcase
               end

      "#{"#{key_prefix}_" if key_prefix}#{result}"
    end

    def can_replace?(phrase, line = nil)
      if ignorable_content.any?{|ignorable| phrase.match(ignorable) }
        # puts "\n\nIgnoring => #{phrase} \n#{line}"
        return false 
      end
      phrase.strip.size > 1
    end

    def ignorable_content
      [/.*(:)$/, 
        /Superuser|&amp;/i, 
        /data-\w+\s?=/, 
        /^"?'?\d{1}'?"?/,
        /class=/,
        /:00/,
      ]
       # /\(/, /\)/,
      # [/\(1 in US, 54 in Mexico\)/, /\.{3}/, /\w+:\s*$/, /\d{1,2}/, /\w{1}/, /&amp;/ ]  
    end

    def t_method(val, wrap = false)
      t = ENV.fetch("I18N_T_METHOD", 'I18n.t')
      key = to_key(val)

      translation_key = if GlobalTranslations.keys.include?(key)
                          "views.global.#{key}"
                        elsif ExtractorBase.use_dot?
                          ".#{key}"
                        else
                          [namespace, area, tool, key].compact.reject{|s| s.empty?}.join('.')
                        end
      translation_key.strip!
      # puts "#{translation_key}: #{val}" unless  GlobalTranslations.keys.include?(key)
      wrap ? "<%= #{t}('#{translation_key}') %>" :  "#{t}('#{translation_key}')"
    end
  end
end
