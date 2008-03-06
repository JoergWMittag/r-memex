require "test/unit"

require "relation"
require "node"

class TestRelation < Test::Unit::TestCase
  def test_initialisation
    relation = Relation.new("name")
    assert_not_nil(relation)
    assert_equal("name", relation.name)
  end
  
  def test_gleich?
    node1 = Relation.new("Name")
    node2 = Relation.new("Name")
    node3 = Relation.new("Other")
    assert_equal(node1, node2)
    assert_not_equal(node1, node3)

    node1.source="src"
    node1.dest="dst"
    node2.source="src"
    node2.dest="dst"
    assert_equal(node1, node2)

    node1.source = "source"
    assert_not_equal(node1, node2)

    node2.source = "source"
    assert_equal(node1, node2)
    node1.dest = "destignation"

    assert_not_equal(node1, node2)
    node2.dest = "destignation"
    assert_equal(node1, node2)
  end
  
  def test_weight
    rel = Relation.new("name")
    assert_equal(rel.weight, 1.0)
    rel.weight=5.5
    assert_equal(rel.weight, 5.5)
    assert_not_equal(rel.weight, 5.4)
  end
end
