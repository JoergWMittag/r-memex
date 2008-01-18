require "test/unit"

require "lastfm_generator"

class TestLastFM < Test::Unit::TestCase
  
  def test_init
    assert_not_nil(LastFMGenerator.new)
  end
  
  def test_generate
    
  end
  
end