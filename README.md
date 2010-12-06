Mass-ID
=======
detect object by weight.


Serial-Socket-Gateway
=====================

Mass-ID Controller uses serial-socket-gateway to connect with Arduino.

install [serial-socket-gateway](https://github.com/shokai/serial-socket-gateway) and run it.

    % git clone git@github.com:shokai/serial-socket-gateway.git
    % serial-socket-gateway /dev/tty.usb-devicename


Mass-ID Controller
==================
Mass-ID controller reads sensor value from arduino, process it and open web browser.


Dependencies
------------

install rubygems

    % gem install bundler
    % bundle install

see "Gemfile".


Config
------

    % cp sample.config.yaml config.yaml


Calibrate
---------

start serial-socket-gateway, then

    % ruby main.rb calibrate

edit config.yaml


Run Controller
--------------

    % ruby main.rb
