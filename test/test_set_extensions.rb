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
    assert_match(/[abc]{3}/, @set.join)
    assert_match(/[abc]{3}/, @set.join(nil))
  end

  def test_join_with_seperator
    assert_match(/[abc], [abc], [abc]/, @set.join(', '))
  end

  def test_join_with_default_seperator
    old_seperator = $,
    $, = 'TEST'
    assert_equal '', Set[].join
    assert_equal '', Set[].join(', ')
    assert_match(/[abc]TEST[abc]TEST[abc]/, @set.join)
    # Array#join with nil is unspecified. Copy this (non-)behaviour for our Set#join.
    #assert_match(/[abc]TEST[abc]TEST[abc]/, @set.join(nil))
    assert_match(/[abc], [abc], [abc]/, @set.join(', '))
    $, = old_seperator
  end
end
