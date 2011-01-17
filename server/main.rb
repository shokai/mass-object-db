#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

before do
  Mongoid.configure{|conf|
    conf.master = Mongo::Connection.new(@@conf['mongo_server'], @@conf['mongo_port']).db(@@conf['mongo_dbname'])
  }
  @title = 'Mass ID'
end

def app_root
  "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}#{env['SCRIPT_NAME']}"
end

get '/' do
  haml :index
end

get '/g/*' do
  param = params[:splat].first
  status 404 unless param =~ /^\d+$/
  @g = param.to_i
  haml :g
end

post '/api/item.json' do
  content_type 'application/json'
  name = params['name'].to_s
  mass = params['mass'].to_i
  if !name or name.size < 1 or !mass or mass < 1
    status 500
    @mes = {:error => 'name and mass required'}.to_json
  end
  o = Item.new(
               :name => name,
               :mass => mass
               )
  o.save
  @mes = o.to_hash.to_json
end

get '/api/items.json' do
  content_type 'application/json'
  range = @@range
  range = params['range'].to_i if params['range'] and params['range'] =~ /^\d+$/
  mass = params['mass'].to_i if params['mass'] and params['mass'] =~ /^\d+$/
  name = params['name'] if params['name']
  
  objs = nil
  if !mass and !name
    items = Item.find(:all).asc(:mass).asc(:name)
  else
    items = Item.where(:mass.gt => mass - range ,
                       :mass.lt => mass + range,
                       :name => /#{name}/).asc(:mass).asc(:name)
  end
  items = items.map{|i|i.to_hash}
  res = {
    :count => items.size,
    :items => items
  }
  res['mass'] = mass if mass
  res['name'] = name if name
  res['range'] = range if range
  @mes = res.to_json
end

