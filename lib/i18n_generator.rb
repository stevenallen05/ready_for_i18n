require 'find'

module ReadyForI18N
  class I18nGenerator
    EXTRACTORS = [ErbHelperExtractor,HtmlTextExtractor,HtmlAttrExtractor]
    PATH_PATTERN = /\/views\/(.*)/



    def self.extractors(name = 'HtmlTextExtractor')
      if name =='all'
        EXTRACTORS
      else
        EXTRACTORS.select {|e| e.to_s.match(name)}
      end
    end

    def self.excute(opt)
      setup_options(opt)
      puts "starting scan at #{@src_path}"
      Find.find(@src_path).each do |f|
        next unless File.file?(f) && File.extname(f)=='.erb'
        next if f.match(/js.erb$/)
        
        next if @restrict_to && f.match(@restrict_to).nil?
        # next if f.match(/app\/views\/company_area\///)
        
        puts f
        puts "------- loading file #{f}"

        if opt['dot'] && f =~ PATH_PATTERN
          path = f.match(PATH_PATTERN)[1].gsub(/#{@ext}$/,'').split '/'
          path[-1].gsub!(/(((^|\A)_)|\.\w+)/, '')
          path.unshift(@namespace) if @namespace && !@namespace.empty?
        else
          path = [@namespace, @area, @tool].compact
        end
        debug "using path #{path}"

        result = extractors().inject(File.read(f)) do |buffer, extractor|
          debug "using #{extractor} on  file #{f}"
          ex = extractor.new(namespace: @namespace, area: @area, tool: @tool,)
          ex.extract(buffer) { |key, phrase| @dict.push(key, phrase, path) }
        end

        write_target_file(f, result) if @target_path
      end
      @dict.write_to STDOUT
    end

  private

    def self.setup_options(opt)
      @src_path = opt['source']
      @restrict_to = Regexp.new(opt['restrict_to']) if opt['restrict_to']
      @locale = opt['locale'] || 'en'
      @ext = opt['extension'] || '.erb'
      @destination = opt['destination']
      @namespace = opt['namespace']
      @area = opt['area']
      @tool = opt['tool']
      @extractors = opt['extractors'] || 'all'

      @dict =
        if opt['nokey']
          NoKeyDictionary.new(@locale)
        else
          @target_path = opt['destination']

          @target_path = "#{@target_path}#{File::SEPARATOR}" if
              @target_path && !@target_path.end_with?(File::SEPARATOR)

          LocaleDictionary.new(locale: @locale, namespace: @namespace, area: @area, tool: @tool)
        end

      if opt['keymap']
        files_content = opt['keymap'].split(':').map{ |f| File.read(f) }
        ReadyForI18N::ExtractorBase.key_mapper = KeyMapper.new(*files_content)
      end

      ExtractorBase.use_dot(!!opt['dot'])
    end

    def self.write_target_file(source_file_name, content)
      full_target_path = File.dirname(source_file_name)
        .gsub(@src_path, @target_path)

      FileUtils.makedirs full_target_path

      target_file = File.join(full_target_path, File.basename(source_file_name))

      File.open(target_file, 'w+') { |f| f << content }
    end
  end
end
