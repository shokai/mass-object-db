require 'sinatra/static_assets'
require 'sinatra/content_for'
require 'rack'
require 'sinatra/reloader'
require 'bson'
require 'mongoid'
gem 'mongoid','2.0.0.beta.20'
require 'json'
require File.dirname(__FILE__)+'/models/item'
require 'yaml'
require 'kconv'

begin
  @@conf = YAML::load open(File.dirname(__FILE__)+'/config.yaml').read
  p @@conf
  @@range = @@conf['mass_range'].to_i
rescue => e
  STDERR.puts 'config.yaml load error!'
  STDERR.puts e
end
