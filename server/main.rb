#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'yaml'

begin
  @@conf = YAML::load open(File.dirname(__FILE__)+'/config.yaml').read
  p @@conf
  @@range = @@conf['mass_range'].to_i
rescue => e
  STDERR.puts 'config.yaml load error!'
  STDERR.puts e
end

before do
  Mongoid.configure{|conf|
    conf.master = Mongo::Connection.new(@@conf['mongo_server'], @@conf['mongo_port']).db(@@conf['mongo_dbname'])
  }
end

def app_root
  "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}#{env['SCRIPT_NAME']}"
end

get '/' do
  @title = 'Mass ID'
  erb :index
end

get '/g/*' do
  param = params[:splat].first
  status 404 unless param =~ /^\d+$/
  @g = param.to_i
  #erb :weight
  @g.to_s
end

post '/api/item.json' do
  name = params['name']
  mass = params['mass'].to_i
  if !name or !mass
    status 500
    @mes = {:error => 'name and mass required'}.to_json
  end
  o = Item.new(
               :name => name,
               :mass => mass
               )
  o.save
  @mes = o.to_json
end

get '/api/items.json' do
  range = @@range
  range = params['range'].to_i if params['range'] and params['range'] =~ /^\d+$/
  mass = params['mass'].to_i if params['mass'] and params['mass'] =~ /^\d+$/
  name = params['name'] if params['name']

  objs = nil
  if !mass and !name
    objs = Item.find(:all)
  else
    objs = Item.where(:mass.gt => mass - range ,
                      :mass.lt => mass + range,
                      :name => /#{name}/)
  end
  res = {
    :count => objs.size,
    :objects => objs
  }
  res['mass'] = mass if mass
  res['name'] = name if name
  res['range'] = range if range
  @mes = res.to_json
end

