require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'

require "active_support/core_ext/class/attribute" # for class_attribute
require "action_dispatch/http/mime_type"
require "active_support/json"
require "active_support/core_ext/object/conversions" # rails ticket https://gist.github.com/971766

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rjson'

class Test::Unit::TestCase
end
