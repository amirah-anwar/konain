class Favourite < ActiveRecord::Base

  belongs_to :favourited, polymorphic: true
  belongs_to :user

  after_save :set_property_delta_flag
  after_destroy :set_property_delta_flag

  private

  def set_property_delta_flag
    property = Property.find_by_id favourited_id
    return if property.blank?
    property.delta = true
    property.save
  end

end
