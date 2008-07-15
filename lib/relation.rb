class Relation
  attr_reader :name
  attr_accessor :source, :dest, :weight

  def initialize(name)
    @name = name
    @weight = 1.0
  end

  def ==(obj)
    name == obj.name
  end

  def eql?(obj)
    name.eql?(obj.name)
  end
end
