class Relation
  attr_reader :source, :dest, :name

  def initialize(source, dest, name)
    @source = source
    @dest = dest
    @name = name
  end

end
