#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

before do
  Mongoid.configure{|conf|
    conf.master = Mongo::Connection.new(@@conf['mongo_server'], @@conf['mongo_port']).db(@@conf['mongo_dbname'])
  }
  @title = 'Mass Class'
end

def app_root
  "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}#{env['SCRIPT_NAME']}"
end

get '/' do
  haml :index
end

get '/g/*' do
  @g = params[:splat].first.to_i
  status 404 unless @g =~ /^\d+$/
  haml :g
end

get '/item/*' do
  @id = params[:splat].first.to_s.toutf8
  @item = Item.find(@id) rescue @item = nil
  if @item
    haml :item
  else
    status 404
    @mes = 'item not found'
  end
end

get '/api/item/*.json' do
  content_type 'application/json'
  id = params[:splat].first.to_s.toutf8
  item = Item.find(id) rescue item = nil
  if item
    status 200
    @mes = item.to_hash.to_json
  else
    status 404
    @mes = {:error => 'item not found'}.to_json
  end
end

post '/api/item.json' do
  content_type 'application/json'
  name = params['name'].to_s.toutf8.gsub(/[　\t]/u,' ').strip
  mass = params['mass'].to_i
  img_url = params['img_url'].to_s.toutf8.strip
  img_url = nil unless img_url =~ /^(https?\:[\w\.\~\-\/\?\&\+\=\:\@\%\;\#\%]+)(.jpe?g|.gif|.png)$/
  if !name or name.size < 1 or !mass or mass < 1
    status 403
    @mes = {:error => 'name and mass required'}.to_json

  elsif Item.where(:name => name).count > 0
    status 403
    @mes = {:error => 'the name already exists'}.to_json
  else
    item = Item.new(
                 :name => name,
                 :mass => mass
                 )
    item.img_url = img_url
    item.save
    status 201
    @mes = item.to_hash.to_json
  end
end

put '/api/item/*.json' do
  content_type 'application/json'
  id = params[:splat].first.to_s.toutf8
  name = params['name'].to_s.toutf8.gsub(/[　\t]/u,' ').strip
  mass = params['mass'].to_i
  img_url = params['img_url'].to_s.toutf8.strip
  img_url = nil unless img_url =~ /^(https?\:[\w\.\~\-\/\?\&\+\=\:\@\%\;\#\%]+)(.jpe?g|.gif|.png)$/
  p img_url
  if id.size < 1
    status 403
    @mes = {:error => 'id required'}.to_json
  else
    item = Item.find(id) rescue item = nil
    unless item
      status 404
      @mes = {:error => 'item not found'}.to_json
    else
      item.name = name if name.size > 0
      item.mass = mass if mass > 0
      item.img_url = img_url if img_url
      p item
      item.save
      status 200
      @mes = item.to_hash.to_json
    end
  end
end

delete '/api/item/*.json' do
  content_type 'application/json'
  id = params[:splat].first.to_s.toutf8
  if id.size < 1
    status 403
    @mes = {:error => 'id required'}.to_json
  else
    item = Item.find(id) rescue item = nil
    unless item
      status 404
      @mes = {:error => 'item not found'}.to_json
    else
      item.delete
      @mes = {:message => 'deleted'}.to_json
    end
  end
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

