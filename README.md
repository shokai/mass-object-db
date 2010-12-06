mass-id
=======
detect object by weight.


Controller
==========

Dependencies
------------

install [serial-socket-gateway](https://github.com/shokai/serial-socket-gateway) and run it.

    % git clone git@github.com:shokai/serial-socket-gateway.git


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


Run
===

    % ruby main.rb
