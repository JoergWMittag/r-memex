require "test/unit"

require "relation"
require "node"

class TestRelation < Test::Unit::TestCase
  def test_initialisation
    relation = Relation.new("name")
    assert_not_nil(relation)
    assert_equal("name", relation.name)
  end
  
  def test_weight
    rel = Relation.new("name")
    assert_equal(rel.weight, 1.0)
    rel.weight=5.5
    assert_equal(rel.weight, 5.5)
    assert_not_equal(rel.weight, 5.4)
  end
end
