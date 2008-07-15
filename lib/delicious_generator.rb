begin require 'rubygems'; rescue LoadError
else begin gem 'Ridiculous', '~> 0.6'; rescue Gem::LoadError; end end
require 'ridiculous'
include Ridiculous

class DeliciousGenerator
  def initialize(tag=nil)
    @tag = tag
    @post = Post.new
  end

  def generate(node_container)
    @post.all(:tag=>@tag).each do |post|
      post_node = Node.new(post['description'], post['href'])
      post['tags'].split.each { |tag| post_node.add_tag(tag) }
      node_container.add_node(post_node)
    end
  end
end
