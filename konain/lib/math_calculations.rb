module MathCalculations

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def to_radians angle
      angle.to_f/180 * Math::PI
    end
  end

end
