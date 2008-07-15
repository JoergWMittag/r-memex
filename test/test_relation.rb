#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), 'test_helper')

require 'relation'
require 'node'

class TestRelation < Test::Unit::TestCase
  def test_initialisation
    assert_not_nil(relation = Relation.new('name'))
    assert_equal('name', relation.name)
  end

  def test_gleich?
    rel1 = Relation.new('Name')
    rel2 = Relation.new('Name')
    rel3 = Relation.new('Other')
    assert_equal(rel1, rel2)
    assert(rel1.eql?(rel2), 'Should be eql!')
    assert_not_equal(rel1, rel3)
    assert(!rel1.eql?(rel3), 'Should not be eql!')
  end

  def test_weight
    rel = Relation.new('name')
    assert_equal(rel.weight, 1.0)
    rel.weight=5.5
    assert_equal(rel.weight, 5.5)
    assert_not_equal(rel.weight, 5.4)
  end
end
