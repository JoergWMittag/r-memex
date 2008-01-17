require "test/unit"
require "set"
require "uri"

require "node"
require "relation"

class TestNode < Test::Unit::TestCase
  def test_initialisation
    assert_not_nil(Node.new("NodeName"))
  end

  def test_add_tag
    node = Node.new("NodeName")
    node.add_tag("Tag_Name")
    node.add_tag("Tag_Name") #it is a set?
    assert_equal(1, node.tags.length)
    assert_equal(Set.new(["Tag_Name"]), node.tags)
  end

  def test_remove_tag
    node = Node.new("NodeName")
    node.add_tag("Tag_Name1")
    node.add_tag("Tag_Name2")
    node.remove_tag("Tag_Name1")
    assert_equal(1, node.tags.length)
    assert_equal(Set.new(["Tag_Name2"]), node.tags)
  end

  def test_includes_tag
    node = Node.new("NodeName")
    node.add_tag("Tag_Name_1")
    assert_equal(true, node.has_tag?("Tag_Name_1"))
    assert_equal(false, node.has_tag?("Tag_Name_2"))
  end
  
  def test_set_uri
    node = Node.new("NodeName")
    node.set_uri("http://www.ruby.org")
    assert_equal(URI.parse("http://www.ruby.org"), node.location)
    assert_raise(URI::InvalidURIError) { node.set_uri("mal formed") }
  end
  
  def test_set_description
    node = Node.new("NodeName")
    node.set_description("Description and more")
    assert_equal("Description and more", node.description)
    assert_not_equal("Unexpected", node.description)
  end
  
  def test_add_incoming_relation
    node = Node.new("Node1")
    rel = nil
    node.add_incoming_relation(rel)
    assert_equal(Set.new([rel]), node.incoming_relations)
  end
  
  def test_add_outgoing_relation
    node = Node.new("Node1")
    rel = nil
    node.add_outgoing_relation(rel)
    assert_equal(Set.new([rel]), node.outgoing_relations)
  end
  
  def test_get_all_relations
    node = Node.new("Node2")
    rel1 = Relation.new(nil, nil, nil)
    rel2 = Relation.new(nil, nil, nil)
    node.add_outgoing_relation(rel1)
    node.add_incoming_relation(rel2)
    assert_equal(Set.new([rel1, rel2]), node.get_all_relations)
  end

end
