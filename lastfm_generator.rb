require "rubygems"
require "scrobbler"

require "node_container"
require "relation"

class LastFMGenerator
  
  def initialize(username)
    @user = Scrobbler::User.new(username)
  end
  
  def generate(node_container)
    user_node = Node.new(@user.username)
    node_container.add_node(user_node)
    friends = @user.friends
    friends.each do |friend|
      friend_node = Node.new(friend.username, friend.url)
      node_container.add_node(friend_node)
      node_container.add_relation(Relation.new("Friend", user_node, friend_node))
      node_container.add_relation(Relation.new("Friend", friend_node, user_node))
    end
  end
  
end