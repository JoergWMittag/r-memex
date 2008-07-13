begin require 'rubygems'; rescue LoadError
else begin gem 'scrobbler', '~> 0.1.1'; rescue Gem::LoadError; end end
require "scrobbler"

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
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
      friend_node = Node.new(friend.username)
      node_container.add_node(friend_node)
      relation1 = Relation.new("Friend")
      node_container.add_relation(relation1, user_node, friend_node)
      relation2 = Relation.new("Friend")
      node_container.add_relation(relation2, friend_node, user_node)
    end
  end
end
