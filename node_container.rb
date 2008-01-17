require "set"
require "node"


class NodeContainer
  attr_reader :nodes, :relations

  def initialize
    @nodes = Set.new
    @relations = Set.new
  end

  def add_relation(rel)
    if (@nodes.include?(rel.source) && @nodes.include?(rel.dest))
      rel.source.add_outgoing_relation(rel)
      rel.dest.add_incoming_relation(rel)
      @relations << rel
    end
  end

  def remove_relation(rel)
    @relations.delete(rel)
  end

  def add_node(node)
    @nodes << node
  end

  def remove_node(node)
    @nodes.delete(node)
    node.get_all_relations.each { |rel| remove_relation(rel) }
  end

  def list_tags
    tags = Set.new
    @nodes.collect { |item| tags.merge(item.tags) }
    return tags
  end

  def absolute_frequency(tag)
    freq = 0
    @nodes.collect { |node| freq += 1 if node.has_tag?(tag) }
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
    return Set.new(@nodes.select {|node| node.has_tag?(tag)})
  end

end
