module ReadyForI18N
  class GlobalTranslations
  	class << self
  		attr_accessor :keys, :yaml
  	end

  	def self.keys
  		@keys ||= load_global_keys
  	end

  	private	
    
    def self.load_global_keys
      globals_yaml_file_path = ENV.fetch('GLOBAL_TRANSLATIONS_FILE', './config/locales/en/global.en.yml')
      yaml = YAML.load(File.read(globals_yaml_file_path))
      @keys = yaml.select{|k,v| v.is_a?(String)}.keys
    end

  end
end

