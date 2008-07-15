#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), 'test_helper')
require 'set_extensions'

class TestSetExtensions < Test::Unit::TestCase
  def setup
    @set = Set[*%w[b a c]]
  end

  def test_join_with_empty_set
    assert_equal '', Set[].join
    assert_equal '', Set[].join(', ')
  end

  def test_join_without_seperator
    assert_equal 'abc', @set.join
    assert_equal 'abc', @set.join(nil)
  end

  def test_join_with_seperator
    assert_equal 'a, b, c', @set.join(', ')
  end

  def test_join_with_default_seperator
    old_seperator = $,
    $, = 'TEST'
    assert_equal '', Set[].join
    assert_equal '', Set[].join(', ')
    assert_equal 'aTESTbTESTc', @set.join
    assert_equal 'aTESTbTESTc', @set.join(nil)
    assert_equal 'a, b, c', @set.join(', ')
    $, = old_seperator
  end
end
