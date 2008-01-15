require "test/unit"

require "relation"
require "node"

class TestRelation < Test::Unit::TestCase
  def test_initialisation
    assert_not_nil(Relation.new(Node.new("1"), Node.new("2"), "Name"))
  end
end
