require "test/unit"

require "relation"
require "node"

class TestRelation < Test::Unit::TestCase
  def test_initialisation
    assert_not_nil(Relation.new("Name"))
  end
end
