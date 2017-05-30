require 'rubygems'
require 'ya2yaml'
require 'yaml'
require 'extractor_base'
require 'html_text_extractor'
require 'html_attr_extractor'
require 'erb_helper_extractor'
require 'locale_dictionary'
require 'no_key_dictionary'
require 'key_mapper'
require 'global_translations'
require 'i18n_generator'
require 'pry'

module ReadyForI18N
  SKIP_KEYS = ['&lt', '&rt']
end	

def debug msg
	puts msg if ENV['DEBUG']
end
