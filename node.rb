require "set"
require "uri"

class Node

  attr_reader :name, :tags, :location, :description, :time
  attr_reader :incoming_relations, :outgoing_relations

  def initialize(name, url_string="http://localhost/", time=Time.now)
    @name = name
    @location = URI.parse(url_string)
    @tags = Set.new
    @incoming_relations = Set.new
    @outgoing_relations = Set.new
    @time = time
    @sub_nodes = []
  end

  def location=(uri_string)
    @location = URI.parse(uri_string)
  end
  
  def description=(desc)
    @description = desc.to_s
  end
  
  def time=(time)
    @time = time
  end
  
  def add_tag(tag)
    @tags << tag
  end

  def remove_tag(tag)
    @tags.delete(tag)
  end

  def has_tag?(tag)
    return tags.include?(tag)
  end
  
  def add_incoming_relation(rel)
    rel.dest = self
    @incoming_relations << rel
  end
  
  def remove_incoming_relation(rel)
    rel.dest = nil
    @incoming_relations.delete(rel)
  end
  
  def add_outgoing_relation(rel)
    rel.source = self
    @outgoing_relations << rel
  end
  
  def remove_outgoing_relation(rel)
    rel.source = nil
    @outgoing_relations.delete(rel)
  end

end
