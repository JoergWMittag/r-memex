require "set"
require "node"


class NodeContainer
  attr_reader :nodes, :relations

  def initialize
    @nodes = Set.new
    @relations = Set.new
  end
  
  def ==(obj)
    obj.nodes == @nodes \
      && obj.relations == @relations
  end
  
  def generate_using(builder)
    builder.generate(self)
  end

  def save(location)
    file = File.new(location, 'w')
    Marshal.dump(self, file)
    file.close
  end
  
  def load(location)
    file = File.new(location, 'r')
    return Marshal.load(file)
  end

  def add_relation(rel, source, dest)
    if (@nodes.include?(source) && @nodes.include?(dest))
      source.add_relation(rel)
      rel.source = source
      dest.add_relation(rel)
      rel.dest = dest
      @relations << rel
    end
  end

  def remove_relation(rel)
    rel.source.remove_relation(rel)
    rel.dest.remove_relation(rel)
    @relations.delete(rel)
  end

  def add_node(node)
    @nodes << node
  end

  def remove_node(node)
    @nodes.delete(node)
    #delete orphaned childs
    node.relations.each { |rel| remove_relation(rel) }
  end

  def list_tags
    tags = Set.new
    @nodes.collect { |item| tags.merge(item.tags) }
    return tags
  end

  def absolute_frequency(tag)
    freq = 0
    @nodes.collect { |node| freq += 1 if node.includes_tag?(tag) }
    return freq
  end

  def absolute_frequencies
    freq = Hash.new(0)
    @nodes.collect do |node|
      node.tags.each { |tag| freq[tag] += 1 }
    end
    return freq
  end

  def relative_frequencies
    freq = absolute_frequencies
    freq.each { |key, value| freq[key] = value.to_f / @nodes.size }
  end

  def get_nodes(tag)
    return Set.new(@nodes.select {|node| node.includes_tag?(tag)})
  end

  def merge(node_container)
    @nodes.merge(node_container.nodes)
    @relations.merge(node_container.relations)
  end

end
