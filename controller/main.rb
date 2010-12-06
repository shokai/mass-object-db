#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'rubygems'
require 'bundler/setup'
require 'socket'
require 'eventmachine'
require 'yaml'
require 'rainbow'

$KCODE = 'u'
calibrate = true if ARGV.first =~ /^c/i

begin
  conf = YAML::load open(File.dirname(__FILE__)+'/config.yaml')
rescue => e
  STDERR.puts 'config.yaml load error'.color(:red)
  STDERR.puts e.to_s.color(:red)
  exit 1
end
p conf
unless calibrate
  zv = conf['weights']['0']
  p gs = conf['weights'].keys.delete_if{|k|k=='0'}.map{|k|
    v = conf['weights'][k]
    (zv - v)/k.to_f
  }
  puts g1 = gs.inject{|a,b|a+b}.to_f/gs.size # 1グラムあたりのAD値の変化
end

begin
  s = TCPSocket.open(conf['serial_socket_gateway']['host'], conf['serial_socket_gateway']['port'].to_i)
rescue => e
  STDERR.puts e.to_s.color(:red)
  STDERR.puts 'cannot connect serial-socket-gateway'.color(:red)
end

weight = 0 # sensor
median = 0
g = 0 # weight (g)
last_weight = 0
weight_tmps = Array.new

EventMachine::run do
  EventMachine::defer do
    loop do
      res = s.gets
      exit unless res
      res.chop!.strip!
      next if res.to_s.size < 1
      weight_tmps << res.to_i
      if weight_tmps.size >= 100
        weight = (weight_tmps.inject{|a,b|a+b}.to_f/weight_tmps.size)
        median = weight_tmps.map{|i|
          d = i-weight
          d *= -1 if d < 0
          d
        }.inject{|a,b|a+b}/weight_tmps.size
        if median < 1.5
          puts "sensor : #{weight}".color(:green)
        else
          puts "sensor : #{weight}".color(:red)
        end
        puts "median : #{median}"
        weight_tmps.clear
      end
    end
  end

  EventMachine::defer do
    loop do
      break if calibrate
      g = (zv-weight)/g1
      g = g.to_i

      puts "weight : #{g} (g)".color(:green)
      if median < 1.5 and (g < last_weight-5 or last_weight+5 < g) # センサ値平均がガタついてない時
        if -5 < g and g < 5 # 何も無い
          last_weight = 0
          puts 'detect => !empty!'.color(200,0,0)
        else
          begin
            #url = "http://localhost:8092/g/#{g}"
            url = "#{conf['gyazo']}#{g}"
            puts url.color(:blue)
            puts `open #{url}`
          rescue => e
            STDERR.puts e.color(:red)
          end
          last_weight = g
        end
      end
      sleep 1
    end
  end

  EventMachine::defer do
    loop do
      s.puts gets
    end
  end
end

