module ReadyForI18N
  class I18nGenerator
    EXTRACTORS = [ErbHelperExtractor,HtmlTextExtractor]
    PATH_PATTERN = /\/views\/(.*)/
    
    def self.excute(opt)
      setup_options(opt)

      Dir.glob(File.join(@src_path,"**#{File::SEPARATOR}*#{@ext}")).each do |f|
        next if f =~ /\.js/

        if opt['dot'] && f =~ PATH_PATTERN
          path = f.match(PATH_PATTERN)[1].gsub(/#{@ext}$/,'').split '/'
          path[-1].gsub!(/(((^|\A)_)|\.\w+)/, '')
        end

        result = EXTRACTORS.inject(File.read(f)) do |buffer, extractor|
          extractor.new.extract(buffer) { |k, v| @dict.push(k, v, path) }
        end

        write_target_file(f, result) if @target_path
      end
      @dict.write_to STDOUT
    end

  private

    def self.setup_options(opt)
      @src_path = opt['source']
      @locale = opt['locale']
      @ext = opt['extension'] || '.erb'

      @dict =
        if opt['nokey']
          NoKeyDictionary.new(@locale)
        else
          @target_path = opt['destination']

          @target_path = "#{@target_path}#{File::SEPARATOR}" if
              @target_path && !@target_path.end_with?(File::SEPARATOR)

          LocaleDictionary.new(@locale)
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
