require "test/unit"

require "lastfm_generator"
require "node_container"
require "rubygems"
require "scrobbler"

class TestLastFMGenerator < Test::Unit::TestCase
  
  def test_init
    assert_raise(ArgumentError) { LastFMGenerator.new(nil) }
    assert_not_nil(LastFMGenerator.new("tcb787"))
  end
  
  def test_generate
    generator = LastFMGenerator.new("tcb787")
    nodecontainer = NodeContainer.new
    generator.generate(nodecontainer)
    online_friends = Array.new
    nodecontainer.nodes.each { |node| online_friends.push(node.name) }
    actual_friends = ["tcb787", "OwlsToAthens", "amawbb", "berlin_alex", "klettermaster", "t-i-g-g-e-r", "Tornappart", "sankatze", "bitalias", "jaeddae", "pricelessperson", "wedgin", "SuziSonne", "analbina", "sariti", "littlewing_", "Doml", "greenwonderland"]
    assert_equal(actual_friends.sort, online_friends.sort)
  end
  
  def test_generate_new
  end
  
end