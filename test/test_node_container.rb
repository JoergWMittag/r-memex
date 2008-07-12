require File.join(File.dirname(__FILE__), 'test_helper')
require "set"

require "node_container"
require "relation"

class TestNodeContainer < Test::Unit::TestCase
  def test_initialisation
      assert_not_nil(NodeContainer.new)
  end

  def test_gleich
    nc1 = NodeContainer.new
    nc2 = NodeContainer.new
    assert_equal(nc1, nc2)
    
    node1 = Node.new("node")
    node2 = Node.new("node")
    assert_equal(node1, node2)

    nc1.add_node(node1)
    nc2.add_node(node2)
    assert_equal(nc1, nc2)
    
    rel1 = Relation.new("relation")
    rel2 = Relation.new("relation")
    assert_equal(rel1, rel1)

    nc1.add_relation(rel1, node1, node1)
    nc2.add_relation(rel2, node2, node2)
    assert_equal(rel1, rel2)
    
    assert_equal(node1, node2)
    
    assert_equal(nc1, nc2)
    
  end

  def test_save
    nc1 = NodeContainer.new
    node = Node.new("test_node")
    nc1.add_node(node)
    nc1.add_relation(Relation.new("some name"), node, node)
    nc1.save("some.name")
    file = File.new("some.name", 'r')
    nc2 = Marshal.load(file)
    file.close
    assert_equal(nc1, nc2)
  end
  
  def test_load
    nc1 = NodeContainer.new
    node = Node.new("some node name")
    nc1.add_node(node)
    nc1.add_relation(Relation.new("some relation name"), node, node)
    file = File.new("other.file", 'w')
    Marshal.dump(nc1, file)
    file.close
    nc2 = NodeContainer.load("other.file")
    assert_equal(nc1, nc2)
  end

  def test_generate_using
    nc = NodeContainer.new
    builder = mock()
    builder.expects(:generate).once.with(nc)
    nc.generate_using(builder)
  end

  def test_add_node
    nc1 = NodeContainer.new
    node1 = Node.new("node1")
    nc1.add_node(node1)
    assert_equal(Set.new([node1]), nc1.nodes)
    
    nc2 = NodeContainer.new
    nc2.add_node("node1")
    assert_equal(nc1, nc2)
    assert_equal(nc2.nodes.sort, Set.new([node1]).sort)
  end

  def test_remove_node
    nc = NodeContainer.new
    node1 = mock()
    node2 = mock()
    rel12 = mock()
    
    node1.expects(:add_relation).once.with(rel12)
    node2.expects(:add_relation).once.with(rel12)
    rel12.expects(:source=).with(node1)
    rel12.expects(:dest=).with(node2)

    nc.add_node(node1)
    nc.add_node(node2)
    nc.add_relation(rel12, node1, node2)
    
    
    node1.expects(:relations).once.returns(Set.new([rel12]))
    rel12.expects(:source).once.returns(node1)
    rel12.expects(:dest).once.returns(node2)
    node1.expects(:remove_relation).once.with(rel12)
    node2.expects(:remove_relation).once.with(rel12)
    nc.remove_node(node1)
    assert_equal(Set.new([]), nc.relations)
  end

  def test_list_tags
    nc = init_tags
    tagset = Set.new(%w[Tag1 Tag2 Tag3])
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
    mc1 = NodeContainer.new
    node1 = Node.new("name1")
    node2 = Node.new("name2")
    mc1.add_node(node1)
    mc1.add_node(node2)
    rel1 = Relation.new("rel_name1")
    rel2 = Relation.new("rel_name2")
    mc1.add_relation(rel1, node1, node1)
    assert_equal(mc1.relations, Set.new([rel1]))
    mc1.add_relation(rel2, node2, node2)
    assert_equal(mc1.relations, Set.new([rel1, rel2]))
  end

  def test_remove_relation
    nc = NodeContainer.new
    node1 = mock()
    node2 = mock()
    rel12 = mock()
    
    node1.expects(:add_relation).once.with(rel12)
    node2.expects(:add_relation).once.with(rel12)
    rel12.expects(:source=).with(node1)
    rel12.expects(:dest=).with(node2)

    nc.add_node(node1)
    nc.add_node(node2)
    nc.add_relation(rel12, node1, node2)

    rel12.expects(:source).once.returns(node1)
    rel12.expects(:dest).once.returns(node2)
    node1.expects(:remove_relation).once.with(rel12)
    node2.expects(:remove_relation).once.with(rel12)
    nc.remove_relation(rel12)
    assert_equal(Set.new([]), nc.relations)
  end

  def test_node_by_tag
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
    assert_equal(Array.new([node2]), nc.nodes_by_tag("tag_b"))
    assert_equal(Array.new([node1, node4]), nc.nodes_by_tag("tag_a"))
  end
  
  def test_node_by_name
    nc = NodeContainer.new
    node1 = Node.new("a")
    node2 = Node.new("a")
    node3 = Node.new("c")
    node4 = Node.new("d")
    nc.add_node(node1)
    nc.add_node(node2)
    nc.add_node(node3)
    nc.add_node(node4)
    assert_equal(Array.new([node1, node2]), nc.nodes_by_name("a"))
    assert_equal(Array.new([node3]), nc.nodes_by_name("c"))
  end

  def test_merge
    nc1 = NodeContainer.new
    node1 = mock()
    rel1 = mock()
    rel1.expects(:source=).once
    rel1.expects(:dest=).once
    node1.expects(:add_relation).at_least_once.with(rel1)
    
    node2 = mock()
    rel2 = mock()
    rel2.expects(:source=).once
    rel2.expects(:dest=).once
    node2.expects(:add_relation).at_least_once.with(rel2)
    
    nc1.add_node(node1)
    nc1.add_node(node2)
    nc1.add_relation(rel1, node1, node1)
    nc1.add_relation(rel2, node2, node2)

    nc2 = NodeContainer.new
    node3 = mock()
    rel3 = mock()
    rel3.expects(:source=).once
    rel3.expects(:dest=).once
    node3.expects(:add_relation).at_least_once.with(rel3)
    
    node4 = mock()
    rel4 = mock()
    rel4.expects(:source=).once
    rel4.expects(:dest=).once
    node4.expects(:add_relation).at_least_once.with(rel4)
    
    nc2.add_node(node3)
    nc2.add_node(node4)
    nc2.add_relation(rel3, node3, node3)
    nc2.add_relation(rel4, node4, node4)

    nodes = Set.new
    nodes.merge(nc1.nodes)
    nodes.merge(nc2.nodes)

    relations = Set.new()
    relations.merge(nc1.relations)
    relations.merge(nc2.relations)

    nc1.merge(nc2)
    assert_equal(nodes, nc1.nodes)
    assert_equal(relations, nc1.relations)
  end
  
  def test_to_s
    node = mock()
    node.expects(:to_s).returns("Return String 1")
    
    nc = NodeContainer.new
    nc.add_node(node)
    
    str = <<END_OUTPUT
Node:
Return String 1
END_OUTPUT

    assert_equal(str, nc.to_s)
  end
  
  private

  def init_tags
    nc = NodeContainer.new
    node1 = Node.new("Node1")
    node2 = Node.new("Node2")
    node1.add_tag("Tag1")
    node2.add_tag("Tag3")
    node2.add_tag("Tag1")
    node2.add_tag("Tag2")
    nc.add_node(node1)
    nc.add_node(node2)
    return nc
  end

end