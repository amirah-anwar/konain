module PropertyTypes

  def self.included(base)
    base.extend ClassMethods
  end

  PROPERTY_TYPES = {
    "Sale" => ['Plot', 'House', 'Industrial Land', 'Farm House', 'Office', 'Shop', 'Agricultural Land', 'Plaza', 'Factory'],
    "Rent" => ['House', 'Farm House', 'Office', 'Shop', 'Plaza', 'Factory'],
  }

  PROPERTY_SUB_TYPES = {
    "Plot" =>  ['Residential', 'Commercial'],
    "House" => ['New', 'Used'],
    "Plaza" => ['New', 'Used'],
  }

  PROPERTY_FEATURES = {
    "Plot"   => ['Corner', 'Facing Park', 'Main Boulevard', 'Boundary', 'DP Poll', 'Access Area', 'Facing Mosque', 'Near Commercial', 'Near Graveyard', 'Market Nearby', 'Sui Gas'],
    "House"  => ['Imported Kitchen', 'Wooden Flooring', 'Market Nearby', 'Furnished', 'Sui Gas'],
    "Office" => ['Parking Area', 'Sui Gas', 'Furnished', 'Wooden Floor', 'Generator Facility'],
    "Shop"   => ['Parking Area', 'Generator Facility'],
    "Plaza"  => ['Parking Area', 'Lift', 'Security', 'Generator Facility'],
  }

  module ClassMethods
    def fetch_all_types
      types = []
      PROPERTY_TYPES.collect{ |k,v| types << v }.flatten.uniq
    end
  end

end
