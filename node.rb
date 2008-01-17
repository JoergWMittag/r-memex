require "set"
require "uri"

class Node

  attr_reader :name, :tags, :location, :description, :incoming_relations, :outgoing_relations

  def initialize(name)
    @name = name
    @tags = Set.new
    @incoming_relations = Set.new
    @outgoing_relations = Set.new
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
  
  def set_uri(uri_string)
    @location = URI.parse(uri_string)
  end
  
  def set_description(desc)
    @description = desc.to_s
  end
  
  def get_all_relations
    Set.new(@incoming_relations).merge(@outgoing_relations)
  end
  
  def add_incoming_relation(rel)
    @incoming_relations.add(rel)
  end
  
  def add_outgoing_relation(rel)
    @outgoing_relations.add(rel)
  end

end
