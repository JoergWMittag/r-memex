require "test/unit"
require "set"

require "node"

class TestTestNode < Test::Unit::TestCase
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
end