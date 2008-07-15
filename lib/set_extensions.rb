require 'set'

module SetExtensions
  def join(sep = nil)
    @hash.keys.join(sep)
  end
end

class Set
  include SetExtensions
end
