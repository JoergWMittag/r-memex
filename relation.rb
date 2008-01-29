class Relation
  attr_reader :name
  attr_accessor :source, :dest

  def initialize(name)
    @name = name
  end

end
