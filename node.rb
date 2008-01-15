require "set"

class Node

  attr_reader :name, :tags

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

end
