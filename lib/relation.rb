class Relation
  attr_reader :name
  attr_accessor :source, :dest

  def initialize(name)
    @name = name
  end

  def ==(obj)
    name == obj.name
  end

  def eql?(obj)
    name.eql?(obj.name)
  end

  def weight
    if @weight
      return @weight
    else
      return 1.0
    end
  end

  def weight=(weight)
    @weight = weight
  end
end
