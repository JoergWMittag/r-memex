require 'uri'
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'set_extensions'

class Node
  include Comparable

  attr_accessor :name
  attr_writer :creation_time
  attr_reader :relations, :tags, :location, :description

  def initialize(name)
    @name = name
    @creation_time = Time.now
    @tags = Set[]
    @relations = Set[]
  end

  def <=>(obj)
    name <=> obj.name
  end

  def ==(obj)
    @name == obj.name &&
      @location == obj.location &&
      @tags == obj.tags &&
      @relations.sort == obj.relations.sort
  end

  def eql?(obj)
    @name == obj.name &&
      @location == obj.location &&
      @tags == obj.tags &&
      @relations.sort == obj.relations.sort
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

  def includes_tag?(*tag_or_tags)
    return tag_or_tags.flatten.all? {|tag| @tags.include?(tag)}
  end

  def add_relation(rel)
    @relations << rel
  end

  def remove_relation(rel)
    @relations.delete(rel)
  end

  def to_s
    return <<-HERE
Name: #{@name}
Location: #{@location}
Creation Time: #{@creation_time}
Tags:#{@tags.length > 0 ? ' ' << @tags.join(', ') : nil}
    HERE
  end
end
