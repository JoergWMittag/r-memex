require "Scrobbler"

class LastFMGenerator
  
  def initialize(username)
    @user = Scrobbler::User.new(username)
  end
  
  def generate(node_container)
    
  end
  
end