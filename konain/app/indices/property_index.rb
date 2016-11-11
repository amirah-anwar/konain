ThinkingSphinx::Index.define :property, with: :active_record, delta: true do

  join project
  join favourites
  join sub_project
  indexes title

  has 'CRC32(state)', as: :state, type: :integer
  has 'CRC32(properties.city)', as: :city, type: :integer
  has 'CRC32(category)', as: :category, type: :integer
  has 'CRC32(area_unit)', as: :area_unit, type: :integer
  has 'CRC32(property_type)', as: :property_type, type: :integer
  has "RADIANS(projects.latitude)",  as: :latitude, type: :float
  has "RADIANS(projects.longitude)", as: :longitude, type: :float
  has "CRC32(favourites.favourited_type)", as: :favourited_type, type: :integer
  has "CRC32(closed_at)", as: :closed_at, type: :integer

  has favourites.user_id, as: :favourited_user_id, type: :integer
  has price
  has featured
  has featured_at
  has home_listing
  has bedroom_count
  has bathroom_count
  has created_at
  has land_area, as: :land_area, type: :integer
  has user_id
  has agent_id
  has project_id
  has sub_project_id
  has id

  set_property min_infix_len: 3
end
