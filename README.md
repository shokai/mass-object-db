Mass-ID
=======
detect object by weight.


Mass-ID Server
==============
Mass-ID Server is webapp built with Sinara. It is object-weight database.

Dependencies
------------

* MongoDB 1.6+
* Sinatra


Setup
-----

    % cd server
    % bundle install
    % cp sample.config.yaml config.yaml

edit config.yaml.


Run
---
    % ruby development.ru

or, use passenger.


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

edit config.yaml, then

    % cd controller
    % bundle install
    % ./mass-id-controller /dev/tty.usb-device calibrate




Run Controller
--------------

    % ./mass-id-controller /dev/tty.usb-device

