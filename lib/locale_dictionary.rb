module ReadyForI18N
  class LocaleDictionary
    attr_reader :namespace, :area, :tool
    def initialize(locale:, namespace: nil, area: nil, tool: nil)
      @locale = locale
      @namespace = namespace
      @area = area
      @tool = tool
      @hash = {}
    end

    def push(key, value, path = nil)
      h = @hash
      # puts [key, value, path]
      path.each do |p|
        h[p] ||= {}
        h = h[p]
      end if path

      h[key] = value
    end

    def write_to(out)
      # out.puts "#{@locale}:"
      out.puts({"#{@locale}" => @hash}.to_yaml(:SortKeys => true))
      fname = 'i18n_keys.yml' # ['ready_for_I18n', namespace, area, tool].compact.join('_') + '.yml'
      File.open(fname, 'w') {|f| f.write({@locale => @hash}.to_yaml(:SortKeys => true))}
    end
  end
end