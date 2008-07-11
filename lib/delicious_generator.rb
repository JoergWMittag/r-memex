require "ridiculous"
include Ridiculous

class DeliciousGenerator
  
  def initialize(tag=nil)
    @tag = tag
    @post = Post.new
  end
  
  def generate(node_container)
    posts = @post.all(:tag=>@tag)
    posts.each do |post|
      post_node = Node.new(post["description"], post["href"])
      post["tags"].split.each { |tag| post_node.add_tag(tag) }
      node_container.add_node(post_node)
    end
  end
  
end