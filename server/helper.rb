require 'rack'
require 'sinatra/reloader'
require 'bson'
require 'mongoid'
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

Mongoid.configure{|conf|
  conf.master = Mongo::Connection.new(@@conf['mongo_server'], @@conf['mongo_port']).db(@@conf['mongo_dbname'])
}

def app_root
  "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}#{env['SCRIPT_NAME']}"
end

before do
  @title = 'Mass Object DB'
end
