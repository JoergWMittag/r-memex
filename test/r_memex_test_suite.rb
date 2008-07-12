#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), 'test_helper')

Dir[File.join(File.dirname(__FILE__), '**/test_*.rb')].reject do |file|
  file =~ /test_(helper|suite)\.rb$/
end.each { |test| require test }
