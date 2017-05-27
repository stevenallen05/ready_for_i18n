module ReadyForI18N
  class LocaleDictionary
    def initialize(locale = nil)
      @locale = locale || 'en'
      @hash = {}
    end

    def push(key, value, path = nil)
      h = @hash
      p [key, value, path]
      path.each do |p|
        h[p] ||= {}
        h = h[p]
      end if path

      h[key] = value
    end

    def write_to(out)
      # out.puts "#{@locale}:"
      out.puts({"#{@locale}" => @hash}.ya2yaml)
    end
  end
end