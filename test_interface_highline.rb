require "test/unit"

require "interface_highline"

class TestController < Test::Unit::TestCase
  
  def setup
    @ctrl = Controller.new
  end
  
  def test_tagstr_to_array
    expected = ["Test1", "Test2", "Test 3", "Test4"]Å
    actual = @ctrl.tagstr_to_array("Test1, Test2, Test 3, Test4")
    assert_equal(expected, actual)
  end
end