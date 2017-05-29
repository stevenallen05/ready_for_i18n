require 'rubygems'
require 'minitest'
require 'minitest-spec-rails'
require 'minitest/pride'
require "minitest/autorun"
require 'pry'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'ready_for_i18n'

module Minitest::Assertions
  def assert_nothing_raised(*)
    yield
  end
end