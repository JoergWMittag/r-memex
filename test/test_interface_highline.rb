require "test/unit"

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'bin')
require "interface_highline"

class TestController < Test::Unit::TestCase
  
  def setup
    @ctrl = Controller.new
  end
  
  def test_tagstr_to_array
    expected = ["Test1", "Test2", "Test 3", "Test4"]
    actual = @ctrl.tagstr_to_array("Test1, Test2, Test 3, Test4")
    assert_equal(expected, actual)
  end
end


require "node"

class TestView < Test::Unit::TestCase
  
  def setup
    @input    = StringIO.new
    @output   = StringIO.new
    @terminal = HighLine.new(@input, @output)
    @view = View.new
    @view.term = @terminal    
  end
  
  def test_edit_node
    node = Node.new("NodeName")
    @view.edit_node(node)
    assert_equal("Editing Node: NodeName\n", @output.string)
  end
end