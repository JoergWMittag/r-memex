#!/usr/bin/env ruby

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'interface_highline'

View.new.menu_main if __FILE__ == $0
