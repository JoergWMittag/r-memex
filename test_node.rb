require "test/unit"
require "rubygems"
require "mocha"
require "set"

require "node"

class TestNode < Test::Unit::TestCase
  def test_initialisation
    node = Node.new("NodeName")
    assert_not_nil(node)
    assert_equal("NodeName", node.name)
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
    assert_equal(true, node.includes_tag?("Tag_Name_1"))
    assert_equal(false, node.includes_tag?("Tag_Name_2"))
  end
  
  def test_set_location_with_malformed_uri
    node = Node.new("NodeName")
    URI.expects(:parse).once.raises(URI::InvalidURIError)
    assert_raise(URI::InvalidURIError) { node.location="malformed_uri" }

    URI.expects(:parse).once.returns("something")
    node.location="whatever"
    assert_equal("something", node.location)
  end
  
  def test_set_description
    node = Node.new("NodeName")
    node.description="Description and more"
    assert_equal("Description and more", node.description)
    assert_not_equal("Unexpected", node.description)
  end
  
  def test_add_incoming_relation
    node = Node.new("Node")
    rel = mock()
    rel.expects(:dest=).once.with(node)
    node.add_incoming_relation(rel)
    assert_equal(Set.new([rel]), node.incoming_relations)
  end
  
  def test_remove_incoming_relation
    node = Node.new("Node")
    rel = mock()
    rel.expects(:dest=).once
    node.add_incoming_relation(rel)
    rel.expects(:dest=).once.with(nil)
    node.remove_incoming_relation(rel)
    assert_equal(Set.new([]), node.incoming_relations)
  end
  
  def test_add_outgoing_relation
    node = Node.new("Node")
    rel = mock()
    rel.expects(:source=).once.with(node)
    node.add_outgoing_relation(rel)
    assert_equal(Set.new([rel]), node.outgoing_relations)
  end
  
  def test_remove_outgoing_relation
    node = Node.new("Node")
    rel = mock()
    rel.expects(:source=).once
    node.add_outgoing_relation(rel)
    rel.expects(:source=).once.with(nil)
    node.remove_outgoing_relation(rel)
    assert_equal(Set.new([]), node.outgoing_relations)
  end

end
