require "set"
require "uri"

class Node

  attr_reader :name, :tags, :location, :description

  def initialize(name)
    @name = name
    @tags = Set.new
    #@relations = Array.new
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

end
