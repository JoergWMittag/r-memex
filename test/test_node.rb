#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), 'test_helper')
require 'set_extensions'

require 'node'

class TestNode < Test::Unit::TestCase
  def test_initialize
    node = Node.new('NodeName')
    assert_not_nil(node)
    assert_equal('NodeName', node.name)
  end

  def test_equality
    node1 = Node.new('Name')
    node2 = Node.new('Name')
    assert(node1 == node2, 'Should be ==')
    assert(node1.eql?(node2), 'Should be eql')

    node1.name = 'Other'
    assert(!(node1 == node2), 'Should *not* be ==')
    assert(!node1.eql?(node2), 'Should not be equal')
    node1.name = 'Name'
    assert(node1 == node2, 'Should be ==')
    assert(node1.eql?(node2), 'Should be eql')
    node1.add_tag('Test')
    assert(!(node1 == node2), 'Should *not* be ==')
    assert(!node1.eql?(node2), 'Should not be equal')
    node2.add_tag('Test')
    assert(node1 == node2, 'Should be ==')
    assert(node1.eql?(node2), 'Should be eql')

    node1.location = 'http://localhost/'
    assert(!(node1 == node2), 'Should *not* be ==')
    assert(!node1.eql?(node2), 'Should not be equal')
    node2.location = 'http://localhost/'
    assert(node1 == node2, 'Should be ==')
    assert(node1.eql?(node2), 'Should be eql')

    node1.add_relation('Relation')
    assert(!(node1 == node2), 'Should *not* be ==')
    assert(!node1.eql?(node2), 'Should not be equal')
    node2.add_relation('Relation')
    assert(node1 == node2, 'Should be ==')
    assert(node1.eql?(node2), 'Should be eql')
  end

  def test_comparison
    node1 = Node.new('name1')
    node2 = Node.new('name2')
    node3 = Node.new('name3')
    node4 = Node.new('name3')
    assert_operator(node1, :<, node2, 'node1 should be less than node2')
    assert_operator(node1, :<, node3, 'node1 should be less than node3')
    assert_operator(node2, :<, node3, 'node2 should be less than node3')
    assert_operator(node2, :>, node1, 'node2 should be greater than node1')
    assert_operator(node3, :>, node1, 'node3 should be greater than node1')
    assert_operator(node3, :>, node2, 'node3 should be greater than node2')
    assert_operator(node3, :<=, node4, 'node3 should be less than or equal to node4')
    assert_operator(node3, :>=, node4, 'node3 should be greater than or equal to node4')
    assert(node2.between?(node1, node3), 'Should be between')
  end

  def test_add_tag
    node = Node.new('NodeName')
    node.add_tag('Tag_Name')
    node.add_tag('Tag_Name') #it is a set?
    assert_equal(1, node.tags.length)
    assert_equal(Set['Tag_Name'], node.tags)
  end

  def test_remove_tag
    node = Node.new('NodeName')
    node.add_tag('Tag_Name1')
    node.add_tag('Tag_Name2')
    node.remove_tag('Tag_Name1')
    assert_equal(1, node.tags.length)
    assert_equal(Set['Tag_Name2'], node.tags)
  end

  def test_includes_tag
    node = Node.new('NodeName')
    node.add_tag('Tag_Name_1')
    node.add_tag('Tag_Name_3')
    assert(node.includes_tag?('Tag_Name_1'))
    assert(!node.includes_tag?('Tag_Name_2'))
    assert(node.includes_tag?(['Tag_Name_1']))
    assert(node.includes_tag?(%w[Tag_Name_1 Tag_Name_3]))
  end

  def test_set_location_with_malformed_uri
    node = Node.new('NodeName')
    URI.expects(:parse).once.raises(URI::InvalidURIError)
    assert_raise(URI::InvalidURIError) { node.location='malformed_uri' }

    URI.expects(:parse).once.returns('something')
    node.location='whatever'
    assert_equal('something', node.location)
  end

  def test_set_description
    node = Node.new('NodeName')
    node.description='Description and more'
    assert_equal('Description and more', node.description)
    assert_not_equal('Unexpected', node.description)
  end

  def test_add_relation
    node = Node.new('Node')
    node.add_relation(:foo)
    assert_equal(Set[:foo], node.relations)
  end

  def test_remove_relation
    node = Node.new('Node')
    node.add_relation(:foo)
    node.remove_relation(:foo)
    assert_equal(Set[], node.relations)
  end

  #FIXME: Test is locale dependent, breaks e.g. in German locale ("Do" instead of "Thu")
  def test_to_s
    node = Node.new('NodeName')
    node.creation_time = Time.at(0)
    node.location = 'http://localhost/'
    node.add_tag('Tag1')
    node.add_tag('Tag2')
    node.add_tag('Tag3')
    str = <<-'END_OUTPUT'
Name: NodeName
Location: http://localhost/
Creation Time: Thu Jan 01 01:00:00 +0100 1970
Tags: Tag1, Tag2, Tag3
    END_OUTPUT
    assert_equal(str, node.to_s)

    node = Node.new('NodeName')
    node.creation_time = Time.at(0)
    node.location = 'http://localhost/'
    str = <<-'END_OUTPUT'
Name: NodeName
Location: http://localhost/
Creation Time: Thu Jan 01 01:00:00 +0100 1970
Tags:
    END_OUTPUT
    assert_equal(str, node.to_s)
  end
end
