Mass-Object-Database
====================
detect object by weight.


Mass-Object Server
==================

Mass-Object Server is webapp built with Sinara. It is a object-weight database.

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


Mass-Object Controller
======================
Mass-Object controller reads sensor value from arduino, process it and open web browser.


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
    % ./mass-object-controller /dev/tty.usb-device calibrate




Run Controller
--------------

    % ./mass-object-controller /dev/tty.usb-device

