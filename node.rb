require "set"
require "uri"

class Node
  include Comparable

  attr_accessor :name, :creation_time
  attr_reader :relations, :tags, :location, :description

  def initialize(name)
    @name = name
    @location = nil
    @creation_time = Time.now
    @tags = Set.new
    @relations = Set.new
  end
  
  def <=>(obj)
    name <=> obj.name
  end
  
  def ==(obj)
    @name == obj.name && @location == obj.location \
     && @tags == obj.tags \
      && @relations.sort == obj.relations.sort
  end
  
  def eql?(obj)
    @name == obj.name && @location == obj.location \
     && @tags == obj.tags \
      && @relations.sort == obj.relations.sort
  end
  
  def location=(uri_string)
    @location = URI.parse(uri_string)
  end
  
  def description=(desc)
    @description = desc.to_s
  end

  def add_tag(tag)
    @tags << tag
  end

  def remove_tag(tag)
    @tags.delete(tag)
  end

  def includes_tag?(tag)
    return tags.include?(tag)
  end
  
  def add_relation(rel)
    @relations << rel
  end
  
  def remove_relation(rel)
    @relations.delete(rel)
  end
  
  def to_s
    str = "Name: " + @name + "\n"
    str += "Location: " + @location.to_s + "\n"
    str += "Creation Time: " + @creation_time.to_s + "\n"
    str += "\n"
    return str
  end

end
