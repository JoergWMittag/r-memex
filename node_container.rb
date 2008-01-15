require "set"
require "node"


class NodeContainer
  attr_reader :nodes, :relations
  
  def initialize
    @nodes = Set.new
    @relations = Set.new
  end
  
  def add_relation(rel)
    if (@nodes.include?(rel.orig) && @nodes.include?(rel.dest))
      @relations.add(rel)
    end
  end
  
  def remove_relation(rel)
    @relations.delete(rel)
  end
    
  def add_node(node)
    @nodes.add(node)
  end
  
  def remove_node(node)
    @nodes.delete(node)
  end
  
  def list_tags
    tags = Set.new
    @nodes.collect {|item| tags.merge(item.tags)}
    return tags
  end
  
  def absolute_frequency(tag)
    freq = 0
    @nodes.collect do |node|
       if node.has_tag?(tag)
         freq += 1
       end
     end
    return freq
  end
  
  def absolute_frequencies
    freq = Hash.new(0)
    @nodes.collect do |node|
      node.tags.each do |tag|
        freq[tag] = freq[tag]+1
      end
    end
    return freq
  end
  
  def relative_frequencies
    freq = absolute_frequencies
    freq.each {|key, value| freq[key]=value/@nodes.size}
  end
  
end