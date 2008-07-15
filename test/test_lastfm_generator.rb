#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), 'test_helper')

require 'lastfm_generator'
require 'node_container'
begin gem 'scrobbler', '~> 0.1.1'; rescue Gem::LoadError; end
require 'scrobbler'

class TestLastfmGenerator < Test::Unit::TestCase
  def test_init
    assert_raise(ArgumentError) { LastfmGenerator.new(nil) }
    assert_not_nil(LastfmGenerator.new('tcb787'))
  end

  def test_generate
    generator = LastfmGenerator.new('tcb787')
    nodecontainer = NodeContainer.new
    generator.generate(nodecontainer)
    online_friends = Array.new
    nodecontainer.nodes.each { |node| online_friends.push(node.name) }
    actual_friends = %w[tcb787 OwlsToAthens amawbb berlin_alex klettermaster t-i-g-g-e-r Tornappart sankatze bitalias jaeddae pricelessperson wedgin SuziSonne analbina sariti littlewing_ Doml greenwonderland]
    assert_equal(actual_friends.sort, online_friends.sort)
  end

  def test_generate_new; end
end
