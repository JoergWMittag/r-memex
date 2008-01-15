class Relation
  attr_reader :orig, :dest, :name

  def initialize(orig, dest, name)
    @orig = orig
    @dest = dest
    @name = name
  end

end
