#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), 'test_helper')

require 'relation'

class TestRelation < Test::Unit::TestCase
  def test_initialize
    assert_not_nil(relation = Relation.new('name'))
    assert_equal('name', relation.name)
  end

  def test_equality
    rel1 = Relation.new('Name')
    rel2 = Relation.new('Name')
    rel3 = Relation.new('Other')
    assert(rel1 == rel2, 'Should be ==')
    assert(rel1.eql?(rel2), 'Should be eql!')
    assert(!(rel1 == rel3), 'Should *not* be ==')
    assert(!rel1.eql?(rel3), 'Should not be eql!')
  end

  def test_weight
    rel = Relation.new('name')
    assert_in_delta(1.0, rel.weight, 1E-100)
    rel.weight=5.5
    assert_in_delta(5.5, rel.weight, 1E-100)
    assert_not_equal(5.4, rel.weight)
  end
end
