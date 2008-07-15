#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), 'test_helper')

require 'interface_highline'

class TestController < Test::Unit::TestCase
  def setup
    @ctrl = Controller.new
  end

  def test_tagstr_to_array
    expected = %W[Test1 Test2 Test\ 3 Test4]
    actual = @ctrl.tagstr_to_array('Test1, Test2, Test 3, Test4')
    assert_equal(expected, actual)
  end
end

require 'node'

# class TestView < Test::Unit::TestCase
#   def setup
#     @input    = StringIO.new
#     @output   = StringIO.new
#     @terminal = HighLine.new(@input, @output)
#     @view = View.new
#     @view.term = @terminal
#   end
# 
# end
