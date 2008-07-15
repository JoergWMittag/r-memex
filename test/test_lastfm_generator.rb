#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), 'test_helper')

require 'lastfm_generator'
require 'node_container'
begin gem 'scrobbler', '~> 0.1.1'; rescue Gem::LoadError; end
require 'scrobbler'

class TestLastfmGenerator < Test::Unit::TestCase
  def test_initialize
    assert_raise(ArgumentError) { LastfmGenerator.new }
    assert_raise(ArgumentError) { LastfmGenerator.new(nil) }
    assert_not_nil(LastfmGenerator.new('foo'))
  end

  def test_generate
    friends = %w[friend_a friend_b friend_c].collect { |c| stub(c, :username => c) }
    Scrobbler::User.stubs(:new).returns(stub('Scrobbler Stub', :username => 'username', :friends => friends))
    nodecontainer = NodeContainer.new
    LastfmGenerator.new('login_name').generate nodecontainer
    online_friends = nodecontainer.nodes.collect { |node| node.name }

    assert_equal(%w[friend_a friend_b friend_c username], online_friends.sort)
  end
end
