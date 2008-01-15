require "test/unit"

require "node_container"
require "node"
require "relation"

class TestNodeContainer < Test::Unit::TestCase
  def test_initialisation
      assert_not_nil(NodeContainer.new)
  end

  def test_add_node
    nc = NodeContainer.new
    node = Node.new("a")
    nc.add_node(node)
    assert_equal(Set.new([node]), nc.nodes)
  end

  def test_remove_node
    nc = NodeContainer.new
    node = Node.new("a")
    nc.add_node(node)
    nc.remove_node(node)
    assert_equal(Set.new([]), nc.nodes)
  end

  def test_list_tags
    nc = init_tags
    tagset = Set.new(["Tag1", "Tag2", "Tag3"])
    assert_equal(tagset, nc.list_tags)
  end

  def test_frequency_single
    nc = init_tags
    assert_equal(nc.absolute_frequency("Tag1"), 2)
    assert_equal(nc.absolute_frequency("Tag2"), 1)
    assert_not_equal(1, nc.absolute_frequency("Tag4"))
  end

  def test_frequencies
    nc = init_tags
    tf = Hash.new
    tf["Tag1"] = 2
    tf["Tag2"] = 1
    tf["Tag3"] = 1
    assert_equal(tf, nc.absolute_frequencies)
  end

  def test_relative_frequencies
    nc = init_tags
    tf = Hash.new
    tf["Tag1"] = 1.0
    tf["Tag2"] = 0.5
    tf["Tag3"] = 0.5
    assert_equal(tf, nc.relative_frequencies)
  end

  def test_add_relation
    nc = NodeContainer.new
    node1 = Node.new("a")
    node2 = Node.new("b")
    node3 = Node.new("c")
    nc.add_node(node1)
    nc.add_node(node2)
    rel1 = Relation.new(node1, node2, "Relation_1->2")
    rel2 = Relation.new(node1, node3, "Relation_1->3")
    nc.add_relation(rel1)
    assert_equal(Set.new([rel1]), nc.relations)
    nc.add_relation(rel2)
    assert_equal(Set.new([rel1]), nc.relations)
  end

  def test_remove_relation
    nc = NodeContainer.new
    node1 = Node.new("a")
    node2 = Node.new("b")
    node3 = Node.new("c")
    nc.add_node(node1)
    nc.add_node(node2)
    nc.add_node(node3)
    rel1 = Relation.new(node1, node2, "Relation_1->2")
    rel2 = Relation.new(node1, node3, "Relation_1->3")
    nc.add_relation(rel1)
    nc.add_relation(rel2)
    nc.remove_relation(rel1)
    assert_equal(Set.new([rel2]), nc.relations)
  end

  def test_get_nodes
    nc = NodeContainer.new
    node1 = Node.new("a")
    node2 = Node.new("b")
    node3 = Node.new("c")
    node4 = Node.new("d")
    nc.add_node(node1)
    nc.add_node(node2)
    nc.add_node(node3)
    nc.add_node(node4)
    node1.add_tag("tag_a")
    node2.add_tag("tag_b")
    node3.add_tag("tag_c")
    node4.add_tag("tag_d")
    node4.add_tag("tag_a")
    assert_equal(Set.new([node2]), nc.get_nodes("tag_b"))
    assert_equal(Set.new([node1, node4]), nc.get_nodes("tag_a"))
  end

  private

  def init_tags
    node1 = Node.new("Node1")
    node2 = Node.new("Node2")
    node1.add_tag("Tag1")
    node2.add_tag("Tag3")
    node2.add_tag("Tag1")
    node2.add_tag("Tag2")
    nc = NodeContainer.new
    nc.add_node(node1)
    nc.add_node(node2)
    return nc
  end

end