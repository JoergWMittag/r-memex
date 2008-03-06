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
    rel1 = Relation.new("Name")
    rel2 = Relation.new("Name")
    rel3 = Relation.new("Other")
    assert_equal(rel1, rel2)
    assert_not_equal(rel1, rel3)

    rel1.source="src"
    rel1.dest="dst"
    rel2.source="src"
    rel2.dest="dst"
    assert_equal(rel1, rel2)

    rel1.source = "source"
    assert_not_equal(rel1, rel2)

    rel2.source = "source"
    assert_equal(rel1, rel2)
    rel1.dest = "destignation"

    assert_not_equal(rel1, rel2)
    rel2.dest = "destignation"
    assert_equal(rel1, rel2)
  end
  
  def test_weight
    rel = Relation.new("name")
    assert_equal(rel.weight, 1.0)
    rel.weight=5.5
    assert_equal(rel.weight, 5.5)
    assert_not_equal(rel.weight, 5.4)
  end
end
