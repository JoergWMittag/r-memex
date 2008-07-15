$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'set_extensions'
require 'node'

class NodeContainer
  attr_reader :nodes, :relations

  def initialize
    @nodes = Set.new
    @relations = Set.new
  end

  def ==(obj)
    obj.nodes.sort == nodes.sort &&
      obj.relations.sort == relations.sort
  end

  def eql?(obj)
    obj.nodes.sort.eql?(nodes.sort) &&
      obj.relations.sort.eql?(relations.sort)
  end

  def generate_using(builder)
    builder.generate(self)
  end

  def save(location)
    file = File.new(location, 'w')
    Marshal.dump(self, file)
    file.close
  end

  def self.load(location)
    file = File.new(location, 'r')
    return Marshal.load(file)
  end

  def add_relation(rel, source, dest)
    if (nodes.include?(source) && nodes.include?(dest))
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
    if (node.instance_of?(String))
      @nodes << Node.new(node)
    else
      @nodes << node
    end
  end

  def remove_node(node)
    @nodes.delete(node)
    #delete orphaned childs
    node.relations.each { |rel| remove_relation(rel) }
  end

  def list_tags
    return @nodes.inject(Set[]) { |tags, item| tags.merge(item.tags) }
  end

  def absolute_frequency(tag)
    return @nodes.select { |node| node.tags.include?(tag) }.size
  end

  def absolute_frequencies
    return @nodes.inject(Hash.new(0)) do |freq, node|
      node.tags.each { |tag| freq[tag] += 1 }
      freq
    end
  end

  def relative_frequencies
    freq = absolute_frequencies
    freq.each { |key, value| freq[key] = value.to_f / @nodes.size }
  end

  def nodes_by_tag(tag)
    return @nodes.select {|node| node.includes_tag?(tag)}
  end

  def nodes_by_name(name)
    return @nodes.select {|node| node.name.eql?(name)}
  end

  def merge(node_container)
    @nodes.merge(node_container.nodes)
    @relations.merge(node_container.relations)
  end

  def to_s
    return @nodes.inject('') { |str, node| str << "Node:\n#{node}\n"}
  end
end
